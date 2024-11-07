import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:healthlens/main.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class WeakPasswordException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

final FirebaseStorage _storage = FirebaseStorage.instance;

//roundUp to the nearest 50 and hundreds for calorie
int roundUp50s(int number) {
  int remainder = number % 50;

  if (remainder == 0) {
    return number; // Already a multiple of 50, return the number itself.
  } else if (remainder < 25) {
    return number - remainder; // Round down to the nearest multiple of 50.
  } else {
    return number + (50 - remainder); // Round up to the nearest multiple of 50.
  }
}

//roundUp to the nearest 5 and hundreds for macronutrients
int roundUp5s(int number) {
  int remainder = number % 5;

  if (remainder == 0) {
    return number; // Already a multiple of 5, return the number itself.
  } else if (remainder < 3) {
    return number - remainder; // Round down to the nearest multiple of 5.
  } else {
    return number + (5 - remainder); // Round up to the nearest multiple of 5.
  }
}

//getting desired body weight
double desiredBW(double height) {
  double dbWeight = (height - 100) - (.10 * (height - 100));
  return dbWeight;
}

Future<bool> signUp(
  String email,
  String password,
  String sex,
  String lifestyle,
  String fName,
  String mName,
  String lName,
  int age,
  double height,
  double doubleWeight,
  List<String> chronicDisease,
) async {
  //concatenating name
  String fullName = fName + " " + mName + " " + lName;

  desiredBodyWeight = desiredBW(height);

  String strWeight = doubleWeight.toStringAsFixed(0);
  int weight = int.parse(strWeight);

  //getting the bmi
  double bodyMass = (weight / pow(height / 100, 2));
  String roundedString = bodyMass.toStringAsFixed(1);
  double totalBMI = double.parse(roundedString);
  String bmi;

  if (totalBMI < 18.5) {
    bmi = 'Underweight';
  } else if (totalBMI >= 18.5 && totalBMI <= 24.9) {
    bmi = 'Normal';
  } else if (totalBMI >= 25.0 && totalBMI <= 29.9) {
    bmi = 'Pre-obesity';
  } else if (totalBMI >= 30.0 && totalBMI <= 34.9) {
    bmi = 'Obesity Class 1';
  } else if (totalBMI >= 35.0 && totalBMI <= 39.9) {
    bmi = 'Obesity Class 2';
  } else {
    bmi = 'Obesity Class 3';
  }

  int PA;
  //getting TER
  switch (lifestyle) {
    case 'Sedentary':
      PA = 30;
      break;
    case 'Light':
      PA = 35;
      break;
    case 'Moderate':
      PA = 40;
      break;
    case 'Vigorous':
      PA = 45;
      break;
    default:
      PA = 0;
  }
  double thisTER = (desiredBodyWeight! * PA);

  String strThisTER = thisTER.toStringAsFixed(0);
  int intTER = int.parse(strThisTER);
  TER = roundUp50s(intTER);

  int carbs = 0, protein = 0, fats = 0;
  double doubleCarbs = 0, doubleProtein = 0, doubleFats = 0;

  //required TER per chronic disease
  if (chronicDisease.length == 1 && chronicDisease.contains('Hypertension')) {
    carbs = (TER! * 0.60).round();
    protein = (TER! * 0.15).round();
    fats = (TER! * 0.25).round();
  } else if (chronicDisease.length == 2 &&
      chronicDisease.contains('Obesity') &&
      chronicDisease.contains('Hypertension')) {
    carbs = (TER! * 0.60).round();
    protein = (TER! * 0.15).round();
    fats = (TER! * 0.25).round();
  } else if (chronicDisease.length == 0) {
    carbs = (TER! * 0.60).round();
    protein = (TER! * 0.15).round();
    fats = (TER! * 0.25).round();
  } else {
    carbs = (TER! * 0.55).round();
    protein = (TER! * 0.20).round();
    fats = (TER! * 0.25).round();
  }

  //required daily grams of macronutrients

  doubleCarbs = carbs / 4;
  doubleFats = fats / 9;
  doubleProtein = protein / 4;
  print(doubleCarbs);
  print(weight);
  //parsing double to interget no need to pay attention
  String strCarbs = doubleCarbs.toStringAsFixed(0);
  String strProtein = doubleProtein.toStringAsFixed(0);
  String strFats = doubleFats.toStringAsFixed(0);
  int gCarbs = int.parse(strCarbs);
  int gFats = int.parse(strFats);
  int gProtein = int.parse(strProtein);
  gCarbs = roundUp5s(gCarbs);
  gProtein = roundUp5s(gProtein);
  gFats = roundUp5s(gFats);
  print(gFats);
  if (gCarbs < 0 || gFats < 0 || gProtein < 0) {
    return false;
  }
  try {
    // Create a new user with email and password
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // Update the user's profile with the username
    await userCredential.user?.updateDisplayName(fName);

    String initial = mName[0].toUpperCase();
    thisUser = userCredential.user;

    print("userId in Sign Up: ${thisUser!.uid}");

    currentUserDoc =
        FirebaseFirestore.instance.collection('user').doc(thisUser!.uid);
    await currentUserDoc?.set({
      'fullName': fullName,
      'firstName': fName,
      'middleName': mName,
      'middleInitial': initial,
      'lastName': lName,
      'bmi': bmi,
      'age': age,
      'chronicDisease': chronicDisease,
      'height': height,
      'lifestyle': lifestyle,
      'name': fullName,
      'sex': sex,
      'weight': doubleWeight,
      'TER': TER,
      'physicalActivity': PA,
      'reqCarbs': carbs,
      'reqProtein': protein,
      'reqFats': fats,
      'gramCarbs': gCarbs,
      'gramProtein': gProtein,
      'gramFats': gFats,
      'desiredBodyWeight': desiredBodyWeight,
    });

    final userMacrosDocRef =
        FirebaseFirestore.instance.collection('userMacros').doc(thisUser?.uid);

    // Retrieve the user's current macronutrients
    final userMacrosDoc = await userMacrosDocRef.get();
    final String currentDate = DateTime.now().toIso8601String().split('T')[0];
    if (!userMacrosDoc.exists) {
      // Document does not exist, create it with default values
      print(
          'userMacros document does not exist. Creating with default values.');

      await userMacrosDocRef.set({
        'carbs': 0,
        'proteins': 0,
        'fats': 0,
        'calories': 0,
        'lastLogIn': currentDate,
      });
    }
    String thisLifestyle = lifestyle;
    uploadProfileImage();
    final currentUserInfo =
        await db.collection("user").doc(thisUser?.uid).get();
    final data = currentUserInfo.data() as Map<String, dynamic>;
    print(data);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('trying to save');
    //await prefs.setString('userName', thisUser?.displayName ?? 'No user');
    await prefs.setString('firstName', data['firstName']);
    await prefs.setString('middleInitial', initial);
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
    print('saving');
    await prefs.setInt('dailyCarbs', 0);
    await prefs.setInt('dailyProtein', 0);
    await prefs.setInt('dailyFats', 0);
    await prefs.setInt('dailyCalories', 0);
    await prefs.setString('lastLogIn', currentDate);

    // Sign up successful
    print('saved?');
    saveData();
    print('it saved');
    lifestyle = thisLifestyle;
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

Future<void> uploadProfileImage() async {
  final String userId = thisUser!.uid;
  final userRef = _storage.ref().child('users/$userId/profile.jpg');

  // Load the image from assets
  ByteData data = await rootBundle.load('assets/images/profile.jpg');
  List<int> bytes = data.buffer.asUint8List();

  // Upload the image to Firebase Storage
  try {
    await userRef.putData(Uint8List.fromList(bytes));
    print('Profile image uploaded successfully!');
  } catch (e) {
    print('Error uploading profile image: $e');
  }
}
