import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';


class UtilsNotification {
  int _messageCount = 0;
  // /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
  String constructFCMPayload(String? token) {
    _messageCount++;
    DateTime now = DateTime.now();
    String isoDate = now.toIso8601String();
    return jsonEncode({
      "to": token,
      // "mutable-content": true,
      "notification": {
        "title": "Note 3",
        "body": "11:41",
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "image":
            "https://raw.githubusercontent.com/najeebaslan/issue/master/assets/icon.png"
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "isScheduled": "true",
        "scheduledTime": "2022-03-28 03:17:00",
        //DateTime.now().subtract(Duration(minutes: 1)),
        //"2022-03-28 03:07:00",
        "title": "TITLE_HERE",
        "message": "MESSAGE_HERE",
      },
      // "sendAt":isoDate,
      // "2022–08–29T09: 12: 33.001Z" ,

      "priority": "high",
      // "to": "myopic"
// "data": {
//     "notification_type": "Nice Thoughts",
//     "post_details": {
//         "message": "hello",
//         "color": "#e0e0e0",
//         "url": "www.recurpost.com",
//         "img_url": "https://raw.githubusercontent.com/najeebaslan/issue/master/assets/icon.png",
//         "video_url": "",
//         "name": "abc xyz"
//     }
// },
// "priority": "high"
      // 'to': token,
      // 'data': {
      //   'via': 'FlutterFire Cloud Messaging!!!',
      //   'count': _messageCount.toString(),
      // },
      // 'notification': {
      //   'title': 'Hello FlutterFire!',
      //   'body': 'This notification (#$_messageCount) was created via FCM!',
      // },
      //https://raw.githubusercontent.com/najeebaslan/issue/master/assets/icon.png
    });
  }

  /// Maps a [AuthorizationStatus] to a string value.
  static Map<AuthorizationStatus, String> statusMap = {
    AuthorizationStatus.authorized: 'Authorized',
    AuthorizationStatus.denied: 'Denied',
    AuthorizationStatus.notDetermined: 'Not Determined',
    AuthorizationStatus.provisional: 'Provisional',
  };

  /// Maps a [AppleNotificationSetting] to a string value.
  static Map<AppleNotificationSetting, String> settingsMap = {
    AppleNotificationSetting.disabled: 'Disabled',
    AppleNotificationSetting.enabled: 'Enabled',
    AppleNotificationSetting.notSupported: 'Not Supported',
  };

  /// Maps a [AppleShowPreviewSetting] to a string value.
  static Map<AppleShowPreviewSetting, String> previewMap = {
    AppleShowPreviewSetting.always: 'Always',
    AppleShowPreviewSetting.never: 'Never',
    AppleShowPreviewSetting.notSupported: 'Not Supported',
    AppleShowPreviewSetting.whenAuthenticated: 'Only When Authenticated',
  };
}
