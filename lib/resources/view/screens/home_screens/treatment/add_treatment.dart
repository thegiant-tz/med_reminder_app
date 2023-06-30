// ignore_for_file: use_build_context_synchronously

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medication_reminder_app/app/controllers/network_controller.dart';
import 'package:medication_reminder_app/app/helpers/color_helper.dart';
import 'package:medication_reminder_app/app/helpers/controllers_helper.dart';
import 'package:medication_reminder_app/app/helpers/general_helper.dart';
import 'package:medication_reminder_app/resources/view/screens/home_screens/treatment_screen.dart';

class AddTreatment extends StatefulWidget {
  const AddTreatment({super.key});

  @override
  State<AddTreatment> createState() => _AddTreatmentState();
}

const List<String> unitList = <String>[
  'Pill(s)',
  'Gram(s)',
  'Injection(s)',
  'Drop(s)'
];

class _AddTreatmentState extends State<AddTreatment> {
  String unit = unitList.first;
  int often = oftenList.first;
  String? reminderStartAt = DateTime.now().toString();
  TextEditingController medController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.to(() => const TreatmentScreen(), transition: Transition.fade);
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: secondaryColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  GestureDetector(
                    onDoubleTap: () {},
                    child: Image.asset('assets/images/onboarding/8.png'),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Color(0xff1a1a1a),
                    ),
                    child: const Text(
                      '1. What medication do you want to set the reminder for?',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        CupertinoTextField(
                          style: const TextStyle(color: Colors.white60),
                          placeholderStyle: const TextStyle(color: textColor2),
                          decoration:
                              const BoxDecoration(color: Colors.transparent),
                          controller: medController,
                          placeholder: 'Enter medication name',
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              'Select medication unit',
                              style: TextStyle(color: Colors.white60),
                            ),
                            const Spacer(),
                            DropdownButton(
                              hint: Text(unit,
                                  style:
                                      const TextStyle(color: Colors.white54)),
                              items: unitList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  unit = value!;
                                });
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Color(0xff1a1a1a),
                    ),
                    child: const Text(
                      '2. How often do you take this medication?',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        const Text(
                          'Every after',
                          style: TextStyle(color: Colors.white60),
                        ),
                        const Spacer(),
                        DropdownButton(
                          hint: Text(
                            often.toString(),
                            style: const TextStyle(color: Colors.white54),
                          ),
                          items:
                              oftenList.map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (int? value) {
                            setState(() {
                              often = value!;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Color(0xff1a1a1a),
                    ),
                    child: const Text(
                      '3. Dosage amount',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CupertinoTextField(
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white60),
                      placeholderStyle: const TextStyle(color: textColor2),
                      decoration:
                          const BoxDecoration(color: Colors.transparent),
                      controller: dosageController,
                      placeholder: 'Enter dosage amount',
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Color(0xff1a1a1a),
                    ),
                    child: const Text(
                      '4. Intake amount',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CupertinoTextField(
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white60),
                      placeholderStyle: const TextStyle(color: textColor2),
                      decoration:
                          const BoxDecoration(color: Colors.transparent),
                      controller: intakeController,
                      placeholder: 'Enter intake amount',
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Color(0xff1a1a1a),
                    ),
                    child: const Text(
                      '5. What time do you want to be reminded?',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        DateTimePicker(
                          // decoration: const InputDecoration(
                          //   fillColor: Colors.white54,
                          //   focusColor: Colors.white54,
                          //   hintStyle: TextStyle(color: Colors.white54),
                          //   labelStyle: TextStyle(color: Colors.white54)
                          // ),
                          style: const TextStyle(color: Colors.white54),
                          keyboardAppearance: Brightness.dark,
                          type: DateTimePickerType.dateTimeSeparate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100, 12, 31),
                          initialValue: DateTime.now().toString(),
                          timeLabelText: 'Time',
                          dateLabelText: 'Date',
                          onChanged: (dateTime) {
                            setState(() {
                              reminderStartAt = dateTime;
                            });
                          },
                          // validator: (val) {},
                          // onSaved: (val) => print(val),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: textColor,
                      foregroundColor: secondaryColor,
                    ),
                    onPressed: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: secondaryColor,
                              surfaceTintColor: secondaryColor,
                              title: const Text(
                                'Confirmation',
                                style: TextStyle(color: textColor),
                              ),
                              content: const Text(
                                'Are you sure?',
                                style: TextStyle(color: Colors.white54),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Color.fromARGB(184, 237, 110, 101),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final body = {
                                      'med_name': medController.text,
                                      'unit': unit,
                                      'often': often.toString(),
                                      'dosage': dosageController.text,
                                      'intake': intakeController.text,
                                      'start_at': reminderStartAt
                                    };
                                    final response =
                                        await NetworkController.post(
                                      Uri.parse('$baseUrl/add-reminder'),
                                      body: body
                                    );

                                    if (response['message'] == 'success') {
                                      showNotification(response['data']);
                                      showSnackBar(context,
                                          text: 'Reminder added',
                                          backgroundColor: Colors.green);
                                      Navigator.pop(context);
                                      Get.to(() => const TreatmentScreen(),
                                          transition: Transition.circularReveal,
                                          arguments: {
                                            'reminderTab': true,
                                            'currentIndex': 1
                                          });
                                    } else {
                                      showSnackBar(context,
                                          text:
                                              'Something went wrong, try again',
                                          backgroundColor: Colors.red);
                                    }
                                  },
                                  child: const Text(
                                    'Yes, I\'m sure',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 135, 193, 240),
                                    ),
                                  ),
                                )
                              ],
                            );
                          });
                    },
                    child: const Text('ADD REMINDER'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
