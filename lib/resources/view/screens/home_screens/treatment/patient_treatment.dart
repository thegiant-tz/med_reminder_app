import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medication_reminder_app/app/helpers/color_helper.dart';
import 'package:medication_reminder_app/app/helpers/size_helper.dart';

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
                const Icon(
                  Icons.person_2,
                  color: orange,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    user['name'],
                    style: const TextStyle(color: white),
                  ),
                ),
                Visibility(
                  visible: isEdit && !isApproved,
                  child: const Badge(
                    label: Text('Edit mode'),
                    backgroundColor: Colors.blue,
                  ),
                ),
                Visibility(
                  visible: isApproved,
                  child: const Badge(
                    label: Text('Approved', style: TextStyle(color: black),),
                    backgroundColor: orange,
                  ),
                )
              ],
            ),
            backgroundColor: primaryColor,
            actions: isApproved ? null : [
              TextButton(
                onPressed: () {
                  setState(() {
                    isEdit = true;
                  });
                },
                child: const Row(
                  children: [
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
                                onPressed: () {},
                                child: const Text('Yes I\'m sure')),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Row(
                  children: [
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
            ],
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
                      const Text('Every after (Hours)'),
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
