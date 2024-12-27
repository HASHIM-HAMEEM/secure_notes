import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const storage = FlutterSecureStorage();
  static const String pinKey = 'note_app_pin';

  static Future<void> savePin(String pin) async {
    await storage.write(key: pinKey, value: pin);
  }

  static Future<String?> getPin() async {
    return await storage.read(key: pinKey);
  }

  static Future<bool> hasPin() async {
    return await storage.containsKey(key: pinKey);
  }

  // Add this method to fix the error
  static Future<void> deletePin() async {
    await storage.delete(key: pinKey);
  }
}
