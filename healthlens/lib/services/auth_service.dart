//doesn't used anymore but working for log in
//replaced by auth.dart which is compiled with other backend

/* // auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and pincode
  Future<User?> signInWithEmailAndPincode(String email, String pincode) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pincode,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _saveUserDetails(user.displayName ?? 'Unknown User', email);
      }
      print('success Log in');
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong pincode provided.');
      }
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    print('signedOut');
  }

  // Save the user's name and email locally
  Future<void> _saveUserDetails(String userName, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    await prefs.setString('userEmail', email);
    print('saved Locally');
    print(userName);
  }

  // Get the user's name from local storage
  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  // Get the user's email from local storage
  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }
}
 */