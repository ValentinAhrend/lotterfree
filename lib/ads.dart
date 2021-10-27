import 'dart:io';

class AdManager{
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1278455001254563~6271620141";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1278455001254563~2715518510";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get rewardedAdUnitIdEntry {
    if (Platform.isAndroid) {
      return "ca-app-pub-1278455001254563/5617014028";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1278455001254563/6463191835";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get rewardedAdUnitIdExit {
    if (Platform.isAndroid) {
      return "ca-app-pub-1278455001254563/4303932357";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1278455001254563/3182422374";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

}