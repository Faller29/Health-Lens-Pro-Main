import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'homePage.dart';
import 'camerapage.dart';
import 'profilePage.dart';
import 'analyticspage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/graph_data.dart';

class EntryPoint extends StatefulWidget {
  final PageController? pageController;

  const EntryPoint({Key? key, this.pageController}) : super(key: key);

  @override
  _EntryPointState createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  int _selectedIndex = 0;

  final List<String> pageTitles = [
    'Dashboard',
    'Camera',
    'Analytics',
    'Profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 1,
        title: Text(
          pageTitles[_selectedIndex],
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
        ][_selectedIndex],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          CustomNavigationBarItem(
            icon: IconlyBold.home,
            label: 'Home',
          ),
          CustomNavigationBarItem(
            icon: IconlyBold.camera,
            label: 'Camera',
          ),
          CustomNavigationBarItem(
            icon: IconlyBold.graph,
            label: 'Analytics',
          ),
          CustomNavigationBarItem(
            icon: IconlyBold.profile,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<CustomNavigationBarItem> items;

  CustomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      margin: EdgeInsets.only(bottom: 20, left: 50, right: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.asMap().entries.map((entry) {
          int index = entry.key;
          CustomNavigationBarItem item = entry.value;
          bool isSelected = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icon,
                  color: isSelected
                      ? Color(0xff4b39ef)
                      : Color.fromARGB(255, 255, 255, 255),
                ),
                Text(
                  item.label,
                  style: TextStyle(
                      color: isSelected
                          ? Color(0xff4b39ef)
                          : Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CustomNavigationBarItem {
  final IconData icon;
  final String label;

  CustomNavigationBarItem({
    required this.icon,
    required this.label,
  });
}
