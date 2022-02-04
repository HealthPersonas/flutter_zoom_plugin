package com.decodedhealth.flutter_zoom_plugin;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

/** FlutterZoomPlugin */
public class FlutterZoomPlugin implements FlutterPlugin {

  /** Plugin registration. */
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    binding.getPlatformViewRegistry().registerViewFactory("flutter_zoom_plugin", new ZoomViewFactory(binding.getBinaryMessenger()));
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }
}
