import 'package:flutter/material.dart';
import 'package:healthlens/entry_point.dart';
import 'login_page.dart';
import 'setup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => SetupPage(),
        '/entry_point': (context) =>
            EntryPoint(pageController: PageController()),
      },
    );
  }
}
