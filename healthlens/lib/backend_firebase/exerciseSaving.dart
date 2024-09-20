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

      await _firestore
          .collection('user_activity')
          .doc(userId)
          .collection(formattedDate)
          .add({
        'exercise': exercise['name'],
        'calories': exercise['calories'],
        'macronutrients': exercise['macronutrients'],
        'timestamp': FieldValue.serverTimestamp(),
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
        int updatedCarbs = (currentMacros['carbs'] ?? 0) -
            (exercise['macronutrients']['carbs'] ?? 0);
        int updatedFats = (currentMacros['fats'] ?? 0) -
            (exercise['macronutrients']['fats'] ?? 0);
        int updatedProteins = (currentMacros['proteins'] ?? 0) -
            (exercise['macronutrients']['proteins'] ?? 0);

        // Update the macronutrients in Firestore
        await macrosRef.update({
          'calories': updatedCalories < 0
              ? 0
              : updatedCalories, // Ensure no negative values
          'carbs': updatedCarbs < 0 ? 0 : updatedCarbs,
          'fats': updatedFats < 0 ? 0 : updatedFats,
          'proteins': updatedProteins < 0 ? 0 : updatedProteins,
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setInt('dailyCarbs', updatedCarbs);
        await prefs.setInt('dailyProtein', updatedProteins);
        await prefs.setInt('dailyFats', updatedFats);
        await prefs.setInt('dailyCalories', updatedCalories);

        dailyCarbs = prefs.getInt('dailyCarbs') ?? 0;
        dailyProtein = prefs.getInt('dailyProtein') ?? 0;
        dailyFats = prefs.getInt('dailyFats') ?? 0;
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
