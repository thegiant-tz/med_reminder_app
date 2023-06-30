import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:get/get.dart';
import 'package:medication_reminder_app/app/helpers/color_helper.dart';
import 'package:medication_reminder_app/resources/view/screens/home_screens/treatment_screen.dart';

class AlarmDisplayScreen extends StatefulWidget {
  const AlarmDisplayScreen({super.key});

  @override
  State<AlarmDisplayScreen> createState() => _AlarmDisplayScreenState();
}

class _AlarmDisplayScreenState extends State<AlarmDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future(() => true),
      child: Scaffold(
        backgroundColor: secondaryColor,
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: secondaryColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text(
                'MEDICATION REMINDER',
                style: TextStyle(
                    color: textColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              ShakeWidget(
                shakeConstant: ShakeRotateConstant1(),
                autoPlay: true,
                enableWebMouseHover: true,
                child: Image.asset('assets/images/onboarding/6.png'),
              ),
              // ignore: prefer_const_constructors
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.watch, color: textColor),
                  Text(
                    '10:30',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      FlutterRingtonePlayer.stop();
                      Get.to(
                        () => const TreatmentScreen(),
                        transition: Transition.fade,
                      );
                    },
                    child: const Text(
                      '10 minutes later',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

// class AlarmDisplayScreen extends StatefulWidget {
//   const AlarmDisplayScreen({super.key});

//   @override
//   State<AlarmDisplayScreen> createState() => _AlarmDisplayScreenState();
// }

// class _AlarmDisplayScreenState extends State<AlarmDisplayScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Ringtone player'),
//         ),
//         body: Center(
//           child: Column(
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: ElevatedButton(
//                   child: const Text('playAlarm'),
//                   onPressed: () {
//                     FlutterRingtonePlayer.playAlarm();
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: ElevatedButton(
//                   child: const Text('playAlarm asAlarm: false'),
//                   onPressed: () {
//                     FlutterRingtonePlayer.playAlarm(asAlarm: false);
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: ElevatedButton(
//                   child: const Text('playNotification'),
//                   onPressed: () {
//                     FlutterRingtonePlayer.playNotification();
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: ElevatedButton(
//                   child: const Text('playRingtone'),
//                   onPressed: () {
//                     FlutterRingtonePlayer.playRingtone();
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: ElevatedButton(
//                   child: const Text('Play from asset (iphone.mp3)'),
//                   onPressed: () {
//                     FlutterRingtonePlayer.play(fromAsset: "assets/iphone.mp3");
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: ElevatedButton(
//                   child: const Text('Play from asset (android.wav)'),
//                   onPressed: () {
//                     FlutterRingtonePlayer.play(fromAsset: "assets/android.wav");
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: ElevatedButton(
//                   child: const Text('play'),
//                   onPressed: () {
//                     FlutterRingtonePlayer.play(
//                       android: AndroidSounds.notification,
//                       ios: IosSounds.glass,
//                       looping: true,
//                       volume: 1.0,
//                     );
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: ElevatedButton(
//                   child: const Text('stop'),
//                   onPressed: () {
//                     FlutterRingtonePlayer.stop();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }