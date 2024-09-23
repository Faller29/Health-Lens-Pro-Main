import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthlens/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to save exercise activity and update macronutrients
  Future<void> saveExerciseActivity(
      String userId, Map<String, dynamic> exercise) async {
    try {
      // Save exercise activity to user_activity collection
      final date = DateTime.now();
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final String currentTime =
          "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";

      await _firestore
          .collection('user_activity')
          .doc(userId)
          .collection(formattedDate)
          .doc(currentTime)
          .set({
        'exercise': exercise['name'],
        'calories': exercise['calories'],
        'timestamp': currentTime,
      });

      // Update user's current macronutrients
      await _updateUserMacros(userId, exercise);
    } catch (e) {
      print('Error saving exercise activity: $e');
      throw e;
    }
  }

  // Function to update macronutrients by deducting the exercise values
  Future<void> _updateUserMacros(
      String userId, Map<String, dynamic> exercise) async {
    try {
      // Get current macronutrients from Firestore
      DocumentReference macrosRef =
          _firestore.collection('userMacros').doc(userId);
      DocumentSnapshot macrosSnapshot = await macrosRef.get();

      if (macrosSnapshot.exists) {
        Map<String, dynamic> currentMacros =
            macrosSnapshot.data() as Map<String, dynamic>;

        // Deduct the exercise values from the current macros
        int updatedCalories =
            (currentMacros['calories'] ?? 0) - (exercise['calories'] ?? 0);

        // Update the macronutrients in Firestore
        await macrosRef.update({
          'calories': updatedCalories < 0
              ? 0
              : updatedCalories, // Ensure no negative values
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setInt('dailyCalories', updatedCalories);

        dailyCalories = prefs.getInt('dailyCalories') ?? 0;
      } else {
        print("User macronutrients data not found.");
      }
    } catch (e) {
      print('Error updating macronutrients: $e');
      throw e;
    }
  }
}
