import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:healthlens/backend_firebase/firestore_provider.dart';
import 'package:healthlens/calendar_history.dart';
import 'package:healthlens/entry_point.dart';
import 'package:healthlens/exercise_page.dart';
import 'package:healthlens/firebase_options.dart';
import 'package:healthlens/foodServing.dart';
import 'package:healthlens/graph_data.dart';
import 'package:healthlens/healthProfile.dart';
import 'package:healthlens/userProfile.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'setup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'backend_firebase/auth.dart';
import 'healthProfile.dart';

User? thisUser;
String? userUid;

DocumentReference? currentUserDoc;
final db = FirebaseFirestore.instance;
String userFullName = '';
int? age;
String? gender;
String? email;
int? TER;
String? lifestyle;
double? height;
double? weight;
int? phoneNumber;
List<dynamic>? chronicDisease = [];
int? gramCarbs;
int? gramProtein;
int? gramFats;
String? physicalActivity;
String? userBMI;
Timestamp timestamp = Timestamp.now();
String? firstName;
String? middleName;
String? lastName;
String? middleInitial;
File? profileImageUrl;
String? currentUserEmail;
String? currentUserPincode;
double? desiredBodyWeight;
int? dailyCarbs;
int? dailyProtein;
int? dailyFats;
int? dailyCalories;
String error = '';
num avrgFat = 0;
num avrgProteins = 0;
num avrgCarbs = 0;
num avrg7Fat = 0;
num avrg7Proteins = 0;
num avrg7Carbs = 0;
num avrg30Fat = 0;
num avrg30Proteins = 0;
num avrg30Carbs = 0;
var url;

void saveData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userFullName = prefs.getString('userFullName') ?? '';
  age = prefs.getInt('age') ?? 0;
  gender = prefs.getString('gender') ?? '';
  email = prefs.getString('userEmail') ?? '';
  TER = prefs.getInt('TER') ?? 0;
  lifestyle = prefs.getString('lifestyle') ?? '';
  height = prefs.getDouble('height') ?? 0.0;
  weight = prefs.getDouble('weight') ?? 0.0;
  phoneNumber = prefs.getInt('phoneNumber') ?? 0;
  gramCarbs = prefs.getInt('gramCarbs') ?? 0;
  gramProtein = prefs.getInt('gramProtein') ?? 0;
  gramFats = prefs.getInt('gramFats') ?? 0;
  physicalActivity = prefs.getString('physicalActivity') ?? '';
  userBMI = prefs.getString('userBMI') ?? '';
  chronicDisease = prefs.getStringList('chronicDisease');
  firstName = prefs.getString('firstName') ?? '';
  middleName = prefs.getString('middleName') ?? '';
  lastName = prefs.getString('lastName') ?? '';
  middleInitial = prefs.getString('middleInitial') ?? '';
  //profileImageUrl = prefs.getString('profileImageUrl') ?? '';
  currentUserEmail = prefs.getString('currentUserEmail') ?? '';
  currentUserPincode = prefs.getString('currentUserPincode') ?? '';
  desiredBodyWeight = prefs.getDouble('desiredBW') ?? 0.0;
  dailyCarbs = prefs.getInt('dailyCarbs') ?? 0;
  dailyProtein = prefs.getInt('dailyProtein') ?? 0;
  dailyFats = prefs.getInt('dailyFats') ?? 0;
  dailyCalories = prefs.getInt('dailyCalories') ?? 0;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  db.settings = const Settings(persistenceEnabled: true);

  SharedPreferences prefs = await SharedPreferences.getInstance();

  currentUserEmail = prefs.getString('currentUserEmail') ?? '';
  currentUserPincode = prefs.getString('currentUserPincode') ?? '';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xfff1f4f8),
      ),
      // Initial route will be determined by authentication status and user registration
      home: FutureBuilder(
        future: _handleStartScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    CircularProgressIndicator()); // Show a loading indicator while checking authentication
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Authentication error: ${snapshot.error}'));
          } else {
            return snapshot
                .data!; // Return the appropriate widget based on authentication status
          }
        },
      ),
      routes: {
        '/setup': (context) => SetupPage(),
        '/entry_point': (context) =>
            EntryPoint(pageController: PageController()),
        '/calendar': (context) => CalendarScreen(),
        '/editUser': (context) => UserProfilePage(),
        '/editHealth': (context) => healthProfile(),
        '/foodServing': (context) => FoodServing(),
        '/exercise': (context) => ExercisePage(),
      },
    );
  }

  Future<StatefulWidget> _handleStartScreen() async {
    Auth _auth = Auth();
    final isFirstLaunch = await _isFirstLaunch();

    if (isFirstLaunch) {
      // User is opening the app for the first time, navigate to SetupPage
      return SetupPage();
    } else {
      if (await _auth.isLoggedIn()) {
        // User is logged in, navigate to EntryPoint

        return EntryPoint();
      } else {
        // User has signed up before but is not logged in, navigate to LoginPage
        return LoginPage();
      }
    }
  }

  Future<bool> _isFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    // Set isFirstLaunch to false after 2 minutes
    Future.delayed(Duration(minutes: 1), () async {
      prefs.setBool('isFirstLaunch', false);
    });

    return isFirstLaunch;
  }
}

