import 'package:firebase_auth/firebase_auth.dart';

class WeakPasswordException implements Exception {}
class EmailAlreadyInUseException implements Exception {}

Future<bool> signUp(String username, String email, String password) async {
  try {
    // Create a new user with email and password
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // Update the user's profile with the username
    await userCredential.user?.updateDisplayName(username);

    // Sign up successful
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      throw WeakPasswordException();
    } else if (e.code == 'email-already-in-use') {
      throw EmailAlreadyInUseException();
    }
    return false;
  } catch (e) {
    // Handle other errors
    return false;
  }
}