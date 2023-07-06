// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
class PageViewSlide1 extends StatelessWidget {
  const PageViewSlide1({
    super.key,
    required this.txtStyle,
  });

  final TextStyle txtStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color.fromARGB(255, 234, 235, 235)),
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
                children: [
                  TextSpan(text: 'WELCOME TO MEDICATION REMINDER APP')
                ],
              ),
            ),
            Spacer(),
            ShakeWidget(
                  shakeConstant: ShakeRotateConstant1(),
                  autoPlay: true,
                  enableWebMouseHover: true,
                  child: Image.asset('assets/images/onboarding/6.png'),
                ),
            SizedBox(height: 20),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(style: txtStyle, children: [
                TextSpan(text: 'WE CAN '),
                TextSpan(
                    text: 'HELP YOU ',
                    style: TextStyle(color: Color(0xff03AE9B))),
                TextSpan(text: 'TO BECOME HELTHIER '),
                TextSpan(text: 'BY REMINDING ON '),
                TextSpan(
                    text: 'YOUR DOSE COMPLETION',
                    style: TextStyle(color: Color(0xff03AE9B))),
              ]),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
