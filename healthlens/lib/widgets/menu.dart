import 'package:flutter/material.dart';

class Menu {
  final int id;
  final String title;
  final IconData icon;
  final int pageIndex;

  Menu({
    required this.id,
    required this.title,
    required this.icon,
    required this.pageIndex,
  });
}
