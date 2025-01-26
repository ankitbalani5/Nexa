import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handle Background Notification
Future<void> backgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    FireBaseNotification notificationService = FireBaseNotification();
    await notificationService.showNotification(message);
    print(
        'message ===  ${message.data}  ===   ${message.notification?.body}   ====   ${message.notification?.title}');
  }
}

class FireBaseNotification {
  static String? fcmToken;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initializeNotification() async {
    await _requestPermission();
    await _getToken();
    await _initializeLocalNotification();
    await _handleNotification();
  }

  Future<void> _requestPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<void> _getToken() async {
    fcmToken = await _firebaseMessaging.getToken();
    // Optionally, you can print the token or send it to your server
    print('==========================   fcmToken   ==============================');
    print('  $fcmToken');
    print('==========================   fcmToken   ==============================');
  }

  Future<void> _initializeLocalNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitializationSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings);

    _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.input != null) {
          print('notification type =   ${details.notificationResponseType}');
          print(
              'no details  =  ${details.id}  ===  ${details.notificationResponseType}  ==  ${details.input}   ===  ${details.payload}');
        } else {
          print(
              'no details  =  ${details.id}  ===  ${details.notificationResponseType}  ==  ${details.input}   ===  ${details.payload}');
        }
      },
    );
  }

  Future<void> _handleNotification() async {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    /// Handle Foreground Notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AndroidNotification? androidNotification = message.notification?.android;
      AppleNotification? appleNotification = message.notification?.apple;
      print('Received a foreground message');
      if (message.notification != null && androidNotification != null) {
        print(
            'message ===  ${message.data}  ===   ${message.notification?.body}   ====   ${message.notification?.title}');
        showNotification(message);
      } else if (message.notification != null && appleNotification != null) {
        showNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
    });

    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        showNotification(message);
      }
      print('FirebaseMessaging.instance.getInitialMessage');
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().microsecond;

      const androidNotificationDetails = AndroidNotificationDetails(
        'nexa',
        'NEXA',
        importance: Importance.max,
        priority: Priority.max,
        icon: '@drawable/ic_launcher',
        visibility: NotificationVisibility.public,
        channelShowBadge: true,
      );
      const iosNotificationDetails = DarwinNotificationDetails();

      NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails, iOS: iosNotificationDetails);

      if (message.notification != null) {
        await _localNotificationsPlugin.show(
          id,
          message.notification!.title ?? 'No Title',
          message.notification!.body ?? 'No Body',
          notificationDetails,
        );
      } else {
        print('No notification payload found.');
      }
    } catch (e) {
      print('notification error  ---  ${e.toString()}');
    }
  }
}
