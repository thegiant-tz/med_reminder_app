import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:medication_reminder_app/resources/view/screens/home_screens/alarm_screen.dart';
import 'package:medication_reminder_app/resources/view/screens/home_screens/treatment/add_treatment.dart';
import 'package:medication_reminder_app/resources/view/screens/home_screens/treatment_screen.dart';

class NotificationService {
  static Future<void> initializedNotification() async {
    List<NotificationChannel> channels = <NotificationChannel>[
      NotificationChannel(
        channelGroupKey: 'high_importance_channel',
        channelKey: 'high_importance_channel',
        channelName: "Basic notification",
        channelDescription: "Notification for basic tests",
        defaultColor: Colors.black,
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        onlyAlertOnce: true,
        playSound: true,
        criticalAlerts: true,
      )
    ];
    List<NotificationChannelGroup> channelGroups = <NotificationChannelGroup>[
      NotificationChannelGroup(
        channelGroupKey: 'high_importance_channel',
        channelGroupName: 'Group',
      )
    ];
    await AwesomeNotifications().initialize(
      null,
      channels,
      channelGroups: channelGroups,
      debug: true,
    );
    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: (receivedAction) async {
        debugPrint('onActionReceivedMethod');
        FlutterRingtonePlayer.stop();
        final payload = receivedAction.payload ?? {};
        if (payload['navigate'] == "true") {
          Get.to(
            () => const AddTreatment(),
            transition: Transition.fadeIn,
          );
        }
      },
      onNotificationCreatedMethod: (receivedNotification) async {
        debugPrint('onNotificationCreatedMethod');
      },
      onNotificationDisplayedMethod: (receivedNotification) async {
        debugPrint('onNotificationDisplayedMethod');
        FlutterRingtonePlayer.playAlarm();
        final payload = receivedNotification.payload;
        Get.to(() => const AlarmDisplayScreen(),
            transition: Transition.fadeIn, arguments: {'payload': payload});
      },
      onDismissActionReceivedMethod: (receivedAction) async {
        FlutterRingtonePlayer.stop();
        debugPrint('onDismissActionReceivedMethod');
        Get.to(() => const TreatmentScreen(), transition: Transition.fade);
      },
    );
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final DateTime? fromDate,
    final int? interval,
    required final int id,
  }) async {
    assert(!scheduled || (scheduled && interval != null));
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationCalendar.fromDate(
              date: fromDate!.add(Duration(seconds: interval!)),
              preciseAlarm: true,
            )
          : null,
    );
  }

  static Future<void> cancelNotification({required int id}) async {
    AwesomeNotifications().cancelSchedule(id);
  }
}