class Auth {
  Future<bool> isLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      thisUser = user;
    }
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        if (user != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final String currentDate =
              DateTime.now().toIso8601String().split('T')[0];

          final thisUserUid = user.uid;

          //get user Macros History
          final dailyUserMacros = db
              .collection("userMacros")
              .doc(thisUserUid)
              .collection('MacrosIntakeHistory')
              .doc(currentDate);
          DocumentSnapshot document = await db
              .collection("userMacros")
              .doc(thisUserUid)
              .collection('MacrosIntakeHistory')
              .doc(currentDate)
              .get();
          //get uuser daily macros
          final userMacros =
              await db.collection("userMacros").doc(thisUserUid).get();

          //get user data
          final theUser = await db.collection("user").doc(thisUserUid).get();

          final macros = userMacros.data() as Map<String, dynamic>;
          final data = theUser.data() as Map<String, dynamic>;

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
          await prefs.setInt('gramCarbs', data['gramCarbs']);
          await prefs.setInt('gramProtein', data['gramProtein']);
          await prefs.setInt('gramFats', data['gramFats']);
          await prefs.setString('physicalActivity', data['lifestyle']);
          await prefs.setString('userBMI', data['bmi']);
          await prefs.setStringList(
              'chronicDisease', data['chronicDisease'].cast<String>());

          await prefs.setInt('dailyCarbs', macros['carbs']);
          await prefs.setInt('dailyProtein', macros['proteins']);
          await prefs.setInt('dailyFats', macros['fats']);
          await prefs.setInt('dailyCalories', macros['calories']);

          try {
            final userRef = FirebaseStorage.instance
                .ref()
                .child('users/$thisUserUid/profile.jpg');
            url = await userRef.getDownloadURL();
          } catch (e) {
            // If the download URL is not found or any error occurs, set url to an empty string
            url = null;
          }

          chronicDisease = prefs.getStringList('chronicDisease');
          userFullName = prefs.getString('userFullName') ?? '';
          age = prefs.getInt('age') ?? 0;
          gender = prefs.getString('gender') ?? '';
          email = prefs.getString('userEmail') ?? '';
          TER = prefs.getInt('TER') ?? 0;
          lifestyle = prefs.getString('lifestyle') ?? '';
          height = prefs.getDouble('height') ?? 0.0;
          weight = prefs.getDouble('weight') ?? 0.0;
          phoneNumber = prefs.getInt('phoneNumber') ?? 0;
          gramCarbs = prefs.getInt('gramCarbs') ?? 0;
          gramProtein = prefs.getInt('gramProtein') ?? 0;
          gramFats = prefs.getInt('gramFats') ?? 0;
          physicalActivity = prefs.getString('physicalActivity') ?? '';
          userBMI = prefs.getString('userBMI') ?? '';
          chronicDisease = prefs.getStringList('chronicDisease');
          firstName = prefs.getString('firstName') ?? '';
          middleName = prefs.getString('middleName') ?? '';
          lastName = prefs.getString('lastName') ?? '';
          middleInitial = prefs.getString('middleInitial') ?? '';
          //profileImageUrl = prefs.getString('profileImageUrl') ?? '';
          currentUserEmail = prefs.getString('currentUserEmail') ?? '';
          currentUserPincode = prefs.getString('currentUserPincode') ?? '';
          dailyCarbs = prefs.getInt('dailyCarbs') ?? 0;
          dailyProtein = prefs.getInt('dailyProtein') ?? 0;
          dailyFats = prefs.getInt('dailyFats') ?? 0;
          dailyCalories = prefs.getInt('dailyCalories') ?? 0;

          if (document.exists) {
            await dailyUserMacros.set({
              'carbs': dailyCarbs,
              'fats': dailyFats,
              'proteins': dailyProtein,
            });
          } else {
            await dailyUserMacros.set({
              'carbs': 0,
              'fats': 0,
              'proteins': 0,
              'calories': 0,
            });
            await FirebaseFirestore.instance
                .collection('userMacros')
                .doc(thisUser?.uid)
                .set({
              'carbs': 0,
              'proteins': 0,
              'fats': 0,
              'calories': 0,
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
          fetchMacrosData();
        }
      }
    } on SocketException catch (_) {
      print('not connected');
      saveData();
    }
    return user != null;
  }
}
