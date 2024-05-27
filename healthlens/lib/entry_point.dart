import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'homePage.dart';
import 'camerapage.dart';
import 'profilePage.dart';
import 'analyticspage.dart';
import 'package:google_fonts/google_fonts.dart';

class EntryPoint extends StatefulWidget {
  final PageController? pageController;

  const EntryPoint({Key? key, this.pageController}) : super(key: key);

  @override
  _EntryPointState createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  int _selectedIndex = 0;
  int currentPageIndex = 0;

  // Define a list of titles corresponding to each page
  final List<String> pageTitles = [
    'Dashboard', // Title for the HomePage
    'Camera', // Title for the CameraPage
    'Analytics', // Title for the AnalyticsPage
    'Profile', // Title for the ProfilePage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navigate to the selected page in the PageView
      widget.pageController?.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          pageTitles[currentPageIndex],
          style: GoogleFonts.outfit(
            fontSize: 25.0,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff4b39ef),
      ),
      body: Center(
        child: [
          HomePage(),
          CameraPage(),
          AnalyticsPage(),
          ProfilePage(),
        ][currentPageIndex],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: CrystalNavigationBar(
          currentIndex: currentPageIndex,
          height: 10,
          enableFloatingNavBar: true,
          outlineBorderColor: Colors.white,
          indicatorColor: Colors.blue,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.black.withOpacity(0.2),
          onTap: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          items: [
            CrystalNavigationBarItem(
              icon: IconlyBold.home,
              unselectedIcon: IconlyLight.home,
              selectedColor: Color(0xff4b39ef),
            ),
            CrystalNavigationBarItem(
              icon: IconlyBold.scan,
              unselectedIcon: IconlyLight.scan,
              selectedColor: Color(0xff4b39ef),
            ),
            CrystalNavigationBarItem(
              icon: IconlyBold.chart,
              unselectedIcon: IconlyLight.chart,
              selectedColor: Color(0xff4b39ef),
            ),
            CrystalNavigationBarItem(
              icon: IconlyBold.profile,
              unselectedIcon: IconlyLight.user,
              selectedColor: Color(0xff4b39ef),
            ),
          ],
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          splashBorderRadius: 50,
          enablePaddingAnimation: true,
        ),
      ),
    );
  }
}
