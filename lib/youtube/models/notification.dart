import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_filex/open_filex.dart';
import 'package:whats_app_saver/youtube/models/download_helper.dart';

class LocalNotificationService {
  static final flutterNotificationService = FlutterLocalNotificationsPlugin();

  //Initialze
  static void intialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("mipmap/ic_launcher");

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await flutterNotificationService.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        final String? payload = details.payload;
        if (details.payload != null) {
          debugPrint('notification payload: ${payload.toString()}');
        }
        String videoFileName = DownloaderHelper.videoName;
        String audioFileName = DownloaderHelper.audioName;
        if (videoFileName.endsWith('mp4')) {
          OpenFilex.open(
                  "storage/emulated/0/InstaReelsDownloader/Video/$videoFileName")
              .then((value) {
            videoFileName = "";
          });
        }
        if (audioFileName.endsWith('mp3')) {
          print("audio file name $audioFileName");
          print("audio file name ${audioFileName.endsWith('mp3')}");

          OpenFilex.open(
                  "storage/emulated/0/InstaReelsDownloader/Audio/$audioFileName")
              .then((value) {
            audioFileName = "";
          });
        }
      },
    );
  }

  //Notification Details
  static Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('id', 'download',
            channelDescription: 'channel_description',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true);

    return const NotificationDetails(android: androidNotificationDetails);
  }

  //Show Notification
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    var details = await _notificationDetails();

    await flutterNotificationService.show(1, title, body, details);
  }

  //Show Progress Notification
  static Future<void> showProgressNotification({
    required int progrss,
    required int maxProgress,
    required String title,
    required String body,
  }) async {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('progress channel', 'progress channel',
            channelDescription: 'progress channel description',
            channelShowBadge: false,
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: maxProgress,
            progress: progrss);
    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterNotificationService.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  //Cancel All Notifications
  static Future<void> cancelAllNotifications() async {
    try {
      await flutterNotificationService.cancelAll();
    } catch (e) {
      print("cancelAllNotifications Method Error ! = $e");
    }
  }

  //Cancel Custom Notification with ID
  static Future<void> cancelCustomNotification({int id = 0}) async {
    await flutterNotificationService.cancel(id);
  }
}
