import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIService {
  // API key
  static const _api_key =
      'N2E4ZDc4MjQtNDdjZS00OGVmLWEwZjctYjc4ODIyYTdhNDNlOlNFQ3A5NmNQaDA1L05YSkVlSjJET0VibGs1c1RIcXk=';

  // Base API url
  static const String _baseUrl =
      'https://firebase-notification-scheduler.p.rapidapi.com/messages';

  // Base headers for Response url
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Basic $_api_key',
    'X-Rapidapi-Host': 'firebase-notification-scheduler.p.rapidapi.com',
    'X-Rapidapi-Key': 'c6ce3e78a1msh40a5ec51a65f4dap15d03fjsncf78da2e81df',
    'Host': 'firebase-notification-scheduler.p.rapidapi.com',
  };

  // Base API post data to Rapid 30
  Future<dynamic> postToRapidApi() async {
    log('await for send notification');
    DateTime dateTime = DateTime.now().add(const Duration(minutes: 6)).toUtc();
    try {
      Uri uri = Uri.parse(_baseUrl);
      final response = await http.post(uri,
          headers: _headers,
          body: json.encode({
            "payload": {
              "to":
                  "f40_iBgJSlqBpdLYXOzEUD:APA91bHy3kwelMfSnSKO8NIhYR-ZqBqnwkC67vN33dn8xQCx2vyZ4J6kV2P0YCk1i1HBUMW7I5_ULJ22EVsSuGwpM5Q271B7OWO3E53WP-6xfjzYGMmgM8obtjntaCoGSExzi9hZUIOc",
              "notification": {
                "title": "This Notification from rapidApi",
                "body": "Well Come Najeeb Aslan",
                "mutable_content": true,
                "sound": "Tri-tone"
              }
            },
            "sendAt": dateTime.toString(),
          }));

      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON.
        return json.decode(response.body);
      } else {
        // If that response was not OK, throw an error.
        throw Exception('Failed to load json data');
      }
    } catch (e) {
      log('Error $e');

      if (e is SocketException) {
        log('الخادم غير متصل تأكد من اتصالك بالإنترنت ');
      }
    }
  }

// Base API get data form Rapid
  Future<dynamic> getToRapidApi() async {
    try {
      Uri uri = Uri.parse(_baseUrl);
      final response = await http.get(
        uri,
        headers: _headers,
      );
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON.
        return json.decode(response.body);
      } else {
        // If that response was not OK, throw an error.
        throw Exception('Failed to load json data');
      }
    } catch (e) {
      log('Error $e');
    }
  }
}
