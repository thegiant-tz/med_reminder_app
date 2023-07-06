// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medication_reminder_app/app/controllers/network_controller.dart';
import 'package:medication_reminder_app/app/helpers/color_helper.dart';
import 'package:medication_reminder_app/app/helpers/controllers_helper.dart';
import 'package:medication_reminder_app/app/helpers/general_helper.dart';
import 'package:medication_reminder_app/app/helpers/size_helper.dart';
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
  final formkey = GlobalKey<FormState>();
  final data = Get.arguments;
  List<String> users = ['-- Choose --'];
  String userName = '-- Choose --';
  String selectedUserId = '';

  preparedUserList() {
    if (data != null) {
      for (var i = 0; i < (data['users'] as List).length; i++) {
        users.add(
            data['users'][i]['id'].toString() + '%' + data['users'][i]['name']);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    preparedUserList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.to(() => const TreatmentScreen(), transition: Transition.fade);
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    GestureDetector(
                      onDoubleTap: () {},
                      child: Image.asset('assets/images/onboarding/8.png'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: white,
                            ),
                            child: const Text(
                              'Choose patient',
                              style: TextStyle(
                                color: black,
                                fontSize: defaultSize,
                              ),
                            ),
                          ),
                          DropdownButton(
                            isExpanded: true,
                            hint: Text(
                              userName,
                              style: const TextStyle(
                                color: black,
                              ),
                            ),
                            items: users
                                .map<DropdownMenuItem<String>>((String value) {
                              if (value.split('%').length > 1) {
                                userName = value.split('%')[1];
                              }
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(userName),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              String userId = value!.split('%')[0];
                              String username = value.split('%')[1];
                              setState(() {
                                userName = username;
                                selectedUserId = userId;
                              });
                            },
                          ),
                          Visibility(
                            visible: selectedUserId.isEmpty,
                            child: const Text(
                              'This field cannot be empty',
                              style: TextStyle(color: red),
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            style: const TextStyle(color: black),
                            decoration: const InputDecoration(
                              labelText:
                                  '1. What medication do you want to set the reminder for?',
                              hintText: 'Type here ..',
                              floatingLabelStyle: TextStyle(
                                color: secondaryColor,
                                fontSize: defaultSize,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                            controller: medController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This field cannot be empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                'Select medication unit',
                                style: TextStyle(color: primaryColor),
                              ),
                              const Spacer(),
                              DropdownButton(
                                hint: Text(unit,
                                    style: const TextStyle(color: black)),
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
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: white,
                      ),
                      child: const Text(
                        '2. How often do you take this medication?',
                        style: TextStyle(color: black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          const Text(
                            'Every after (Minutes)',
                            style: TextStyle(color: primaryColor),
                          ),
                          const Spacer(),
                          DropdownButton(
                            hint: Text(
                              often.toString(),
                              style: const TextStyle(color: black),
                            ),
                            items: oftenList
                                .map<DropdownMenuItem<int>>((int value) {
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: black),
                        decoration: const InputDecoration(
                          labelText: '3. Dosage amount',
                          hintText: 'Type here ..',
                          floatingLabelStyle: TextStyle(
                            color: secondaryColor,
                            fontSize: defaultSize,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                        controller: dosageController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: black),
                        decoration: const InputDecoration(
                          labelText: '4. Intake amount',
                          hintText: 'Enter intake amount',
                          floatingLabelStyle: TextStyle(
                            color: secondaryColor,
                            fontSize: defaultSize,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                        controller: intakeController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          } else if (double.parse(value) >=
                              double.parse(dosageController.text)) {
                            return "Intake amount should be less than or equal to dosage amount";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: black),
                        decoration: const InputDecoration(
                          labelText: '5. Alert when below',
                          hintText: 'Type here ..',
                          floatingLabelStyle: TextStyle(
                            color: secondaryColor,
                            fontSize: defaultSize,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                        controller: alertController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          } else if (double.parse(value) >=
                              double.parse(dosageController.text)) {
                            return "Alert amount should be less than dosage amount";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: white,
                      ),
                      child: const Text(
                        '6. Descriptions',
                        style: TextStyle(color: black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CupertinoTextField(
                        style: const TextStyle(color: black),
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        controller: descriptionController,
                        maxLines: 2,
                        placeholder: 'Type here ..',
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: white,
                      ),
                      onPressed: () {
                        if (formkey.currentState!.validate() &&
                            selectedUserId.isNotEmpty) {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: primaryColor,
                                  surfaceTintColor: primaryColor,
                                  title: const Text(
                                    'Confirmation',
                                    style: TextStyle(color: orange),
                                  ),
                                  content: const Text(
                                    'Are you sure?',
                                    style: TextStyle(color: white),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
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
                                          'alert_amount': alertController.text,
                                          'patient_id': selectedUserId,
                                          'description':
                                              descriptionController.text
                                        };
                                        final response =
                                            await NetworkController.post(
                                                Uri.parse(
                                                    '$baseUrl/add-reminder'),
                                                body: body);

                                        if (response['message'] == 'success') {
                                          // showNotification(response['data']);
                                          medController.clear();
                                          setState(() {
                                            unit = unitList.first;
                                            often = oftenList.first;
                                            userName = '-- Choose --';
                                            selectedUserId = '';
                                          });
                                          dosageController.clear();
                                          intakeController.clear();
                                          alertController.clear();
                                          descriptionController.clear();
                                          showSnackBar(context,
                                              text: 'Reminder added',
                                              backgroundColor: Colors.green);
                                          Navigator.pop(context);
                                          Get.to(() => const TreatmentScreen(),
                                              transition:
                                                  Transition.circularReveal,
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
                                          color: orange,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              });
                        }
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
      ),
    );
  }
}
