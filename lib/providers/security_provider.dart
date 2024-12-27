import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityProvider with ChangeNotifier {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isAppLockEnabled = false;

  bool get isAppLockEnabled => _isAppLockEnabled;

  Future<void> initializeAppLock() async {
    final String? enabled = await _secureStorage.read(key: 'app_lock_enabled');
    _isAppLockEnabled = enabled == 'true';
    notifyListeners();
  }

  Future<bool> authenticateUser() async {
    if (!_isAppLockEnabled) return true;

    try {
      final bool canAuthenticate = await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();

      if (!canAuthenticate) return true;

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access Secure Notes',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      return didAuthenticate;
    } catch (e) {
      print('Authentication error: $e');
      return false;
    }
  }

  Future<void> toggleAppLock(bool value) async {
    try {
      if (value) {
        // Verify biometrics before enabling
        final bool authenticated = await authenticateUser();
        if (!authenticated) return;
      }

      await _secureStorage.write(
          key: 'app_lock_enabled', value: value.toString());
      _isAppLockEnabled = value;
      notifyListeners();
    } catch (e) {
      print('Error toggling app lock: $e');
    }
  }
}
