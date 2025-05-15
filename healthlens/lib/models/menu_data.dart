import 'package:flutter/material.dart';

class MenuItem {
  final int id;
  final String title;
  final IconData icon;

  MenuItem({required this.id, required this.title, required this.icon});
}

// Define sidebarMenus with a list of menu items
final List<MenuItem> sidebarMenus = [
  MenuItem(id: 4, title: 'My Profile', icon: Icons.person),
  MenuItem(id: 5, title: 'Reminders', icon: Icons.remember_me),
  MenuItem(id: 6, title: 'Settings', icon: Icons.settings),
];
