import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Add this line
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']
      // Remove clientId/serverClientId
      );
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('Starting Google Sign-In flow...');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google Sign-In cancelled by user.');
        return null;
      }

      print('Google Sign-In successful for user: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      print(
          'Successfully signed in with Google: ${userCredential.user?.email}');
      return userCredential;
    } on PlatformException catch (e) {
      print('PlatformException during sign in:');
      print('  Error code: ${e.code}');
      print('  Message: ${e.message}');
      print('  Details: ${e.details}');
      return null;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _googleSignIn.signOut(),
        _auth.signOut(),
      ]);
      print('Successfully signed out');
    } catch (e) {
      print('Error signing out: $e');
      throw Exception('Sign out failed: $e');
    }
  }
}
