// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medication_reminder_app/app/controllers/network_controller.dart';
import 'package:medication_reminder_app/app/helpers/color_helper.dart';
import 'package:medication_reminder_app/app/helpers/general_helper.dart';
import 'package:medication_reminder_app/app/helpers/size_helper.dart';
import 'package:medication_reminder_app/resources/view/screens/home_screens/treatment_screen.dart';

class PatientTreatment extends StatefulWidget {
  const PatientTreatment({super.key});

  @override
  State<PatientTreatment> createState() => _PatientTreatmentState();
}

class _PatientTreatmentState extends State<PatientTreatment> {
  bool isEdit = false;
  final data = Get.arguments;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final user = data['user'];
    final reminder = data['reminder'];
    bool isApproved = reminder['status'] == 'Approved';
    TextEditingController dmedNameController =
    TextEditingController(text: reminder['med_name'].toString());
    TextEditingController oftenController =
    TextEditingController(text: reminder['often'].toString());
    TextEditingController dosageController =
    TextEditingController(text: reminder['dosage'].toString());
    TextEditingController intakeController =
    TextEditingController(text: reminder['intake'].toString());
    TextEditingController timeController =
    TextEditingController(text: reminder['start_at'].toString());
    TextEditingController unitController =
    TextEditingController(text: reminder['unit']);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            foregroundColor: orange,
            title: Row(
              children: [
                Icon(
                  isDoctor() ? Icons.person_2 : Icons.info_outline,
                  color: orange,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isDoctor() ? user['name'] : 'Information',
                    style: const TextStyle(color: white),
                  ),
                ),
                Visibility(
                  visible: isEdit,
                  child: const Badge(
                    label: Text('Edit mode'),
                    backgroundColor: Colors.blue,
                  ),
                ),
                Visibility(
                  visible: isApproved && !isEdit,
                  child: const Badge(
                    label: Text(
                      'Approved',
                      style: TextStyle(color: black),
                    ),
                    backgroundColor: orange,
                  ),
                )
              ],
            ),
            backgroundColor: primaryColor,
            actions: isApproved && !isPatient()
                ? null
                : (isDoctor()
                ? [
              TextButton(
                onPressed: () {
                  setState(() {
                    isEdit = true;
                  });
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.edit,
                      color: white,
                      size: 14,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Edit',
                      style: TextStyle(color: white),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirmation'),
                          content: const Text('Are you sure?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.red),
                                )),
                            TextButton(
                                onPressed: () async {
                                  final response =
                                  await NetworkController.post(
                                    Uri.parse(
                                      '$baseUrl/reminder-confirmation',
                                    ),
                                    body: {
                                      'med_name': dmedNameController.text,
                                      'unit': unitController.text,
                                      'intake': intakeController.text,
                                      'dosage': dosageController.text,
                                      'often': oftenController.text,
                                      'start_at': timeController.text,
                                      'id': reminder['id'].toString()
                                    },
                                  );
                                  if (response != null) {
                                    if (response['message'] ==
                                        'success') {
                                      Get.to(
                                            () => const TreatmentScreen(),
                                        transition: Transition.fadeIn,
                                      );
                                      showSnackBar(
                                        context,
                                        text: 'Reminder approved',
                                        backgroundColor: Colors.green,
                                      );
                                    } else {
                                      showSnackBar(
                                        context,
                                        text: 'Approval failed',
                                        backgroundColor: Colors.red,
                                      );
                                    }
                                  } else {
                                    showSnackBar(
                                      context,
                                      text: 'Approval failed',
                                      backgroundColor: Colors.red,
                                    );
                                  }
                                },
                                child: const Text('Yes I\'m sure')),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.check_circle_outline_outlined,
                      color: white,
                      size: 14,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Confirm',
                      style: TextStyle(color: white),
                    ),
                  ],
                ),
              ),
            ]
                : (isPatient() && isApproved)
                ? [
              TextButton(
                onPressed: () {
                  setState(() {
                    isEdit = true;
                  });
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.edit,
                      color: white,
                      size: 14,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Edit',
                      style: TextStyle(color: white),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  TextEditingController refillController =
                  TextEditingController();
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
                                  'med_name': dmedNameController.text,
                                  'unit': unitController.text,
                                  'intake': intakeController.text,
                                  'often': oftenController.text,
                                  'start_at': timeController.text,
                                  'id': reminder['id'].toString()
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
                                    Get.to(
                                          () =>
                                      const TreatmentScreen(),
                                      transition: Transition
                                          .circularReveal,
                                      duration: const Duration(
                                          milliseconds: 500),
                                    );
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
                },
                child:  Row(
                  children: const [
                    Icon(
                      Icons.add_circle_outline,
                      color: white,
                      size: 14,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Refill',
                      style: TextStyle(color: white),
                    ),
                  ],
                ),
              ),
            ]
                : null),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Medication name'),
                      TextFormField(
                        readOnly: !isEdit,
                        controller: dmedNameController,
                        decoration: const InputDecoration(
                            floatingLabelStyle: TextStyle(
                              color: secondaryColor,
                              fontSize: defaultSize,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text('Unit'),
                      TextFormField(
                        readOnly: !isEdit,
                        controller: unitController,
                        decoration: const InputDecoration(
                            floatingLabelStyle: TextStyle(
                              color: secondaryColor,
                              fontSize: defaultSize,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text('Intake'),
                      TextFormField(
                        readOnly: !isEdit,
                        controller: intakeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            floatingLabelStyle: TextStyle(
                              color: secondaryColor,
                              fontSize: defaultSize,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text('Dosage amount'),
                      TextFormField(
                        readOnly: !isEdit,
                        controller: dosageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            floatingLabelStyle: TextStyle(
                              color: secondaryColor,
                              fontSize: defaultSize,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text('Every after (Minutes)'),
                      TextFormField(
                        readOnly: !isEdit,
                        controller: oftenController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            floatingLabelStyle: TextStyle(
                              color: secondaryColor,
                              fontSize: defaultSize,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text('Remind start at'),
                      TextFormField(
                        readOnly: !isEdit,
                        controller: timeController,
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                            floatingLabelStyle: TextStyle(
                              color: secondaryColor,
                              fontSize: defaultSize,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
                      const Text('Descriptions:'),
                      Text(reminder['description'] ?? 'No description provided.'),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
