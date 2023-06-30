import "dart:convert";

import "package:get_storage/get_storage.dart";
import "package:http/http.dart" as http;

class NetworkController {
  static Future fetch(Uri uri) async {
    try {
      final token = GetStorage().read('authToken');
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  static Future post(Uri uri, {required Map<String, dynamic> body}) async {
    try {
      final token = GetStorage().read('authToken');
      final response = await http.post(uri, body: body, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw response.statusCode;
      }
    } catch (e) {
      return {'message': 'failed: $e'};
    }
  }
}
