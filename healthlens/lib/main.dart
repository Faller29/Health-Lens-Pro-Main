import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healthlens/backend_firebase/firestore_provider.dart';
import 'package:healthlens/calendar_history.dart';
import 'package:healthlens/entry_point.dart';
import 'package:healthlens/firebase_options.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'setup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'backend_firebase/auth.dart'; // Import your combined Auth class

User? currentUser;
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
List<dynamic>? chronicDisease;
int? gramCarbs;
int? gramProtein;
int? gramFats;
String? physicalActivity;
String? userBMI;
Timestamp timestamp = Timestamp.now();

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
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  db.settings = const Settings(persistenceEnabled: true);
  saveData();
  // Enable offline persistence

  // Connect to the Authentication emulator
  //FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //FirebaseFirestore.instance.useFirestoreEmulator('localhost', 9098);

  //test connection to firebase
  /**try {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.add({'test': 'connected'});
    print('Data added successfully!');
  } catch (e) {
    print('Error adding data: $e');
  }**/

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
    print(Future.delayed(Duration(minutes: 1)));
    // Set isFirstLaunch to false after 2 minutes
    Future.delayed(Duration(minutes: 1), () async {
      prefs.setBool('isFirstLaunch', false);
    });

    return isFirstLaunch;
  }
}

// Assuming your Auth class is defined in a separate file
class Auth {
  Future<bool> isLoggedIn() async {
    // Implement your logic to check if the user is logged in
    // For example, you might check the Firebase authentication state
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}
