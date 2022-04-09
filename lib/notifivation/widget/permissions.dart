import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

/// Requests & displays the current user permissions for this device.
class MyPermissions extends StatefulWidget {
  const MyPermissions({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyPermissionsState();
}

class _MyPermissionsState extends State<MyPermissions> {
  bool _requested = false;
  bool _fetching = false;
  late NotificationSettings _settings;

  Future<void> requestPermissions() async {
    setState(() {
      _fetching = true;
    });

    NotificationSettings settings =await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,alert: true,sound: true,
    );

    setState(() {
      _requested = true;
      _fetching = false;
      _settings = settings;
    });
  }

  Future<void> checkPermissions() async {
    setState(() {
      _fetching = true;
    });

    NotificationSettings settings =await FirebaseMessaging.instance.getNotificationSettings();

    setState(() {
      _requested = true;
      _fetching = false;
      _settings = settings;
    });
  }

  Widget row(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title:', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_fetching) {
      return const CircularProgressIndicator();
    }

    if (!_requested) {
      return ElevatedButton(
          onPressed: requestPermissions,
          child: const Text('Request Permissions'));
    }

    return Column(children: [
      row('Authorization Status', UtilsNotification.statusMap[_settings.authorizationStatus]!),
      if (defaultTargetPlatform == TargetPlatform.iOS) ...[
        row('Alert', UtilsNotification.settingsMap[_settings.alert]!),
        row('Announcement', UtilsNotification.settingsMap[_settings.announcement]!),
        row('Badge', UtilsNotification.settingsMap[_settings.badge]!),
        row('Car Play', UtilsNotification.settingsMap[_settings.carPlay]!),
        row('Lock Screen', UtilsNotification.settingsMap[_settings.lockScreen]!),
        row('Notification Center', UtilsNotification.settingsMap[_settings.notificationCenter]!),
        row('Show Previews',UtilsNotification. previewMap[_settings.showPreviews]!),
        row('Sound', UtilsNotification.settingsMap[_settings.sound]!),
      ],
      ElevatedButton(
          onPressed: checkPermissions, child: const Text('Reload Permissions')),
    ]);
  }
}