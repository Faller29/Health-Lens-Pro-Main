import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'login_page.dart'; // Import the login page to navigate to

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                IconlyLight.user,
                size: 120,
                color: Colors.black,
              ),
              SizedBox(height: 20),
              Text(
                'Profile Page',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20),
              // List of clickable items
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Edit Profile'),
                onTap: () {
                  // Navigate to edit profile page
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Navigate to settings page
                },
              ),
              ListTile(
                leading: Icon(Icons.security),
                title: Text('Security'),
                onTap: () {
                  // Navigate to security page
                },
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Help & Support'),
                onTap: () {
                  // Navigate to help & support page
                },
              ),
              SizedBox(height: 20),
              // Logout button
              ElevatedButton(
                onPressed: () {
                  // Navigate to the login page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
