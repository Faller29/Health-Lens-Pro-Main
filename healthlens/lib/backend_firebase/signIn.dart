
import 'package:firebase_auth/firebase_auth.dart';

Future<void> signUp(String email, String password) async {
  try {
    String username = 'peter';
    // Create a new user with email and password
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // Update the user's profile with the username
    await userCredential.user?.updateDisplayName(username);

    // Sign up successful
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      // Handle weak password error
    } else if (e.code == 'email-already-in-use') {
      // Handle email already in use error
    }
  } catch (e) {
    // Handle other errors
  }
}