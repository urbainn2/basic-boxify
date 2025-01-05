import 'package:boxify/app_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'dart:html' as html; // Import dart:html

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    logger.w('Initializing notifications');
    if (kIsWeb) {
      return;
    }
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    logger.w('Requesting permissions');
    // Request permission for iOS (if applicable)
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    logger.w('Getting FCM token');
    String? fcmToken;

    fcmToken = await messaging.getToken();

    logger.w('FCM Token: $fcmToken');

    // Initialize local notifications for displaying in foreground
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Create the notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name

      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        logger.w('Message title: ${message.notification!.title}');
        logger.w('Message body: ${message.notification!.body}');
        _showNotification(message);
      }
    });
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    if (!kIsWeb) {
      // For Android, we can use the BigPictureStyle to show a big image
      // as part of the notification (if provided in the message
      final BigPictureStyleInformation bigPictureStyleInformation =
          BigPictureStyleInformation(
        const DrawableResourceAndroidBitmap('drawable/notification_image'),
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        contentTitle: message.notification?.title ?? 'No title',
        summaryText: message.notification?.body ?? 'No body',
      );

      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'high_importance_channel', // id
        'High Importance Notifications', // name

        icon: '@android:drawable/ic_dialog_info', // Use default Android icon
        styleInformation: bigPictureStyleInformation,
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );

      final DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails();

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title ?? 'No title',
        message.notification?.body ?? 'No body',
        platformChannelSpecifics,
        payload: 'item x',
      );
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    logger.w("Handling a background message: ${message.messageId}");
  }

  static Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // handle the notification tapped logic here for iOS if needed);
    logger.w('Notification tapped' + id.toString());
  }
}
