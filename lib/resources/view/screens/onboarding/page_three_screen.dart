// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medication_reminder_app/app/helpers/general_helper.dart';
import 'package:medication_reminder_app/resources/view/screens/home_screens/treatment_screen.dart';

class PageViewSlide3 extends StatefulWidget {
  const PageViewSlide3({
    super.key,
  });

  @override
  State<PageViewSlide3> createState() => _PageViewSlide3State();
}

class _PageViewSlide3State extends State<PageViewSlide3> {
  final box = GetStorage();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white54),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your name',
              style: TextStyle(fontSize: 18, color: Colors.deepPurple),
            ),
            SizedBox(height: 8),
            CupertinoTextField(
              maxLines: 1,
              controller: nameController,
              placeholder: 'Type here...',
            ),
            SizedBox(height: 15),
            ElevatedButton.icon(
                onPressed: () {
                  validateAndRedirect();
                },
                icon: Icon(CupertinoIcons.arrow_right_circle_fill),
                label: Text('Continue'))
          ],
        ),
      ),
    );
  }

  void validateAndRedirect() {
    String name = nameController.text;
    if (name.isEmpty) {
      showSnackBar(context, text: 'Name cannot be empty');
    } else if (name.length < 3) {
      showSnackBar(context, text: 'Name contains atleast three(3) characters');
    } else {
      box.write('username', name);
      Get.to(
        () => TreatmentScreen(),
        transition: Transition.cupertino,
        duration: Duration(milliseconds: 300),
      );
    }
  }
}
