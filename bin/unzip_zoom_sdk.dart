import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;

///
/// Get the root directory of the project.
/// For older versions of dart, just use the script property and go up
/// For newer versions, find the parent of the .dart_tool folder
///
Directory getProjectRoot() {
  String path = Platform.script.path;
  if (path.contains('.dart_tool')) {
    return Directory(path.substring(0, path.indexOf('.dart_tool')));
  } else {
    return Directory(path).parent.parent;
  }
}

///
/// Extract the required files from the iOS SDK.
///
/// The required are found in the following location:
///
///  - lib
///
/// The folders that need to be copied to the ios folder are located in the libs subfolder:
///
///  - MobileRTC.xcframework
///  - MobileRTCResources.bundle
///  - MobileRTCScreenShare.xcframework
///
void processIOS(List<FileSystemEntity> files) {
  print('Processing iOS SDK');
  Directory projectRoot = getProjectRoot();

  // unzip the SDK
  File sdk = files.firstWhere((f) => f.uri.pathSegments.last.startsWith('zoom-sdk-ios'), orElse: () => null);
  if (sdk == null) {
    print(' - iOS SDK not found. Please make sure it is copied into the sdk folder');
    exit(1);
  }
  print(' - Decompressing ${p.basename(sdk.path)}');
  Archive archive = ZipDecoder().decodeBytes(sdk.readAsBytesSync());

  // delete the existing folders
  print(' - Deleting existing files');
  List<String> folders = [
    'MobileRTC.framework',
    'MobileRTC.xcframework',
    'MobileRTCResources.bundle',
    'MobileRTCScreenShare.framework',
    'MobileRTCScreenShare.xcframework',
  ];
  Directory targetFolder = projectRoot.listSync().firstWhere((e) => e is Directory && p.basename(e.path) == 'ios');
  for (FileSystemEntity entity in targetFolder.listSync()) {
    if (folders.contains(p.basename(entity.path))) {
      entity.deleteSync(recursive: true);
    }
  }

  print(' - Extracting SDK files');
  for (ArchiveFile file in archive) {
    // String prefix = (devMode ? 'Sample&Libs-All' : 'Sample&Libs-DeviceOnly') + '/lib';
    String prefix = 'lib';
    if (file.name.contains(prefix) && file.isFile) {
      File targetFile = File(targetFolder.path + file.name.substring(file.name.indexOf(prefix) + prefix.length));
      targetFile.createSync(recursive: true);
      targetFile.writeAsBytesSync(file.content);
    }
  }
}

///
/// Extract the required files from the Android SDK.
///
/// The files to be extracted are located in the following location:
///
///  - mobilertc-android-studio/commonlib
///  - mobilertc-android-studio/mobilertc
///
/// They should be copied into the android/libs folder.
///
void processAndroid(List<FileSystemEntity> files) {
  print('Processing Android SDK');
  Directory projectRoot = getProjectRoot();

  // unzip the SDK
  File sdk = files.firstWhere((f) => f.uri.pathSegments.last.startsWith('zoom-sdk-android'), orElse: () => null);
  if (sdk == null) {
    print(' - Android SDK not found. Please make sure it is copied into the sdk folder');
    exit(1);
  }
  print(' - Decompressing ${p.basename(sdk.path)}');
  Archive archive = ZipDecoder().decodeBytes(sdk.readAsBytesSync());

  // delete the existing folders
  print(' - Deleting existing files');
  Directory targetFolder = projectRoot.listSync().firstWhere((e) => e is Directory && p.basename(e.path) == 'android');
  for (FileSystemEntity entity in targetFolder.listSync()) {
    if (p.basename(entity.path) == 'libs') {
      entity.deleteSync(recursive: true);
    }
  }

  print(' - Extracting SDK files');
  for (ArchiveFile file in archive) {
    if (p.basename(file.name) == 'commonlib.aar' || p.basename(file.name) == 'mobilertc.aar') {
      String prefix = 'mobilertc-android-studio';
      File targetFile = File(targetFolder.path + '/libs' + file.name.substring(file.name.indexOf(prefix) + prefix.length));
      targetFile.createSync(recursive: true);
      targetFile.writeAsBytesSync(file.content);
    }
  }
}

void main(List<String> args) {
  Directory projectRoot = getProjectRoot();
  Directory sdkFolder = projectRoot.listSync().firstWhere((e) => e is Directory && p.basename(e.path) == 'sdk');
  List<FileSystemEntity> files = sdkFolder.listSync();

  processIOS(files);
  processAndroid(files);
}
