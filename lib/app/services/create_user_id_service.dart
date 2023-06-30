import 'package:uuid/uuid.dart';

class AppUser {
  static String createId() {
    var uuid = const Uuid();
    return uuid.v1();
  }
}
