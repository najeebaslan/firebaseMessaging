import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// Also monitors token refreshes and updates state.
class TokenMonitor extends StatefulWidget {
   TokenMonitor(this._builder);

  final Widget Function(String? token) _builder;

  @override
  State<StatefulWidget> createState() => _TokenMonitor();
}

class _TokenMonitor extends State<TokenMonitor> {
  String? _token;
  late Stream<String> _tokenStream;
    // String serverKey ='AAAAYdA1LO4:APA91bEnQJXszgrMRnNML0BD0ffV4YNqp3PI2wAdDgVJg2QqGYCIQzrvB2gBPKqoufJHqahMD5IFKzUw5Q109lHtoahptjDOSA0dubxFzDwc0TrvFczibVmto9r3dODpQohGGKfZW8CJ';

  void setToken(String? token) {
    log('FCM Token: $token');
    setState(() {
      _token = token;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getToken(
            vapidKey:_token)//this is Server key
        .then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
  }

  @override
  Widget build(BuildContext context) {
    return widget._builder(_token);
  }
}