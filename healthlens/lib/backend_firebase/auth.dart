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
      print('loggedIn: $thisUser');
      print('User ID: ${thisUser?.uid}');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentUser', thisUser!.uid.toString());
      userUid = prefs.getString('currentUser')!;

      await prefs.setString('currentUserEmail', email);
      await prefs.setString('currentUserPincode', pincode);

      if (thisUser != null) {
        await _saveUserDetails(email);
      }
      final String currentDate = DateTime.now().toIso8601String().split('T')[0];
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
      await prefs.setInt('gramCarbs', data['gramCarbs']);
      await prefs.setInt('gramProtein', data['gramProtein']);
      await prefs.setInt('gramFats', data['gramFats']);
      await prefs.setString('physicalActivity', data['lifestyle']);
      await prefs.setString('userBMI', data['bmi']);
      await prefs.setStringList(
          'chronicDisease', data['chronicDisease'].cast<String>());
      await prefs.setString('email', email);
      await prefs.setDouble('desiredBW', data['desiredBodyWeight']);
      await prefs.setString('lifestyle', data['lifestyle']);

      final userMacrosDoc = await FirebaseFirestore.instance
          .collection('userMacros')
          .doc(thisUser?.uid)
          .get();
      final userMacros = userMacrosDoc.data()!;
      await prefs.setInt('dailyCarbs', _parseInt(userMacros['carbs']));
      await prefs.setInt('dailyProtein', _parseInt(userMacros['proteins']));
      await prefs.setInt('dailyFats', _parseInt(userMacros['fats']));
      await prefs.setInt('dailyCalories', _parseInt(userMacros['calories']));
      await prefs.setString('lastLogIn', currentDate);
      dailyCalories = userMacros['calories'];
      dailyCarbs = userMacros['carbs'];
      dailyProtein = userMacros['proteins'];
      dailyFats = userMacros['fats'];
      lastLogIn = userMacros['lastLogIn'];
      print("signIn success");
      saveData();
      print('''
        User Info:
        -----------
        userId: ${thisUser!.uid}
        Full Name: $userFullName
        Age: $age
        Gender: $gender
        Email: $email
        TER: $TER
        Lifestyle: $lifestyle
        Height: ${height?.toStringAsFixed(2)} m
        Weight: ${weight?.toStringAsFixed(2)} kg
        Macronutrient Intake:
          Carbs: $gramCarbs g
          Protein: $gramProtein g
          Fats: $gramFats g
        Physical Activity: $physicalActivity
        BMI: $userBMI
        Chronic Disease(s): ${chronicDisease?.join(', ') ?? 'None'}
        First Name: $firstName
        Middle Name: $middleName
        Last Name: $lastName
        Middle Initial: $middleInitial
        Current User Email: $currentUserEmail
        Current User Pincode: $currentUserPincode
        Desired Body Weight: ${desiredBodyWeight?.toStringAsFixed(2)} kg
        Daily Macronutrients Goals:
          Carbs: $dailyCarbs g
          Protein: $dailyProtein g
          Fats: $dailyFats g
          Calories: $dailyCalories kcal
      ''');
      print('success Log in');
      print(currentDate);
      print(lastLogIn);
      print("log in state: ${(currentDate != lastLogIn)}");
      if (currentDate != lastLogIn) {
        print('not tru sa current date vs last');
        await FirebaseFirestore.instance
            .collection('userMacros')
            .doc(thisUser?.uid)
            .set({
          'carbs': 0,
          'proteins': 0,
          'fats': 0,
          'calories': 0,
          'lastLogIn': currentDate,
        }, SetOptions(merge: true));

        await prefs.setInt('dailyCarbs', 0);
        await prefs.setInt('dailyProtein', 0);
        await prefs.setInt('dailyFats', 0);
        await prefs.setInt('dailyCalories', 0);
        dailyCarbs = prefs.getInt('dailyCarbs') ?? 0;
        dailyProtein = prefs.getInt('dailyProtein') ?? 0;
        dailyFats = prefs.getInt('dailyFats') ?? 0;
        dailyCalories = prefs.getInt('dailyCalories') ?? 0;
      }

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

  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        return 0; // Default to 0 if parsing fails
      }
    }
    return 0;
  }

  // Sign out
  Future<void> signOut() async {
    final String currentDate = DateTime.now().toIso8601String().split('T')[0];

    await FirebaseFirestore.instance
        .collection('userMacros')
        .doc(thisUser?.uid)
        .set(
      {
        'lastLogIn': currentDate,
      },
      SetOptions(merge: true),
    );
    await _auth.signOut();
    thisUser = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    thisUser = null;
    currentUserEmail = '';
    currentUserPincode = '';
    print('signedOut');
  }

  // Save the user's name and email locally
  Future<void> _saveUserDetails(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
    await prefs.setInt('gramCarbs', data['gramCarbs']);
    await prefs.setInt('gramProtein', data['gramProtein']);
    await prefs.setInt('gramFats', data['gramFats']);
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

    saveData();
  }

  // Get the user's email from local storage
  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  // Sign up with email and password
  Future<bool> signUp(String email, String password) async {
    try {
      // Create a new user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

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

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

      return 'Password reset email sent!';
    } on FirebaseAuthException catch (e) {
      // Handle errors here, e.g., show a message to the user
      return 'Error sending password reset email\n${e.message}';
    }
  }
}
