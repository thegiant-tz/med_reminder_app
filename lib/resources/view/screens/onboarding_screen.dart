import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medication_reminder_app/app/services/create_user_id_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'onboarding/page_three_screen.dart';
import 'onboarding/page_one_screen.dart';
import 'onboarding/page_two_screen.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _controller = PageController();
  final txtStyle = const TextStyle(
    color: Colors.black,
    fontFamily: 'Klasik',
    fontWeight: FontWeight.bold,
    fontSize: 19,
  );
  bool isLastPage = false;
  final box = GetStorage();
  @override
  void initState() {
    box.write('user_id', AppUser.createId());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 2;
            });
          },
          children: [
            PageViewSlide1(txtStyle: txtStyle),
            PageViewSlide2(txtStyle: txtStyle),
            const PageViewSlide3(),
          ],
        ),
        Visibility(
          visible: !isLastPage,
          child: Container(
            alignment: const Alignment(0, 0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child: const Text('Skip'),
                ),
                SmoothPageIndicator(
                  count: 3,
                  controller: _controller,
                  effect: const WormEffect(activeDotColor: Colors.black),
                ),
                GestureDetector(
                  onTap: () {
                    _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                  child: const Text('Next'),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
