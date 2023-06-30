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
  TextEditingController dmedNameController =
      TextEditingController(text: 'Panadol');
  bool isEdit = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            foregroundColor: orange,
            title: const Row(
              children: [
                Icon(
                  Icons.person_2,
                  color: orange,
                ),
                SizedBox(width: 8),
                Text(
                  'Patient Name',
                  style: TextStyle(color: white),
                ),
              ],
            ),
            backgroundColor: primaryColor,
            actions: [
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
                onPressed: () {},
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
                          } else if (!value.isEmail) {
                            return 'Invalid email provided';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
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
                          } else if (!value.isEmail) {
                            return 'Invalid email provided';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
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
                          } else if (!value.isEmail) {
                            return 'Invalid email provided';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
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
                          } else if (!value.isEmail) {
                            return 'Invalid email provided';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
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
                          } else if (!value.isEmail) {
                            return 'Invalid email provided';
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
