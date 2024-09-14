import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotification {
  final _firebaseMessaging = FirebaseMessaging.instance;
  FirebaseNotification() {
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // TODO: If necessary send token to application server.
      print('FCM Token: $fcmToken');
    }).onError((err) {
      print('Error: $err');
    });

    print('Handling a background message $message');
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    final FCMToken = await _firebaseMessaging.getToken();
    print('FCM Token: $FCMToken');
  }
}
