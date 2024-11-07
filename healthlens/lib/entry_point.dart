import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthlens/backend_firebase/modals.dart';
import 'package:iconly/iconly.dart';
import 'homePage.dart';
import 'camerapage.dart';
import 'profilePage.dart';
import 'analyticspage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/graph_data.dart';

class EntryPoint extends StatefulWidget {
  final PageController? pageController;
  final bool showTutorial;

  const EntryPoint({Key? key, this.pageController, this.showTutorial = false})
      : super(key: key);

  @override
  _EntryPointState createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  int _selectedIndex = 0;
  late UniqueKey _pageKey; // Add a key to refresh the page

  final List<String> pageTitles = [
    'Dashboard',
    'Camera',
    'Analytics',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _pageKey = UniqueKey(); // Initialize the key
    if (widget.showTutorial) {
      Future.delayed(Duration.zero, () {
        appTutorial(context); // Show the modal tutorial
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageKey = UniqueKey(); // Generate a new key when item is tapped
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xff4b39ef),
    ));
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      /* appBar: AppBar(
        elevation: 1,
        title: Text(
          pageTitles[_selectedIndex],
          style: GoogleFonts.outfit(
            fontSize: 25.0,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff4b39ef),
      ), */
      appBar: EmptyAppBar(),
      body: Center(
        // Add a Key to the widget tree to force rebuild
        child: KeyedSubtree(
          key: _pageKey,
          child: [
            const HomePage(),
            CameraPage(),
            AnalyticsPage(),
            ProfilePage(),
          ][_selectedIndex],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      margin: const EdgeInsets.only(bottom: 20, left: 50, right: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.asMap().entries.map((entry) {
          int index = entry.key;
          CustomNavigationBarItem item = entry.value;
          bool isSelected = index == currentIndex;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor:
                  Colors.white.withOpacity(0.5), // More visible splash color
              borderRadius: BorderRadius.circular(50),
              onTap: () => onTap(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    color: isSelected
                        ? const Color(0xff4b39ef)
                        : const Color.fromARGB(255, 255, 255, 255),
                  ),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xff4b39ef)
                          : const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}
