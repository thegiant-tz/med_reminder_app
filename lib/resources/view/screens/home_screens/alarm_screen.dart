import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:get/get.dart';
import 'package:medication_reminder_app/app/controllers/network_controller.dart';
import 'package:medication_reminder_app/app/helpers/color_helper.dart';
import 'package:medication_reminder_app/app/helpers/general_helper.dart';
import 'package:medication_reminder_app/resources/view/screens/home_screens/treatment_screen.dart';

class AlarmDisplayScreen extends StatefulWidget {
  const AlarmDisplayScreen({super.key});

  @override
  State<AlarmDisplayScreen> createState() => _AlarmDisplayScreenState();
}

class _AlarmDisplayScreenState extends State<AlarmDisplayScreen> {
  final data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    final payload = data['payload'];
    final reminder = jsonDecode(payload['reminder']);
    return WillPopScope(
      onWillPop: () => Future(() => true),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: secondaryColor,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarColor: secondaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
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
                  children: [
                    const Icon(
                      Icons.watch,
                      color: textColor,
                    ),
                    Text(
                      formattedDateTime(
                        DateTime.now(),
                        format: 'HH:mm',
                      ),
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
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
                        showNotification(
                          reminder,
                          snooze: 120,
                          isSnoozed: true,
                        );
                        Get.to(
                          () => const TreatmentScreen(),
                          transition: Transition.fade,
                        );
                      },
                      child: const Text(
                        '2 minutes later',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {
                        Uri uri = Uri.parse('$baseUrl/confirm-alarm');
                        final body = {
                          'intake': reminder['intake'].toString(),
                          'id': reminder['id'].toString()
                        };
                        final response = await NetworkController.post(
                          uri,
                          body: body,
                        );

                        if (response != null) {
                          if (response['message'] == 'success') {
                            Get.to(
                              () => const TreatmentScreen(),
                              transition: Transition.fadeIn,
                            );
                            showNotification(
                              reminder,
                              isSnoozed: true,
                              snooze: reminder['often'] * 60,
                            );
                          }
                        }
                      },
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
                TextButton(
                  onPressed: () {
                    FlutterRingtonePlayer.stop();
                    Get.to(
                      () => const TreatmentScreen(),
                      transition: Transition.fadeIn,
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: const Text(
                    'Stop',
                    style: TextStyle(
                      color: white,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
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