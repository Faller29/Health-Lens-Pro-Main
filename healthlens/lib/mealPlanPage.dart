import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthlens/backend_firebase/foodExchange.dart';
import 'package:healthlens/main.dart';

class MealPlanPage extends StatefulWidget {
  @override
  _MealPlanPageState createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  Map<String, dynamic> maxNutrients = {
    'carbs': 375,
    'fats': 70,
    'proteins': 95,
  };
  Map<String, dynamic> currentNutrients = {
    'carbs': 0,
    'fats': 0,
    'proteins': 0,
  };
  List<int> chronicIndexList = [];
  String? chronicDisease = 'Obesity'; // Example condition for filtering

  @override
  void initState() {
    super.initState();
    fetchUserData();
    setWarningFlags();
  }

  Future<void> fetchUserData() async {
    String userId = thisUser!.uid; // Replace with actual user ID
    DocumentSnapshot maxNutrientsSnapshot =
        await FirebaseFirestore.instance.collection('user').doc(userId).get();
    DocumentSnapshot currentNutrientsSnapshot = await FirebaseFirestore.instance
        .collection('userMacros')
        .doc(userId)
        .get();

    setState(() {
      maxNutrients = {
        'carbs': maxNutrientsSnapshot['gramCarbs'],
        'fats': maxNutrientsSnapshot['gramFats'],
        'proteins': maxNutrientsSnapshot['gramProtein'],
      };
      currentNutrients = {
        'carbs': currentNutrientsSnapshot['carbs'],
        'fats': currentNutrientsSnapshot['fats'],
        'proteins': currentNutrientsSnapshot['proteins'],
      };
    });
  }

  void setWarningFlags() {
    if (chronicDisease!.contains('Obesity')) {
      chronicIndexList.add(1);
    } else if (chronicDisease!.contains('Hypertension')) {
      chronicIndexList.add(2);
    } else if (chronicDisease!.contains('Diabetes [Type 1 & 2]')) {
      chronicIndexList.add(3);
    } else {
      chronicIndexList.add(4);
    }
  }

  Map<String, int> calculateRemainingNutrients(
      Map<String, int> currentNutrients) {
    return {
      'carbs': maxNutrients['carbs'] - currentNutrients['carbs']!,
      'fats': maxNutrients['fats'] - currentNutrients['fats']!,
      'proteins': maxNutrients['proteins'] - currentNutrients['proteins']!,
    };
  }

  bool canAddMeal(Map<String, int> meal, Map<String, int> remaining) {
    return meal['carbs']! <= remaining['carbs']! &&
        meal['fats']! <= remaining['fats']! &&
        meal['proteins']! <= remaining['proteins']!;
  }

  bool containsWarning(Map<String, String> meal) {
    int warning = int.tryParse(meal['warning'] ?? '0') ?? 0;
    return chronicIndexList.contains(warning);
  }

  List<List<Map<String, String>>> generateMealPlans() {
    final List<List<Map<String, String>>> mealPlans = [];
    List<Map<String, String>> currentMealPlan = [];
    Map<String, int> remainingNutrients = Map.from(maxNutrients);
    Set<String> addedMeals = {}; // Track added meal names
    Set<String> currentMealTypes = {}; // Track meal types in the current plan

    for (String mealType in itemMacronutrients.keys) {
      for (String part in itemMacronutrients[mealType]!.keys) {
        Map<String, int> nutrients = itemMacronutrients[mealType]![part]!;

        // Create a temporary map to store the meal data
        String mealName = mealType; // Use the meal name for uniqueness
        Map<String, String> meal = {
          'meal': mealType,
          'part': part,
          'carbs': nutrients['carbs'].toString(),
          'fats': nutrients['fats'].toString(),
          'proteins': nutrients['proteins'].toString(),
          'warning': nutrients['warnings'].toString(),
          'mealIndex':
              nutrients['meal'].toString(), // Add meal index for categorization
        };

        // Exclude foods based on warnings or if already added
        if (containsWarning(meal) || currentMealTypes.contains(mealName)) {
          continue; // Skip this meal if it contains warnings or is already added
        }

        // Generate combinations and check against macronutrients
        if (canAddMeal(nutrients, remainingNutrients)) {
          currentMealPlan.add(meal);
          currentMealTypes
              .add(mealName); // Track added meal by name in current plan

          // Update remaining nutrients
          remainingNutrients['carbs'] =
              (remainingNutrients['carbs'] ?? 0) - (nutrients['carbs'] ?? 0);
          remainingNutrients['fats'] =
              (remainingNutrients['fats'] ?? 0) - (nutrients['fats'] ?? 0);
          remainingNutrients['proteins'] =
              (remainingNutrients['proteins'] ?? 0) -
                  (nutrients['proteins'] ?? 0);
        } else {
          // Finalize the current meal plan if a food exceeds the remaining nutrients
          mealPlans.add(currentMealPlan);
          currentMealPlan = [];
          currentMealTypes.clear(); // Reset for the next meal plan
          remainingNutrients = Map.from(maxNutrients);

          // Start a new meal plan with the current meal
          currentMealPlan.add(meal);
          currentMealTypes.add(mealName); // Track added meal by name
          remainingNutrients['carbs'] =
              (remainingNutrients['carbs'] ?? 0) - (nutrients['carbs'] ?? 0);
          remainingNutrients['fats'] =
              (remainingNutrients['fats'] ?? 0) - (nutrients['fats'] ?? 0);
          remainingNutrients['proteins'] =
              (remainingNutrients['proteins'] ?? 0) -
                  (nutrients['proteins'] ?? 0);
        }
      }
    }

    // Add the last meal plan if it has any meals
    if (currentMealPlan.isNotEmpty) {
      mealPlans.add(currentMealPlan);
    }

    return mealPlans;
  }

  @override
  Widget build(BuildContext context) {
    List<List<Map<String, String>>> mealPlans = generateMealPlans();

    return Scaffold(
      appBar: AppBar(title: Text('Meal Plan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recommended Meal Plans:', style: TextStyle(fontSize: 20)),
            Expanded(
              child: ListView.builder(
                itemCount: mealPlans.length,
                itemBuilder: (context, index) {
                  List<Map<String, String>> mealPlan = mealPlans[index];
                  return ExpansionTile(
                    title: Text('Meal Plan ${index + 1}'),
                    children: mealPlan.map((meal) {
                      return ListTile(
                        title: Text('${meal['meal']} - ${meal['part']}'),
                        subtitle: Text(
                          'Carbs: ${meal['carbs']}g, Fats: ${meal['fats']}g, Proteins: ${meal['proteins']}g',
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
