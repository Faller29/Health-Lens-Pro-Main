import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthlens/main.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class WeakPasswordException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

int roundToNearest50(int number) {
  int remainder = number % 50;
  if (remainder >= 25) {
    return number + (50 - remainder);
  } else {
    return number - remainder;
  }
}

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
  double doubleWeight,
  int phoneNumber,
  List<String> chronicDisease,
) async {
  //concatenating name
  String fullName = fName + " " + mName + " " + lName;
  print(fullName);
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

  int TER = weight * PA;
  int carbs = 0, protein = 0, fats = 0;
  double doubleCarbs = 0, doubleProtein = 0, doubleFats = 0;

  //required TER per chronic disease
  for (String chronic in chronicDisease) {
    if (chronic == 'Diabetes [Type 1 & 2]' || chronic == 'Obesity') {
      carbs = (TER * 0.55).round();
      protein = (TER * 0.20).round();
      fats = (TER * 0.25).round();
    } else if (chronic == 'Hypertension') {
      carbs = (TER * 0.60).round();
      protein = (TER * 0.15).round();
      fats = (TER * 0.25).round();
    } else {
      print('Error determining');
    }
  }

  //required daily grams of macronutrients

  doubleCarbs = carbs / 4;
  doubleFats = fats / 9;
  doubleProtein = protein / 4;

  //parsing double to interget no need to pay attention
  String strCarbs = doubleCarbs.toStringAsFixed(0);
  String strProtein = doubleProtein.toStringAsFixed(0);
  String strFats = doubleFats.toStringAsFixed(0);
  int gCarbs = int.parse(strCarbs);
  int gFats = int.parse(strFats);
  int gProtein = int.parse(strProtein);

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
      'firstName': fName,
      'middleName': mName,
      'lastName': lName,
      'bmi': bmi,
      'age': age,
      'chronicDisease': chronicDisease,
      'height': height,
      'lifestyle': lifestyle,
      'name': fullName,
      'phoneNumber': phoneNumber,
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
    });

    final currentUserInfo =
        await db.collection("user").doc(currentUser?.uid).get();
    final data = currentUserInfo.data() as Map<String, dynamic>;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', currentUser?.displayName ?? 'No user');
    await prefs.setString('firstName', data['firstName']);
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
    await prefs.setString('userBMI', data['bmi']);
    await prefs.setStringList(
        'chronicDisease', data['chronicDisease'].cast<String>());
    // Sign up successful
    saveData();
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
