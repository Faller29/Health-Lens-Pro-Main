import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthlens/main.dart';
import 'dart:math';

class WeakPasswordException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

Future<bool> signUp(
  String username,
  String email,
  String password,
  String sex,
  String lifestyle,
  String fName,
  String mName,
  String lName,
  int age,
  double height,
  double weight,
  int phoneNumber,
  List<String> chronicDisease,
) async {
  //concatenating name
  String fullName = fName + " " + mName + " " + lName;

  //getting the bmi
  double bodyMass = (weight / pow(height / 100, 2));
  String roundedString = bodyMass.toStringAsFixed(1);
  double totalBMI = double.parse(roundedString);
  String bmi;

  if (totalBMI < 18.5) {
    bmi = 'Underweight';
  } else if (totalBMI >= 18.5 && totalBMI <= 24.9) {
    bmi = 'Normal weight';
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

  double TER = weight * PA;
  double carbs, protein, fats;
  for (String chronic in chronicDisease) {
    if (chronic == 'Diabetes [Type 1 & 2]') {
      carbs = TER * 0.55;
      protein = TER * 0.20;
      fats = TER * 0.25;
    } else if (chronic == 'Hypertension') {
      carbs = TER * 0.60;
      protein = TER * 0.15;
      fats = TER * 0.25;
    } else if (chronic == 'Obesity') {
      carbs = TER * 0.55;
      protein = TER * 0.20;
      fats = TER * 0.25;
    } else {
      print('Error determining');
    }
  }

  try {
    // Create a new user with email and password
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // Update the user's profile with the username
    await userCredential.user?.updateDisplayName(username);

    currentUser = userCredential.user;
    currentUserDoc =
        FirebaseFirestore.instance.collection('user').doc(currentUser!.uid);
    await currentUserDoc?.set({
      'bmi': bmi,
      'age': age,
      'chronicDisease': chronicDisease,
      'height': height,
      'lifestyle': lifestyle,
      'name': fullName,
      'phoneNumber': phoneNumber,
      'sex': sex,
      'weight': weight,
      'TER': TER,
      'Physical Activity': PA,
      'reqCarbs': carbs,
      'reqProtein': protein,
      'reqFats': fats,
    });

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
