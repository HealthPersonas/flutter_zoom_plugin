class ZoomOptions {
  String domain;
  String appKey;
  String appSecret;
  String jwtToken;

  ZoomOptions({this.domain, this.appKey, this.appSecret, this.jwtToken});
}

class ZoomMeetingOptions {
  String userId;
  String displayName;
  String meetingId;
  String meetingPassword;
  String zoomToken;
  String zoomAccessToken;
  String disableDialIn;
  String disableDrive;
  String disableInvite;
  String disableShare;
  String noDisconnectAudio;
  String noAudio;
  String noVideo;
  String noCamera;
  String customMeetingTitle;
  String noIDShow;

  ZoomMeetingOptions(
      {this.userId,
      this.displayName,
      this.meetingId,
      this.meetingPassword,
      this.zoomToken,
      this.zoomAccessToken,
      this.disableDialIn = 'true',
      this.disableDrive = 'true',
      this.disableInvite = 'true',
      this.disableShare = 'true',
      this.noDisconnectAudio = 'true',
      this.noAudio = 'false',
      this.noVideo = 'false',
      this.customMeetingTitle,
      });
}
