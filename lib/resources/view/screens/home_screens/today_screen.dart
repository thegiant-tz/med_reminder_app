import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medication_reminder_app/app/services/notification_service.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              NotificationService.showNotification(
                  id: 1,
                  title: 'Medication Reminder',
                  body: 'Habari! Shabani, Muda umefika wa kumeza dawa',
                  summary: 'Muhimu',
                  payload: {'navigate': "true"},
                  scheduled: true,
                  interval: 60,
                  fromDate: DateTime.now(),
                  notificationLayout: NotificationLayout.Messaging,
                  actionButtons: [
                    // NotificationActionButton(key:'confirm', label: 'Confirm', actionType: ActionType.SilentAction),
                    NotificationActionButton(
                      key: 'dismiss',
                      label: 'Dismiss',
                      actionType: ActionType.DismissAction,
                    )
                  ]);
            },
            child: const Text('Notify'),
          ),

          ElevatedButton(
            onPressed: () async {
              NotificationService.cancelNotification(id: 1);
            },
            child: const Text('Cancel'),
          )
          // Text('HEADING'),
          // ListView.builder(
          //   itemCount: 110,
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemBuilder: (context, index) {
          //     if (index == 0) {
          //       return const Text('first title');
          //     } else {
          //       return const Text('hiii');
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
