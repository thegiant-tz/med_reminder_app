// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medication_reminder_app/app/controllers/network_controller.dart';
import 'package:medication_reminder_app/app/helpers/color_helper.dart';
import 'package:medication_reminder_app/app/helpers/controllers_helper.dart';
import 'package:medication_reminder_app/app/helpers/general_helper.dart';
import 'package:medication_reminder_app/app/helpers/size_helper.dart';
import 'package:medication_reminder_app/resources/view/components/loader.dart';
import 'package:medication_reminder_app/resources/view/screens/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isDoctorSelected = false;
  bool isPatientSelected = false;
  static String role = 'null';
  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    // final double w = MediaQuery.of(context).size.width;
    const TextStyle inputStyle = TextStyle(color: secondaryColor);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 235, 235),
      appBar: const CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        brightness: Brightness.light,
        middle: Text(
          'MEDICATION REMINDER',
          style: TextStyle(color: white),
        ),
        trailing: Icon(
          CupertinoIcons.person_add_solid,
          color: white,
          size: 25,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: h * 0.015),
              Container(
                decoration: const BoxDecoration(color: primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: white,
                      ),
                      child: AnimatedTextKit(
                        totalRepeatCount: 1,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'REGISTRATION FORM',
                            cursor: '',
                          ),
                        ],
                        onTap: () {},
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Register As:',
                      style: TextStyle(fontSize: defaultSize),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChoiceChip(
                          label: Text(
                            'Doctor',
                            style: TextStyle(
                              color: isDoctorSelected ? white : black,
                            ),
                          ),
                          selected: isDoctorSelected,
                          tooltip: 'Register as doctor',
                          // avatar: const Icon(Icons.person),
                          onSelected: (value) {
                            setState(() {
                              isDoctorSelected = value;
                              role = 'Doctor';
                              if (isPatientSelected) {
                                isPatientSelected = !isDoctorSelected;
                              }

                              if (!isPatientSelected && !isDoctorSelected) {
                                role = 'null';
                              }
                            });
                          },
                          selectedColor: primaryColor,
                        ),
                        const SizedBox(width: 15),
                        ChoiceChip(
                          label: Text(
                            'Patient',
                            style: TextStyle(
                              color: isPatientSelected ? white : black,
                            ),
                          ),
                          // avatar: const Icon(Icons.directions_car),
                          selected: isPatientSelected,
                          tooltip: 'Register as patient',
                          onSelected: (value) {
                            setState(() {
                              isPatientSelected = value;
                              role = 'Patient';
                              if (isDoctorSelected) {
                                isDoctorSelected = !isPatientSelected;
                              }

                              if (!isPatientSelected && !isDoctorSelected) {
                                role = 'null';
                              }
                            });
                          },
                          selectedColor: primaryColor,
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.015),
                    SignUpFields(
                      inputStyle: inputStyle,
                      role: role,
                    ),
                    SizedBox(height: h * 0.015),
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

class SignUpFields extends StatefulWidget {
  const SignUpFields({
    Key? key,
    required this.inputStyle,
    required this.role,
  }) : super(key: key);

  final TextStyle inputStyle;
  final String role;

  @override
  State<SignUpFields> createState() => _SignUpFieldsState();
}

class _SignUpFieldsState extends State<SignUpFields> {
  bool isLoading = false, isReadOnly = false, isCompanyChecked = false;
  GlobalKey<FormState> csrf1 = GlobalKey<FormState>();
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;

    // final double w = MediaQuery.of(context).size.width;

