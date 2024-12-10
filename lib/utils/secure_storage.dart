import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  // Store encrypted note
  static Future<void> saveSecureNote(int noteId, String content) async {
    final encryptedContent = base64Encode(utf8.encode(content));
    await _storage.write(key: 'note_$noteId', value: encryptedContent);
  }

  // Retrieve encrypted note
  static Future<String?> getSecureNote(int noteId) async {
    final encryptedContent = await _storage.read(key: 'note_$noteId');
    if (encryptedContent == null) return null;
    return utf8.decode(base64Decode(encryptedContent));
  }

  // Delete secure note
  static Future<void> deleteSecureNote(int noteId) async {
    await _storage.delete(key: 'note_$noteId');
  }

  // Check if note exists in secure storage
  static Future<bool> hasSecureNote(int noteId) async {
    final value = await _storage.read(key: 'note_$noteId');
    return value != null;
  }

  // Delete all secure notes
  static Future<void> deleteAllSecureNotes() async {
    await _storage.deleteAll();
  }

  // Get all secure notes
  static Future<Map<String, String>> getAllSecureNotes() async {
    return await _storage.readAll();
  }
}
