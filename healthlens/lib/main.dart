import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healthlens/calendar_history.dart';
import 'package:healthlens/entry_point.dart';
import 'package:healthlens/firebase_options.dart';
import 'login_page.dart';
import 'setup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
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
      initialRoute: '/setup',
      routes: {
        '/setup': (context) => SetupPage(),
        '/entry_point': (context) =>
            EntryPoint(pageController: PageController()),
        '/calendar': (context) => CalendarScreen(),
      },
    );
  }
}