    return Form(
      key: csrf1,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Visibility(
              visible: widget.role == 'Recruiter',
              child: Row(
                children: [
                  const Text(
                    'Is account type company?',
                    style: TextStyle(fontSize: 16),
                  ),
                  Checkbox(
                    value: isCompanyChecked,
                    onChanged: (value) {
                      setState(() {
                        isCompanyChecked = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            readOnly: isReadOnly,
            controller: nameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.person_2,
                color: primaryColor,
              ),
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
              labelText: 'Fullname:',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field cannot be empty';
              } else if (value.isNumericOnly) {
                return 'Name should consist letters';
              } else if (value.length < 3) {
                return 'Name should consist atleast 3 characters';
              }
              return null;
            },
          ),

          TextFormField(
            readOnly: isReadOnly,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: primaryColor,
              ),
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
              labelText: 'Email:',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field cannot be empty';
              } else if (!value.isEmail) {
                return 'Invalid email provided';
              }
              return null;
            },
          ),

          TextFormField(
            readOnly: isReadOnly,
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.phone_android_rounded,
                color: primaryColor,
              ),
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
              labelText: 'Phone:',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field cannot be empty';
              } else if (!value.isPhoneNumber) {
                return 'Invalid phone number provided';
              }
              return null;
            },
          ),

          TextFormField(
            readOnly: isReadOnly,
            controller: passwordController,
            obscureText: true,
            obscuringCharacter: '*',
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                color: primaryColor,
              ),
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
              labelText: 'Password:',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field cannot be empty';
              } else if (value.length < 5) {
                return 'Atleast 5 characters are required';
              }
              return null;
            },
          ),

          TextFormField(
            readOnly: isReadOnly,
            controller: confirmPasswordController,
            obscureText: true,
            obscuringCharacter: '*',
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.lock_outline,
                color: primaryColor,
              ),
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
              labelText: 'Confirm password:',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field cannot be empty';
              } else if (passwordController.text != value) {
                return 'Password do not match';
              }
              return null;
            },
          ),
          SizedBox(height: h * 0.015),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                const Text('Already have account? '),
                GestureDetector(
                  child: const Text(
                    ' LOGIN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: secondaryColor,
                    ),
                  ),
                  onTap: () => Get.to(() => const SignInScreen(),
                      transition: Transition.cupertino,
                      duration: const Duration(milliseconds: 500)),
                )
              ],
            ),
          ),
          SizedBox(height: h * 0.025),
          Loader(isLoading: isLoading),
          SizedBox(height: h * 0.025),

          SizedBox(height: h * 0.025),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: black,
              backgroundColor: orange,
            ),
            onPressed: isLoading
                ? null
                : () async {
                    if (csrf1.currentState!.validate() &&
                        widget.role != 'null') {
                      Map<String, String> body;
                      body = {
                        'name': nameController.text,
                        'email': emailController.text,
                        'phone': phoneController.text,
                        'password': passwordController.text,
                        'role_name': widget.role
                      };

                      setState(() {
                        isLoading = true;
                        isReadOnly = true;
                      });
                      final response = await NetworkController.post(
                        Uri.parse('$baseUrl/register'),
                        body: body,
                      );

                      setState(() {
                        isLoading = false;
                      });
                      if (response['message'] == 'success') {
                        nameController.clear();
                        phoneController.clear();
                        emailController.clear();
                        passwordController.clear();
                        confirmPasswordController.clear();
                        String dialogBody =
                            'Dear customer your registration has completed successfull, click continue to navigate your home page.. Thank you';
                        successLoginMessageAndRedirect(
                          context,
                          response,
                          dialogBody,
                        );
                      } else {
                        setState(() {
                          isReadOnly = false;
                        });
                      }
                    } else if (widget.role == 'null') {
                      showSnackBar(
                        context,
                        text: 'Register As field is required',
                        backgroundColor: secondaryColor,
                      );
                    }
                  },
            icon: const Icon(Icons.arrow_circle_right_outlined),
            label: const Text('CREATE ACCOUNT'),
          )
          // const SignUpInput(inputStyle: inputStyle, label: 'Fullname:',),
          // SizedBox(height: h * 0.025),
          // const SignUpInput(inputStyle: inputStyle, label: 'Email:'),
        ],
      ),
    );
  }
}
