import 'package:local_auth/local_auth.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricAuth {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<bool> authenticateUser() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      if (!canAuthenticate) return false;

      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to access Secure Notes',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      print('Error during authentication: $e');
      return false;
    }
  }

  Future<void> setAppLockEnabled(bool enabled) async {
    await _secureStorage.write(
        key: 'app_lock_enabled', value: enabled.toString());
  }

  Future<bool> isAppLockEnabled() async {
    final String? enabled = await _secureStorage.read(key: 'app_lock_enabled');
    return enabled == 'true';
  }
}
