import 'package:firebase_auth/firebase_auth.dart';

class AccountService {
  Stream<User?> get currentUser {
    return FirebaseAuth.instance.authStateChanges();
  }

  String get currentUserId {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  bool hasUser() {
    return FirebaseAuth.instance.currentUser != null;
  }
}