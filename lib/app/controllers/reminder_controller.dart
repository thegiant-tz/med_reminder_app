import 'package:medication_reminder_app/app/controllers/network_controller.dart';
import 'package:medication_reminder_app/app/helpers/general_helper.dart';

class ReminderController {
  static Future getReminders() async {
    final response = await NetworkController.fetch(
      Uri.parse('$baseUrl/get-reminders')
    );
    return response;
  }
}
