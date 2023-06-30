import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medication_reminder_app/app/helpers/color_helper.dart';
import 'package:medication_reminder_app/resources/view/screens/home_screens/today_screen.dart';
import 'package:medication_reminder_app/resources/view/screens/home_screens/treatment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: secondaryColor,
          statusBarIconBrightness: Brightness.light
        ),
        child: Scaffold(
          backgroundColor: appColor,
          appBar: const CupertinoNavigationBar(
            middle: Text(
              'MEDICATION REMINDER',
              style: TextStyle(color: textColor),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xff1a1a1a),
          ),
          body: SafeArea(
            child: CupertinoTabScaffold(
              backgroundColor: appColor,
              tabBar: CupertinoTabBar(
                currentIndex: data == null ? 0 : data['currentIndex'],
                height: 55,
                activeColor: textColor,
                inactiveColor: Colors.white70,
                backgroundColor: secondaryColor,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.today,
                      size: 25,
                    ),
                    label: 'Today',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.alarm,
                      size: 25,
                    ),
                    label: 'Reminders',
                  ),
                ],
              ),
              tabBuilder: (context, index) {
                return CupertinoTabView(
                  builder: (context) {
                    if (index == 0) {
                      return const TodayScreen();
                    } else {
                      return const TreatmentScreen();
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
