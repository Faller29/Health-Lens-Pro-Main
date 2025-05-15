import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirestoreProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _username = '';

  String get username => _username;

  Future<void> getUsername() async {
    try {
      final currentUserInfo = await _firestore
          .collection("user")
          .doc('l4eONpueCoSlfLiUDjr0Y6meYBg2')
          .get();
      if (currentUserInfo.exists) {
        final data = currentUserInfo.data() as Map<String, dynamic>;
        _username = data['name'];
        notifyListeners(); // Notify listeners about the change
      }
    } catch (e) {
      print("Error getting username: $e");
    }
  }

  // Optionally, consider a method to trigger username fetching
  Future<void> fetchUsername() async {
    await getUsername();
  }
}
