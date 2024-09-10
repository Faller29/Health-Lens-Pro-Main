import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:healthlens/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeakPasswordException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and pincode
  Future<User?> signInWithEmailAndPincode(String email, String pincode) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pincode,
      );

      thisUser = userCredential.user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentUser', thisUser!.uid.toString());
      userUid = prefs.getString('currentUser')!;

      await prefs.setString('currentUserEmail', email);
      await prefs.setString('currentUserPincode', pincode);

      if (thisUser != null) {
        await _saveUserDetails(thisUser?.displayName ?? 'Unknown User', email);
      }

      final currentUserInfo =
          await db.collection("user").doc(thisUser?.uid).get();
      final data = currentUserInfo.data() as Map<String, dynamic>;
      await prefs.setString('userName', thisUser?.displayName ?? 'No user');
      await prefs.setString('firstName', data['firstName']);
      await prefs.setString('middleInitial', data['middleInitial']);
      await prefs.setString('middleName', data['middleName']);
      await prefs.setString('lastName', data['lastName']);
      await prefs.setString('userFullName', data['name']);
      await prefs.setInt('age', data['age']);
      await prefs.setString('gender', data['sex']);
      await prefs.setInt('TER', data['TER']);
      await prefs.setDouble('height', data['height']);
      await prefs.setDouble('weight', data['weight']);
      await prefs.setInt('phoneNumber', data['phoneNumber']);
      await prefs.setInt('gramCarbs', data['reqCarbs']);
      await prefs.setInt('gramProtein', data['reqProtein']);
      await prefs.setInt('gramFats', data['reqFats']);
      await prefs.setString('physicalActivity', data['lifestyle']);
      await prefs.setString('userBMI', data['bmi']);
      await prefs.setStringList(
          'chronicDisease', data['chronicDisease'].cast<String>());
      await prefs.setString('email', email);
      await prefs.setDouble('desiredBW', data['desiredBodyWeight']);
      await prefs.setString('lifestyle', data['lifestyle']);

      // Sign up successful
      saveData();
      print('success Log in');
      return thisUser;
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
    await prefs.remove('userEmail');
    await prefs.remove('currentUserEmail');

    await prefs.remove('currentUserPincode');
    thisUser = null;
    currentUserEmail = '';
    currentUserPincode = '';
    print('signedOut');
  }

  // Save the user's name and email locally
  Future<void> _saveUserDetails(String userName, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    await prefs.setString('userEmail', email);

    final currentUserInfo =
        await db.collection("user").doc(thisUser?.uid).get();
    final userId = thisUser!.uid;

    final data = currentUserInfo.data() as Map<String, dynamic>;
    await prefs.setString('firstName', data['firstName']);
    await prefs.setString('middleName', data['middleName']);
    await prefs.setString('middleInitial', data['middleInitial']);
    await prefs.setString('lastName', data['lastName']);
    await prefs.setString('userFullName', data['name']);
    await prefs.setInt('age', data['age']);
    await prefs.setString('gender', data['sex']);
    await prefs.setInt('TER', data['TER']);
    await prefs.setDouble('height', data['height']);
    await prefs.setDouble('weight', data['weight']);
    await prefs.setInt('phoneNumber', data['phoneNumber']);
    await prefs.setInt('gramCarbs', data['reqCarbs']);
    await prefs.setInt('gramProtein', data['reqProtein']);
    await prefs.setInt('gramFats', data['reqFats']);
    await prefs.setString('physicalActivity', data['lifestyle']);
    await prefs.setString('userBMI', data['bmi']);
    await prefs.setStringList(
        'chronicDisease', data['chronicDisease'].cast<String>());
    //await prefs.setString('profileImageUrl', data['profileImageUrl']);
    //profileImageUrl = data['profileImageUrl'];
    chronicDisease = prefs.getStringList('chronicDisease');
    await prefs.setString('lifestyle', data['lifestyle']);

    try {
      final userRef =
          FirebaseStorage.instance.ref().child('users/$userUid/profile.jpg');
      url = await userRef.getDownloadURL();
    } catch (e) {
      // If the download URL is not found or any error occurs, set url to an empty string
      url = null;
    }

    print(chronicDisease);
    saveData();
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

  // Sign up with email and password
  Future<bool> signUp(String username, String email, String password) async {
    try {
      // Create a new user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

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
}
