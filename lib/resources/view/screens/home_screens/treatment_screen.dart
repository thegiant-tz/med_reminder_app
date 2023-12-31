// ignore_for_file: must_be_immutable, use_build_context_synchronously, prefer_const_constructors

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medication_reminder_app/app/controllers/network_controller.dart';
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
  List users = [];

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
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              systemNavigationBarColor: primaryColor,
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarColor: primaryColor,
              statusBarIconBrightness: Brightness.light,
            ),
            child: Scaffold(
              backgroundColor: white,
              appBar: CupertinoNavigationBar(
                middle: const Text(
                  'MEDICATION REMINDER',
                  style: TextStyle(color: white),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    alertDialog(
                      context,
                      title: const Text('Logout'),
                      content: const Text('Are you sure?'),
                      onConfirm: () {
                        logout();
                      },
                    );
                  },
                  child: const Icon(
                    Icons.power_settings_new,
                    size: 18,
                    color: orange,
                  ),
                ),
                automaticallyImplyLeading: false,
                backgroundColor: primaryColor,
              ),
              floatingActionButton: isPatient()
                  ? null
                  : ElevatedButton.icon(
                      onPressed: () {
                        Get.to(() => const AddTreatment(),
                            transition: Transition.cupertino,
                            duration: const Duration(microseconds: 1000),
                            arguments: {'users': users});
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
                          return PopupMenuButton(
                            color: primaryColor,
                            onSelected: (value) {
                              if (value == 'refill') {
                                TextEditingController refillController =
                                    TextEditingController(
                                        text: reminders[index]['dosage']
                                            .toString());
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('REFILL'),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('Amount'),
                                          const SizedBox(height: 8),
                                          CupertinoTextField(
                                            controller: refillController,
                                            keyboardType: TextInputType.number,
                                            placeholder: 'Type here ...',
                                          )
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (refillController
                                                .text.isNotEmpty) {
                                              Uri uri =
                                                  Uri.parse('$baseUrl/refill');
                                              final body = {
                                                'amount': refillController.text,
                                                'id': reminders[index]['id']
                                                    .toString()
                                              };
                                              final response =
                                                  await NetworkController.post(
                                                uri,
                                                body: body,
                                              );

                                              if (response != null) {
                                                if (response['message'] ==
                                                    'success') {
                                                  Navigator.pop(context);
                                                  initializedFunctions();
                                                  showSnackBar(context,
                                                      text: 'Reminder refilled',
                                                      backgroundColor:
                                                          Colors.green);
                                                } else {
                                                  Navigator.pop(context);
                                                  showSnackBar(context,
                                                      text: 'Refill failed',
                                                      backgroundColor:
                                                          Colors.red);
                                                }
                                              } else {
                                                Navigator.pop(context);
                                                showSnackBar(context,
                                                    text: 'Refill failed',
                                                    backgroundColor:
                                                        Colors.red);
                                              }
                                            }
                                          },
                                          child: const Text(
                                            'Refill',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else if (value == 'info') {
                                Get.to(() => const PatientTreatment(),
                                    transition: Transition.circularReveal,
                                    duration: const Duration(milliseconds: 500),
                                    arguments: {
                                      'reminder': reminders[index],
                                      'user': GetStorage().read('user')
                                    });
                              } else if (value == 'delete') {
                                alertDialog(
                                  context,
                                  title: Text('Delete reminder'),
                                  confirmButtonText: 'Yes, Delete',
                                  content: Text(
                                    'Do you want to delete this reminder?',
                                  ),
                                  onConfirm: () async {
                                    Uri uri = Uri.parse('$baseUrl/delete');
                                    final body = {
                                      'id': reminders[index]['id'].toString(),
                                    };
                                    final response =
                                        await NetworkController.post(
                                      uri,
                                      body: body,
                                    );
                                    if (response != null) {
                                      if (response['message'] == 'success') {
                                        initializedFunctions();
                                        showSnackBar(
                                          context,
                                          text: 'Reminder deleted',
                                          backgroundColor: green,
                                        );
                                      } else {
                                        showSnackBar(
                                          context,
                                          text: 'Reminder not deleted',
                                          backgroundColor: red,
                                        );
                                      }
                                    } else {
                                      showSnackBar(
                                        context,
                                        text: 'Reminder not deleted',
                                        backgroundColor: red,
                                      );
                                    }
                                    Navigator.pop(context);
                                  },
                                );
                              }
                            },
                            position: PopupMenuPosition.under,
                            itemBuilder: (context) {
                              return <PopupMenuEntry>[
                                PopupMenuItem(
                                  value: 'info',
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.info_outline,
                                        size: 14,
                                        color: orange,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Info',
                                        style: TextStyle(color: white),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'refill',
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.add_circle_outline_outlined,
                                        size: 14,
                                        color: orange,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Refill',
                                        style: TextStyle(color: white),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.delete_forever,
                                        size: 14,
                                        color: orange,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Delete',
                                        style: TextStyle(color: white),
                                      ),
                                    ],
                                  ),
                                ),
                              ];
                            },
                            child: MyCard(reminders: reminders[index]),
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: isDoctor(),
                      child: ListView.builder(
                        itemCount: reminders.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final user = reminders[index]['user'];
                          final reminder = reminders[index];
                          reminder['index'] = index;
                          bool isApproved = reminder['status'] == 'Approved';
                          return ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                    child:
                                        Text(user == null ? '' : user['name'])),
                                Badge(
                                  backgroundColor:
                                      isApproved ? orange : Colors.red,
                                  label: Text(
                                    reminder['status'],
                                    style: TextStyle(
                                      color: isApproved ? black : white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            subtitle: Text(
                                '${reminder['med_name']} | ${reminder['intake']} ${reminder['unit']} | Every ${reminder['often']} minutes'),
                            trailing: Text(formattedDateTime(
                                DateTime.parse(reminder['created_at']),
                                format: 'HH:mm')),
                            leading: Icon(
                              Icons.person_2_rounded,
                              color: isApproved ? orange : primaryColor,
                            ),
                            onTap: () {
                              Get.to(() => const PatientTreatment(),
                                  transition: Transition.cupertino,
                                  duration: const Duration(milliseconds: 500),
                                  arguments: {
                                    'user': user,
                                    'reminder': reminder
                                  });
                            },
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: reminders.isEmpty,
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text('No reminder found'),
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
    if (isPatient()) {
      final reminder = await ReminderController.getReminders();
      setState(() {
        if (reminder['data'] != null) {
          reminders = reminder['data'] as List;
        } else {
          reminders = [];
        }
      });
    } else {
      final reminder = await ReminderController.getPendingReminders();
      setState(() {
        if (reminder['data'] != null) {
          reminders = reminder['data'] as List;
        } else {
          reminders = [];
        }
      });

      final userResponse = await ReminderController.getPatients();

      setState(() {
        if (userResponse['data'] != null) {
          users = userResponse['data'] as List;
        } else {
          users = [];
        }
      });
    }
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
  bool isON = false;
  final data = Get.arguments;
  Map alertedReminder = {'id': 0};
  @override
  Widget build(BuildContext context) {
    bool isApproved = widget.reminders['status'] == 'Approved';
    // setState(() {
    //   isON = widget.reminders['switch_state'].toString() == "1";
    // });
    if (data != null) {
      alertedReminder = data['reminder'] ?? {};
    }

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5,
      ),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: primaryColor,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      color: white,
      surfaceTintColor: white,
      shadowColor: primaryColor,
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
                    'Reminder is ${isON && isApproved ? 'ON' : 'OFF'}',
                    style: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  )),
                  Transform.scale(
                    scale: 0.7,
                    child: Switch(
                        activeColor: white,
                        activeTrackColor: Colors.green,
                        value: (isON && isApproved) ||
                            (alertedReminder['id'] == widget.reminders['id']),
                        onChanged: (value) {
                          if (isApproved) {
                            if (value) {
                              showNotification(widget.reminders);
                            } else {
                              NotificationService.cancelNotification(
                                  id: widget.reminders['id']);
                            }

                            setState(() {
                              isON = value;
                            });
                          }
                        }),
                  )
                ],
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Medication Name:',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                  Text(
                    widget.reminders['med_name'],
                    style: const TextStyle(color: black),
                  ),
                ],
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Often:',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                  Text(
                    widget.reminders['often'] == 1
                        ? '${widget.reminders['often']} Minute'
                        : '${widget.reminders['often']} Minutes',
                    style: const TextStyle(color: black),
                  )
                ],
              ),
              const Divider(
                color: primaryColor,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: primaryColor),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'Intake: ${widget.reminders['intake']} ${widget.reminders['unit']}',
                          style: const TextStyle(color: white, fontSize: 10),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Dosage: ${widget.reminders['dosage']} ${widget.reminders['unit']}',
                          style: const TextStyle(
                            color: white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                          child: Badge(
                        backgroundColor: isApproved ? orange : Colors.red,
                        label: isApproved
                            ? Text(
                                'Approved',
                                style: TextStyle(color: primaryColor),
                              )
                            : Text('Pending'),
                      )),
                    ),
                    Visibility(
                      visible: isAlertEnabled(widget.reminders)['status'],
                      child: SizedBox(
                        width: 30,
                        height: 20,
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            FadeAnimatedText("⚠️",
                                textStyle: TextStyle(
                                  color: orange,
                                  fontSize: 18,
                                ),
                                duration: const Duration(milliseconds: 1000))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
