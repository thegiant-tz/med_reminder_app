import 'package:medication_reminder_app/app/controllers/network_controller.dart';
import 'package:medication_reminder_app/app/helpers/general_helper.dart';

class ReminderController {
  static Future getReminders({int? id}) async {
    Map response;
    if (id == null) {
      response = (await NetworkController.fetch(
              Uri.parse('$baseUrl/get-reminders'))) ??
          {};
    } else {
      response = (await NetworkController.post(
              Uri.parse('$baseUrl/get-reminder'),
              body: {'id': id.toString()})) ??
          {};
    }
    return response;
  }

  static Future getPatients() async {
    Uri uri = Uri.parse('$baseUrl/get-patients');
    final response = await NetworkController.fetch(uri);
    return response;
  }

  static Future getPendingReminders() async {
    final response = await NetworkController.fetch(
        Uri.parse('$baseUrl/get-pending-Patients'));
    return response;
  }
}
