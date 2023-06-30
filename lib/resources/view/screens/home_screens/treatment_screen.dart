// ignore_for_file: must_be_immutable

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medication_reminder_app/app/controllers/reminder_controller.dart';
import 'package:medication_reminder_app/app/helpers/color_helper.dart';
import 'package:medication_reminder_app/app/helpers/general_helper.dart';
import 'package:medication_reminder_app/app/services/notification_service.dart';
import 'package:medication_reminder_app/resources/view/screens/home_screens/treatment/add_treatment.dart';
import 'package:medication_reminder_app/resources/view/screens/home_screens/treatment/patient_treatment.dart';

class TreatmentScreen extends StatefulWidget {
  const TreatmentScreen({super.key});

  @override
  State<TreatmentScreen> createState() => _TreatmentScreenState();
}

class _TreatmentScreenState extends State<TreatmentScreen> {
  List reminders = [];

  @override
  void initState() {
    super.initState();
    initializedFunctions();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        initializedFunctions();
      },
      child: WillPopScope(
        onWillPop: () => Future(() => false),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: white,
            appBar: const CupertinoNavigationBar(
              middle: Text(
                'MEDICATION REMINDER',
                style: TextStyle(color: white),
              ),
              trailing: Icon(
                Icons.power_settings_new,
                size: 18,
                color: orange,
              ),
              automaticallyImplyLeading: false,
              backgroundColor: primaryColor,
            ),
            floatingActionButton: isDoctor()
                ? null
                : ElevatedButton.icon(
                    onPressed: () {
                      Get.to(() => const AddTreatment(),
                          transition: Transition.cupertino,
                          duration: const Duration(microseconds: 1000));
                    },
                    icon: const Icon(Icons.alarm_add),
                    label: const Text(
                      'Add Reminder',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: white,
                    ),
                  ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: primaryColor),
                    child: Row(
                      children: [
                        Icon(
                          isDoctor() ? Icons.people_sharp : Icons.alarm,
                          size: 20,
                          color: orange,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () async {
                            initializedFunctions();
                          },
                          child: Text(
                            isDoctor() ? 'PATIENTS' : 'REMINDERS',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isPatient(),
                    child: ListView.builder(
                      itemCount: reminders.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return MyCard(reminders: reminders[index]);
                      },
                    ),
                  ),
                  Visibility(
                    visible: isDoctor(),
                    child: ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: const Text('Patient Name'),
                          subtitle:
                              const Text('Panadol | 2 Pills | Every 6 hours'),
                          trailing: const Text('09:39'),
                          leading: const Icon(Icons.person_2_rounded),
                          onTap: () {
                            Get.to(
                              () => const PatientTreatment(),
                              transition: Transition.cupertino,
                              duration: const Duration(milliseconds: 500),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      '${reminders.length} reminders',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void activateAlarm() async {
    await AndroidAlarmManager.periodic(
        const Duration(seconds: 10), 0, alarmSetting);
  }

  void alarmSetting() {
    // final DateTime now = DateTime.now();
  }

  void initializedFunctions() async {
    final reminder = await ReminderController.getReminders();
    setState(() {
      if (reminder['data'] != null) {
        reminders = reminder['data'] as List;
      }
    });
  }
}

class MyCard extends StatefulWidget {
  MyCard({
    super.key,
    required this.reminders,
  });

  Map reminders;

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  bool isON = true;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5,
      ),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color.fromARGB(255, 42, 40, 33),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      color: secondaryColor,
      surfaceTintColor: appColor,
      shadowColor: secondaryColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Reminder is ${isON ? 'ON' : 'OFF'}',
                    style: const TextStyle(color: textColor),
                  )),
                  Transform.scale(
                    scale: 0.7,
                    child: Switch(
                        activeColor: const Color.fromARGB(255, 211, 211, 211),
                        activeTrackColor:
                            const Color.fromARGB(255, 122, 163, 123),
                        value: isON,
                        onChanged: (value) {
                          if (value) {
                            showNotification(widget.reminders);
                          } else {
                            NotificationService.cancelNotification(
                                id: widget.reminders['id']);
                          }
                          setState(() {
                            isON = value;
                          });
                        }),
                  )
                ],
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Medication Name:',
                      style: TextStyle(color: textColor2),
                    ),
                  ),
                  Text(
                    widget.reminders['med_name'],
                    style: const TextStyle(color: textColor2),
                  ),
                ],
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Often:',
                      style: TextStyle(color: textColor2),
                    ),
                  ),
                  Text(
                    widget.reminders['often'] == 1
                        ? '${widget.reminders['often']} Hour'
                        : '${widget.reminders['often']} Hours',
                    style: const TextStyle(color: textColor2),
                  )
                ],
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Start at:',
                      style: TextStyle(color: textColor2),
                    ),
                  ),
                  Text(
                    widget.reminders['start_at'],
                    style: const TextStyle(color: textColor2),
                  )
                ],
              ),
              const Divider(
                color: dividerColor,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'Intake: ${widget.reminders['intake']} ${widget.reminders['unit']}',
                        style: const TextStyle(
                            color: summaryTextColor, fontSize: 10),
                      ),
                    ),
                  ),
                  // const Expanded(
                  //   child: Center(
                  //     child: Text(
                  //       'Remains: - pills',
                  //       style: TextStyle(color: summaryTextColor, fontSize: 10),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Dosage: ${widget.reminders['dosage']} ${widget.reminders['unit']}',
                        style: const TextStyle(
                          color: summaryTextColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
