import 'package:flutter/material.dart';
import 'entry_point.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a PageController instance
    PageController pageController = PageController();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EntryPoint(
          pageController:
              pageController), // Pass the pageController to EntryPoint
    );
  }
}
