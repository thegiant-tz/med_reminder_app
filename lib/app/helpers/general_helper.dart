import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:medication_reminder_app/app/helpers/color_helper.dart';
import 'package:medication_reminder_app/app/services/notification_service.dart';
import 'package:medication_reminder_app/resources/view/screens/home_screens/treatment_screen.dart';

printHello() {
  final DateTime now = DateTime.now();
  print("[$now] Alarm triggered!");
}

final box = GetStorage();
final authToken = box.read('authToken');

String userRole() {
  return box.read('role') ?? '';
}

bool isDoctor() {
  return userRole() == 'doctor';
}

bool isPatient() {
  return userRole() == 'patient';
}

String formattedDateTime(DateTime dateTime, {format = 'yyyy-MM-dd'}) {
  return DateFormat(format).format(dateTime).toString();
}

dateTimeParse(String dateTime) {
  return DateTime.parse(dateTime);
}

Future<dynamic> successLoginMessageAndRedirect(
    BuildContext context, response, String text) {
  final box = GetStorage();
  return showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: const Text('Alert message'),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              final user = response['user'];
              box.write('user', user);
              box.write('role', response['user']['role']['slug']);
              box.write('authToken', response['token']);
              Get.to(
                () => const TreatmentScreen(),
                transition: Transition.cupertino,
                duration: const Duration(milliseconds: 500),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      );
    },
  );
}

void showSnackBar(
  BuildContext context, {
  required String text,
  int? seconds,
  String? label,
  Color? backgroundColor,
  Color? textColor,
  bool? showCloseIcon,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: showCloseIcon ?? false,
      backgroundColor: backgroundColor ?? appColor,
      content: Text(
        text,
        style: TextStyle(color: textColor ?? Colors.white),
      ),
      duration: Duration(seconds: seconds ?? 5),
      action: SnackBarAction(
        label: label ?? '',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}

void showNotification(response) {
  NotificationService.showNotification(
    id: response['id'],
    title: 'Medication Reminder',
    body:
        'Habari, Muda wa kumeza dawa umewadia, Hakikisha unaweza dawa kwa wakati',
    scheduled: true,
    fromDate: DateTime.now(),
    interval: 10,
  );
}

const List<int> oftenList = <int>[
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20,
  21,
  22,
  23,
  24
];

const baseUrl = 'http://192.168.73.43:8000/api';
const headers = {'Accept': 'application/json'};
