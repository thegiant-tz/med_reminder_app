// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class PageViewSlide2 extends StatelessWidget {
  const PageViewSlide2({
    super.key,
    required this.txtStyle,
  });

  final TextStyle txtStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xffffffff)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: txtStyle,
                children: [TextSpan(text: 'GET NOTIFIED INSTANTLY')],
              ),
            ),
            Spacer(),
            Image.asset('assets/images/onboarding/3.png'),
            SizedBox(height: 30),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(style: txtStyle, children: [
                TextSpan(text: 'MEDICATION REMINDER '),
                TextSpan(
                    text: 'APP AIMED TO ',
                    style: TextStyle(color: Color(0xff3F84CD))),
                TextSpan(text: 'HELP YOU, '),
                TextSpan(
                    text: 'STAY HERE ',
                    style: TextStyle(color: Color(0xff3F84CD))),
                TextSpan(text: 'FOR THE BETTER HEALTH'),
              ]),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
