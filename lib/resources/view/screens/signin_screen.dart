import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medication_reminder_app/app/controllers/network_controller.dart';
import 'package:medication_reminder_app/app/helpers/color_helper.dart';
import 'package:medication_reminder_app/app/helpers/controllers_helper.dart';
import 'package:medication_reminder_app/app/helpers/general_helper.dart';
import 'package:medication_reminder_app/app/helpers/size_helper.dart';
import 'package:medication_reminder_app/resources/view/components/loader.dart';
import 'package:medication_reminder_app/resources/view/screens/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    // if (GetStorage().read('authToken') != null) {
    //   Get.to(
    //     () => const HomePageScreen(),
    //     transition: Transition.fadeIn,
    //   );
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    const TextStyle inputStyle = TextStyle(color: secondaryColor);
    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: primaryColor,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarColor: primaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 234, 235, 235),
          appBar: const CupertinoNavigationBar(
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
            middle: Text(
              'Login',
              style: TextStyle(color: white),
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
                                'MEDICATION REMINDER',
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
                        horizontal: 15, vertical: 15),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Text(
                        //   'REGISTRATION FORM',
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.bold,
                        //     color: secondaryColor
                        //   ),
                        // ),

                        SizedBox(height: h * 0.015),
                        const SignInFields(inputStyle: inputStyle),
                        SizedBox(height: h * 0.015),
                      ],
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
}

class SignInFields extends StatefulWidget {
  const SignInFields({
    Key? key,
    required this.inputStyle,
  }) : super(key: key);

  final TextStyle inputStyle;

  @override
  State<SignInFields> createState() => _SignInFieldsState();
}

class _SignInFieldsState extends State<SignInFields> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
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

          SizedBox(height: h * 0.025),
          Row(
            children: [
              const Text('Don\'t you have account? '),
              GestureDetector(
                child: const Text(
                  ' SIGNUP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
                onTap: () => Get.to(
                  () => const SignUpScreen(),
                  transition: Transition.cupertino,
                  duration: const Duration(milliseconds: 500),
                ),
              )
            ],
          ),
          SizedBox(height: h * 0.025),
          Loader(
            isLoading: isLoading,
            text: 'Signing in ...',
          ),
          SizedBox(height: h * 0.025),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: black,
              backgroundColor: orange,
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                // Get.toNamed('/home-page');
                setState(() {
                  isLoading = true;
                });

                final response = await NetworkController.post(
                  Uri.parse('$baseUrl/login'),
                  body: {
                    'email': emailController.text,
                    'password': passwordController.text,
                  },
                );
                setState(() {
                  isLoading = false;
                });

                if (response['message'] == 'success' ||
                    response['message'] == 'authorized') {
                  emailController.clear();
                  passwordController.clear();
                  final user = response['user'];
                  String dialogBody =
                      'Welcome ${user['name']}, click continue to navigate to home page.. Thank you';
                  // ignore: use_build_context_synchronously
                  successLoginMessageAndRedirect(context, response, dialogBody);
                } else {
                  print(response['message']);
                }
              }
            },
            icon: const Icon(
              FontAwesomeIcons.arrowRightToBracket,
              size: 18,
            ),
            label: const Text('SIGN IN'),
          )
          // const SignUpInput(inputStyle: inputStyle, label: 'Fullname:',),
          // SizedBox(height: h * 0.025),
          // const SignUpInput(inputStyle: inputStyle, label: 'Email:'),
        ],
      ),
    );
  }
}

class SignUpInput extends StatelessWidget {
  const SignUpInput({
    Key? key,
    required this.inputStyle,
    required this.label,
  }) : super(key: key);

  final TextStyle inputStyle;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: inputStyle,
        ),
        Container(
          decoration: const BoxDecoration(color: primaryColor),
          child: CupertinoTextField(
            // controller: name_controller,
            prefix: const Icon(
              CupertinoIcons.person_add_solid,
              color: secondaryColor,
            ),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white30))),
            placeholder: 'Enter your fullname:',
            placeholderStyle: const TextStyle(color: Colors.white30),
            style: inputStyle,
            onChanged: (value) {
              // setState(() {
              //   isValidated = null;
              //   isInputValidated = isFormValidated();
              //   isNameEmpty =
              //       Validation.isEmpty(controller: name_controller);
              // });
            },
          ),
        ),
      ],
    );
  }
}
