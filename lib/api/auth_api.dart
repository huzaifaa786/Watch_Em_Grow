import 'package:firebase_auth/firebase_auth.dart';
import 'package:mipromo/exceptions/auth_api_exception.dart';

class AuthApi {
  final _firebaseAuth = FirebaseAuth.instance;

  /// Fetch the current Firebase User
  User? get currentUser => _firebaseAuth.currentUser;

  /// Signup the user using Email and Password 
  Future<User> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential authResult =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = authResult.user;

      if (user != null) {
        return user;
      } else {
        throw AuthApiException(
          title: 'Server Error',
          message: 'Failed to Create Account, please try again later.',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw AuthApiException(
        title: 'Authentication Failed',
        message: e.message,
      );
    }
  }

  /// Login the user using Email and Password
  Future<User> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        return user;
      } else {
        throw AuthApiException(
          title: 'Server Error',
          message: 'Failed to Login, please try again later.',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw AuthApiException(
        title: 'Authentication Failed',
        message: e.message,
      );
    }
  }

  /// Send a Email to Reset the Password
  Future<bool> forgotPassword({
    required String email,
  }) async {
    try {
      bool result = false;

      await _firebaseAuth
          .sendPasswordResetEmail(
            email: email,
          )
          .then(
            (_) => result = true,
          );

      return result;
    } on FirebaseAuthException catch (e) {
      throw AuthApiException(
        title: 'Failed to send Reset Email',
        message: e.message,
      );
    }
  }

  /// Send a Email to Verify the account
  Future<bool> sendEmailVerification(User user) async {
    try {
      bool result = false;
      await user.sendEmailVerification().then(
            (_) => result = true,
          );

      return result;
    } on FirebaseAuthException catch (e) {
      throw AuthApiException(
        title: 'Failed to send Vefification Email',
        message: e.message,
      );
    }
  }

  /// Logout the user
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future verifyOldPassword(String oldPass, String newPass) async {
    final user = _firebaseAuth.currentUser;
    if(user != null){
      final credentials = EmailAuthProvider.credential(email: user.email!, password: oldPass);
      try {
        /*UserCredential userCredentials = */
        await user.reauthenticateWithCredential(credentials).then((value) async {
          if(value.user != null){
            await user.updatePassword(newPass).then((value){
              return 3;
            }).catchError((error){
              return 2;
            });
          }
        });

      }catch(e){
        print("reauthenticateWithCredential: " + e.toString());
        return 0;
      }
    }
  }
}
