import 'dart:isolate';
import 'package:blescanning/util/GeolocatorService.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:blescanning/util/GeolocatorService.dart';
import 'package:get/get.dart';

class ForeGroundService extends GetxController{

  ReceivePort? _receivePort;

  Future<void> initForegroundTask() async {
    await FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
        'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
        buttons: [
          // const NotificationButton(id: 'sendButton', text: 'Send'),
          // const NotificationButton(id: 'testButton', text: 'Test'),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 2000,
        autoRunOnBoot: true,
        allowWifiLock: true,
      ),
      printDevLog: true,
    );
  }

  Future<bool> startForegroundTask() async {
    // You can save data using the saveData function.
    await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');

    ReceivePort? receivePort;
    if (await FlutterForegroundTask.isRunningService) {
      receivePort = await FlutterForegroundTask.restartService();
    } else {
      receivePort = await FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
    }

    if (receivePort != null) {
      _receivePort = receivePort;
      _receivePort?.listen((message) {
        if (message is DateTime) {
          // print('receive timestamp: $message');
        } else if (message is int) {
          // print('receive updateCount: $message');
        }
      });

      return true;
    }

    return false;
  }

  Future<bool> stopForegroundTask() async {
    return await FlutterForegroundTask.stopService();
  }


}

void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}
void updateCallback() {
  FlutterForegroundTask.setTaskHandler(SecondTaskHandler());
}
class FirstTaskHandler extends TaskHandler {
  int updateCount = 0;
  late Position geoPosition = Position(longitude: 10, latitude: 20, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    // You can use the getData function to get the data you saved.
    final customData =
    await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    FlutterForegroundTask.updateService(
      notificationTitle: 'FirstTaskHandler Foreground',
      notificationText: "gg ${Get.find<GeolocationService>().geoPosition}",
      // callback: updateCount >= 2 ? updateCallback : null
    );

    // Send data to the main isolate.
    sendPort?.send(timestamp);
    print("in onStart ${Get.find<GeolocationService>().geoPosition}");
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    // Called when the notification button on the Android platform is pressed.
    print('onButtonPressed >> $id');
  }
}
class SecondTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {

  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    print("==================== SECOND HANDLEER===================================");
    FlutterForegroundTask.updateService(
        notificationTitle: 'SecondTaskHandler',
        notificationText: timestamp.toString());

    // Send data to the main isolate.
    sendPort?.send(timestamp);
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {

  }
}