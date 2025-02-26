import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import '../../config/variables.dart';
import 'firestore_service.dart';
import '../local/local_notifications_service.dart';

class FirebaseMessagingService {
  final FirebaseMessaging firebaseMessaging;
  final FirestoreService firestoreService;

  FirebaseMessagingService(this.firebaseMessaging,this.firestoreService);


  void initialize() {
    _requestPermission();
    _updateTokenOnRefresh();
  }

  Future<NotificationSettings> _requestPermission() async {
    return await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  void _updateTokenOnRefresh() {
    firebaseMessaging.onTokenRefresh.listen((String? fcmToken) async {
      firestoreService.updateToken(fcmToken);
    }, onError: (error) {
      print('Error getting token: $error');
    });
  }

  void messageListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message in the foreground!');
      if (message.notification != null) {
        print(message.notification!.title);
        LocalNotificationService.display(message);
      }
    });

    // FirebaseMessaging.onBackgroundMessage((RemoteMessage msg) async {
    //   try {
    //     if (msg.notification != null) {
    //       display(msg);
    //     }
    //   } catch (e) {
    //     print("ERROR FirebaseMessaging.onBackgroundMessage ${e}");
    //   }
    // });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        print(message.notification!.title);
        LocalNotificationService.display(message);
      }
    });
  }

  Future<void> sendPushNotification(String token, String body, String title) async {
    try {
      final jsonCredentials = await rootBundle.loadString(pathToFirebaseAdminSdk!);
      final creds = auth.ServiceAccountCredentials.fromJson(jsonCredentials);
      final client = await auth.clientViaServiceAccount(
        creds,
        ['https://www.googleapis.com/auth/cloud-platform'],
      );
      final notificationData = {
        "message": {
          "token": token,
          "data": {
            "title": title,
            "body": body,
          },
          "notification": <String, dynamic> {"title": title, "body": body},
          "android": {},
        }
      };
      final response = await client.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/$senderId/messages:send'),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode(notificationData),
      );

      client.close();
      if (response.statusCode == 200) {
        print("SUCCESS ON FCM REQUEST");
      }
    } catch(e) {
      print("Error sending Push Notification ${e}");
    }
  }

}