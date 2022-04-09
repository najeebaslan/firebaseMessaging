import 'package:firebase_massage/notifivation/widget/message_list.dart';
import 'package:firebase_massage/notifivation/widget/meta_card.dart';
import 'package:firebase_massage/notifivation/widget/permissions.dart';
import 'package:firebase_massage/notifivation/widget/token_monitor.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:issue/export.dart';

import '../../main.dart';
import 'utils.dart';
import 'widget/message_view.dart';
import 'widget/rapid.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? _token;
  String serverKey =
      'AAAA3BP7y5o:APA91bG7YrVaHMVzZRCg6tbXgO0hDNuZgJgpeAy_gYx031fsTEezlcpAfBgYt_YUm05HBT_lQu1d7WnH0YXD80e7OFwhHhepyrT2iXAfB5PdWEtr0W4cPjOR4i2XMoG_-0l9l3MnkdBB';

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        log('getInitialMessage $message');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageView(args: message),
          ),
        );
        // Navigator.pushNamed(
        //   context,
        //   '/message',
        //   arguments: MessageArguments(message, true),
        // );
        // FuLlog(Navigator.pushNamed(
        //   context,
        //   '/message',
        //   arguments: MessageArguments(message, true),
        // ));
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
              //launch_background
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published!');
      log('getInitialMessage $message');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessageView(args: message),
        ),
      );
      // Navigator.pushNamed(
      //   context,
      //   '/message',
      //   arguments: MessageArguments(message, true),
      // );
    });
  }

  Future<void> sendPushMessage() async {
    if (_token == null) {
      log('Unable to send FCM message, no token exists.');
      return;
    }
    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=$serverKey' // 'key=YOUR_SERVER_KEY'
    };
    try {
      await http
          .post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            encoding: Encoding.getByName('utf-8'),
            headers: headers,
            body: UtilsNotification().constructFCMPayload(_token),
          )
          .then((value) => log(value.body.toString()));
      log('FCM request for device sent!');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> onActionSelected(String value) async {
    switch (value) {
      case 'subscribe':
        {
          log(
            'FlutterFire Messaging Example: Subscribing to topic "fcm_test".',
          );
          await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
          log(
            'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.',
          );
        }
        break;
      case 'unsubscribe':
        {
          log(
            'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".',
          );
          await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
          log(
            'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.',
          );
        }
        break;
      case 'get_apns_token':
        {
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS) {
            log('FlutterFire Messaging Example: Getting APNs token...');
            String? token = await FirebaseMessaging.instance.getAPNSToken();
            log('FlutterFire Messaging Example: Got APNs token: $token');
          } else {
            log(
              'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.',
            );
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Messaging'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: onActionSelected,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'subscribe',
                  child: Text('Subscribe to topic'),
                ),
                const PopupMenuItem(
                  value: 'unsubscribe',
                  child: Text('Unsubscribe to topic'),
                ),
                const PopupMenuItem(
                  value: 'get_apns_token',
                  child: Text('Get APNs token (Apple only)'),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () async {
            sendPushMessage();
            //  await   APIService().postToRapidApi().then((value) => log(value.toString()));
            // await APIService().getToRapidApi().then((value)=>log(value.toString()));
          },
          //sendPushMessage,
          backgroundColor: Colors.white,
          child: const Icon(Icons.send,color: Colors.blue,),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MetaCard('Permissions', MyPermissions()),
            MetaCard(
              'FCM Token',
              TokenMonitor((token) {
                _token = token;
                return token == null
                    ? const CircularProgressIndicator()
                    : Text(token, style: const TextStyle(fontSize: 12));
              }),
            ),
            const MetaCard('Message Stream', MessageList()),
          ],
        ),
      ),
    );
  }
}
