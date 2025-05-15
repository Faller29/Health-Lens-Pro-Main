import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/backend_firebase/foodExchange.dart';
import 'package:healthlens/main.dart';
import 'package:iconly/iconly.dart';

class MealPlanPage extends StatefulWidget {
  @override
  _MealPlanPageState createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  late Future<List<Map<String, dynamic>>> futureMealPlans;
  List<Map<String, dynamic>> mealPlansList = [];
  //double globalCarbs = 0, globalFats = 0, globalProteins = 0;
  int globalCarbs = 0, globalFats = 0, globalProteins = 0;

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

  @override
  void initState() {
    super.initState();
    fetchUserData();
    setWarningFlags();
    //futureMealPlans = fetchMealPlans();
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
    print(chronicDisease);
  }

  Future<Map<String, Map<String, dynamic>>> generateMealPlans() async {
    print('start Generating');
    // Step 1: Identify all vegetables, fruits, milk, and sugar
    List<Map<String, dynamic>> selectedVegetables = [];
    List<Map<String, dynamic>> selectedFruits = [];
    List<Map<String, dynamic>> selectedMilk = [];
    List<Map<String, dynamic>> selectedSugar = [];

    // Helper function to get foods that fill the required number of exchanges
    List<Map<String, dynamic>> getFoodsToFillExchanges(
        int type, int targetExchanges) {
      List<Map<String, dynamic>> availableFoods = [];

      // Filter out foods by type
      itemMacronutrients.forEach((foodName, measures) {
        measures.forEach((measure, data) {
          /* if ((data['warnings'] == null ||  data['warnings'] == chronicIndexList.first)) {
            print('exclude this food $foodName');
          } else {
            print("include: $foodName");
          }
          print(
              "chronic: ${(/* data['warnings'] ==  */ chronicIndexList.first)}");
 */
          print(
              "chronic: ${(/* data['warnings'] ==  */ chronicIndexList.first)}");
          if (data['type'] == type &&
              data['warnings'] != chronicIndexList.first) {
            availableFoods.add({
              'foodName': foodName,
              'householdMeasure': measure,
              'fats': data['fats'],
              'carbs': data['carbs'],
              'proteins': data['proteins'],
              'foodExchange': (data['foodExchange'] as num).toDouble(),
            });
            /* print(
                "this fod: $foodName has fats: ${data['fats']}, carbs: ${data['carbs']}, poteins: ${data['poteins']}"); */
          }
        });
      });

      List<Map<String, dynamic>> selectedFoods = [];
      double totalExchanges = 0.0;

      // Select foods until the total exchanges match the target
      while (totalExchanges < targetExchanges && availableFoods.isNotEmpty) {
        int index = Random().nextInt(availableFoods.length);
        var selectedFood = availableFoods[index];

        double foodExchange = selectedFood['foodExchange'];
        if (totalExchanges + foodExchange <= targetExchanges) {
          selectedFoods.add(selectedFood);
          totalExchanges += foodExchange;
        }

        // Remove selected food to avoid duplicates
        availableFoods.removeAt(index);
      }
      print("selected Foods from function: $selectedFoods");
      return selectedFoods;
    }

    // Step 2-5: Get food exchanges for vegetables, fruits, milk, and sugar
    selectedVegetables =
        getFoodsToFillExchanges(1, Random().nextInt(3) + 3); // 3-5 exchanges
    selectedFruits =
        getFoodsToFillExchanges(5, Random().nextInt(3) + 3); // 3-5 exchanges
    selectedMilk = getFoodsToFillExchanges(3, 1); // 1 exchange
    selectedSugar =
        getFoodsToFillExchanges(4, Random().nextInt(4) + 3); // 3-6 exchanges

    // Calculate total macronutrients for the selected foods
    double totalCarbs = 0.0;
    double totalProteins = 0.0;
    double totalFats = 0.0;

    for (var food in selectedVegetables) {
      totalCarbs += food['carbs'];
      totalProteins += food['proteins'];
      totalFats += food['fats'];
    }

    for (var food in selectedFruits) {
      totalCarbs += food['carbs'];
      totalProteins += food['proteins'];
      totalFats += food['fats'];
    }

    for (var food in selectedMilk) {
      totalCarbs += food['carbs'];
      totalProteins += food['proteins'];
      totalFats += food['fats'];
    }
    for (var food in selectedSugar) {
      totalCarbs += food['carbs'];
      totalProteins += food['proteins'];
      totalFats += food['fats'];
    }

    // Function to check if the total macronutrients are close to the user's max
    bool isWithinTarget(double total, double max) {
      return total >= max * 0.9 && total <= max * 1.1;
    }

    // Step 6-8: Declare variables for rice, meat, and fat
    List<Map<String, dynamic>> selectedRice = [];
    List<Map<String, dynamic>> selectedMeat = [];
    List<Map<String, dynamic>> selectedFat = [];

// Step 6-8: Add rice, meat, and fat until macronutrients are within 10% of the user's max
    int iterationLimit = 10; // Add a limit to prevent infinite loop
    int iterations = 0;
    Map<String, Map<String, dynamic>> mealPlan = {
      'Breakfast': {},
      'Morning Snack': {},
      'Lunch': {},
      'Afternoon Snack': {},
      'Dinner': {},
    };

    while (!(isWithinTarget(
                totalCarbs, double.parse(maxNutrients['carbs'].toString())) &&
            isWithinTarget(totalProteins,
                double.parse(maxNutrients['proteins'].toString())) &&
            isWithinTarget(
                totalFats, double.parse(maxNutrients['fats'].toString()))) &&
        iterations < iterationLimit) {
      print('Executing while loop');
      iterations++;
      /* print('Iteration: $iterations');
      print(
          'Current macros: Carbs=$totalCarbs, Proteins=$totalProteins, Fats=$totalFats');
 */
      // ** Carbs filling **
      if (!isWithinTarget(
          totalCarbs, double.parse(maxNutrients['carbs'].toString()))) {
        double remainingCarbs =
            double.parse(maxNutrients['carbs'].toString()) - totalCarbs;
        int riceExchanges =
            (remainingCarbs / 23).round(); // 23g carbs per exchange

        List<Map<String, dynamic>> selectedRice1 = getFoodsToFillExchanges(
            6, riceExchanges); // Correct food type for rice (type 4)
        print('Selected Rice: $selectedRice1');

        if (selectedRice1.isNotEmpty) {
          for (var food in selectedRice1) {
            //addFoodToMeal(mealPlan['Dinner']!, selectedRice, 1);
            totalCarbs += food['carbs'];
            totalProteins += food['proteins'];
            totalFats += food['fats'];
            /* print("Added rice food: $food");
            print(
                'Updated Carbs=$totalCarbs, Proteins=$totalProteins, Fats=$totalFats'); */
          }
          distributeRice(
              mealPlan, selectedRice1, double.parse(riceExchanges.toString()));
        } else {
          print("No rice food selected, breaking the loop.");
          break; // If no foods are added, break the loop
        }
        print("total carbs in rice: $totalCarbs");
        selectedRice1.clear();
      }

      // ** Proteins filling **
      if (!isWithinTarget(
          totalProteins, double.parse(maxNutrients['proteins'].toString()))) {
        double remainingProteins =
            double.parse(maxNutrients['proteins'].toString()) - totalProteins;
        int meatExchanges = (remainingProteins ~/ 8)
            .toInt(); // 8g protein per exchange, papalitan to pag goods na data
        print(meatExchanges);
        List<Map<String, dynamic>> selectedMeat1 =
            getFoodsToFillExchanges(2, meatExchanges); // mama mo
        print('Selected Meat: $selectedMeat1');

        if (selectedMeat1.isNotEmpty) {
          for (var food in selectedMeat1) {
            totalCarbs += food['carbs'];
            totalProteins += food['proteins'];
            totalFats += food['fats'];
            /* print("Added meat food: $food");
            print(
                'Updated Carbs=$totalCarbs, Proteins=$totalProteins, Fats=$totalFats'); */
          }
          distributeMeat(
              mealPlan, selectedMeat1, double.parse(meatExchanges.toString()));
          print("clearing meat: $selectedMeat1");
        } else {
          print("No meat food selected, breaking the loop.");
          break; // If no foods are selected, exit the loop
        }
        selectedMeat1.clear();
      }

      // ** Fats filling **
      if (!isWithinTarget(
          totalFats, double.parse(maxNutrients['fats'].toString()))) {
        double remainingFats =
            double.parse(maxNutrients['fats'].toString()) - totalFats;
        int fatExchanges = (remainingFats ~/ 5).toInt(); // 5g fats per exchange

        List<Map<String, dynamic>> selectedFat1 = getFoodsToFillExchanges(
            7, fatExchanges); // Correct food type for fat (type 6)
        print('Selected Fats: $selectedFat1');

        if (selectedFat1.isNotEmpty) {
          for (var food in selectedFat1) {
            //addFoodToMeal(mealPlan['Dinner']!, selectedFat, 1);
            totalCarbs += food['carbs'];
            totalProteins += food['proteins'];
            totalFats += food['fats'];
            /* print("Added fat food: $food");
            print(
                'Updated Carbs=$totalCarbs, Proteins=$totalProteins, Fats=$totalFats'); */
          }
          distributeFat(
              mealPlan, selectedFat1, double.parse(fatExchanges.toString()));
        } else {
          print("No fat food selected, breaking the loop.");
          break; // If no foods are selected, exit the loop
        }
        selectedFat1.clear();
      }
    }

    // Step 18: Distribute selected foods into the meal plan structure

    // Distribute food based on the distribution rules provided
    distributeFood(mealPlan, 'vegetables', selectedVegetables);
    distributeFood(mealPlan, 'fruits', selectedFruits);

    // Milk is only for Breakfast
    if (selectedMilk.isNotEmpty) {
      var milk = selectedMilk.first;

      // Update or merge each field in 'Breakfast' individually
      mealPlan['Breakfast']?['foodName'] =
          mealPlan['Breakfast']?['foodName'] == null
              ? milk['foodName']
              : "${mealPlan['Breakfast']?['foodName']}, ${milk['foodName']}";

      mealPlan['Breakfast']?['householdMeasure'] = mealPlan['Breakfast']
                  ?['householdMeasure'] ==
              null
          ? milk['householdMeasure']
          : "${mealPlan['Breakfast']?['householdMeasure']}, ${milk['householdMeasure']}";

      mealPlan['Breakfast']?['fats'] =
          (mealPlan['Breakfast']?['fats'] ?? 0) + (milk['fats'] ?? 0);
      mealPlan['Breakfast']?['carbs'] =
          (mealPlan['Breakfast']?['carbs'] ?? 0) + (milk['carbs'] ?? 0);
      mealPlan['Breakfast']?['proteins'] =
          (mealPlan['Breakfast']?['proteins'] ?? 0) + (milk['proteins'] ?? 0);
      mealPlan['Breakfast']?['foodExchange'] =
          (mealPlan['Breakfast']?['foodExchange'] ?? 0) +
              (milk['foodExchange'] ?? 0);
    }

    /* 
    print("selected1 Rice: $selectedRice");
    print("selected1 meat: $selectedMeat");
    print("selected1 fat: $selectedFat");
 */
    distributeFood(mealPlan, 'sugar', selectedSugar);

    /* 
    distributeFood(mealPlan, 'rice', selectedRice);
    distributeFood(mealPlan, 'meat', selectedMeat);
    distributeFood(mealPlan, 'fat', selectedFat);
 */
    print('Total Macronutrients in the Meal Plan:');
    print('Total Carbs: $totalCarbs g');
    print('Total Proteins: $totalProteins g');
    print('Total Fats: $totalFats g');
    print(mealPlan.length);
    print('Stop Generating');
    print('mealplan generated: $mealPlan');
/* 
    globalCarbs = totalCarbs;
    globalFats = totalFats;
    globalProteins = totalProteins; */
    return mealPlan;
  }

// Helper function to distribute food across meals
  void distributeFood(Map<String, Map<String, dynamic>> mealPlan,
      String foodType, List<Map<String, dynamic>> selectedFoods) {
    initializeMealPlan(mealPlan);

    double totalExchanges =
        selectedFoods.fold(0.0, (sum, food) => sum + (food['foodExchange']));

    switch (foodType) {
      case 'vegetables':
        distributeVegetables(mealPlan, selectedFoods, totalExchanges);
        break;
      case 'fruits':
        distributeFruits(mealPlan, selectedFoods, totalExchanges);
        break;
      case 'sugar':
        distributeSugar(mealPlan, selectedFoods, totalExchanges);
        break;
      case 'rice':
        distributeRice(mealPlan, selectedFoods, totalExchanges);
        break;
      case 'meat':
        distributeMeat(mealPlan, selectedFoods, totalExchanges);
        break;
      case 'fat':
        distributeFat(mealPlan, selectedFoods, totalExchanges);
        break;
    }
  }

  void initializeMealPlan(Map<String, Map<String, dynamic>> mealPlan) {
    mealPlan['Breakfast'] ??= {};
    mealPlan['Morning Snack'] ??= {};
    mealPlan['Lunch'] ??= {};
    mealPlan['Afternoon Snack'] ??= {};
    mealPlan['Dinner'] ??= {};
  }

  void distributeVegetables(Map<String, Map<String, dynamic>> mealPlan,
      List<Map<String, dynamic>> selectedFoods, double totalExchanges) {
    int iterate = 0;
    if (totalExchanges == 3) {
      for (int i = 0; i < totalExchanges; i++) {
        List<String> mealsType = ['Breakfast', 'Lunch', 'Dinner'];

        // Ensure we cycle through the selectedFoods by using the iterate index
        addFoodToMeal(
          mealPlan[mealsType[i]]!,
          [selectedFoods[iterate]],
          selectedFoods[iterate]['foodExchange'],
        );
        iterate++;
      }

      /* addFoodToMeal(mealPlan['Breakfast']!, selectedFoods, 1);
      addFoodToMeal(mealPlan['Lunch']!, selectedFoods, 0.5);
      addFoodToMeal(mealPlan['Dinner']!, selectedFoods, 1.5); */
    } else if (totalExchanges == 4) {
      for (int i = 0; i < totalExchanges; i++) {
        List<String> mealsType = ['Breakfast', 'Lunch', 'Dinner', 'Dinner'];

        // Ensure we cycle through the selectedFoods by using the iterate index
        addFoodToMeal(
          mealPlan[mealsType[i]]!,
          [selectedFoods[iterate]],
          selectedFoods[iterate]['foodExchange'],
        );
        iterate++;
      }

      /* addFoodToMeal(mealPlan['Breakfast']!, selectedFoods, 1);
      addFoodToMeal(mealPlan['Lunch']!, selectedFoods, 1);
      addFoodToMeal(mealPlan['Dinner']!, selectedFoods, 2); */
    } else if (totalExchanges == 5) {
      for (int i = 0; i < totalExchanges; i++) {
        List<String> mealsType = [
          'Breakfast',
          'Lunch',
          'Lunch',
          'Dinner',
          'Dinner'
        ];

        // Ensure we cycle through the selectedFoods by using the iterate index
        addFoodToMeal(
          mealPlan[mealsType[i]]!,
          [selectedFoods[iterate]],
          selectedFoods[iterate]['foodExchange'],
        );
        iterate++;
      }

      /*  addFoodToMeal(mealPlan['Breakfast']!, selectedFoods, 1);
      addFoodToMeal(mealPlan['Lunch']!, selectedFoods, 2);
      addFoodToMeal(mealPlan['Dinner']!, selectedFoods, 2); */
    }
  }

  void distributeFruits(Map<String, Map<String, dynamic>> mealPlan,
      List<Map<String, dynamic>> selectedFoods, double totalExchanges) {
    int iterate = 0;
    if (totalExchanges == 3) {
      for (int i = 0; i < totalExchanges; i++) {
        List<String> mealsType = [
          'Breakfast',
          'Morning Snack',
          'Afternoon Snack',
        ];

        // Ensure we cycle through the selectedFoods by using the iterate index
        addFoodToMeal(
          mealPlan[mealsType[i]]!,
          [selectedFoods[iterate]],
          selectedFoods[iterate]['foodExchange'],
        );
        iterate++;
      }

      /* addFoodToMeal(mealPlan['Breakfast']!, selectedFoods, 1);
      addFoodToMeal(mealPlan['Afternoon Snack']!, selectedFoods, 1);
      addFoodToMeal(mealPlan['Dinner']!, selectedFoods, 1); */
    } else if (totalExchanges == 4) {
      for (int i = 0; i < totalExchanges; i++) {
        List<String> mealsType = [
          'Breakfast',
          'Morning Snack',
          'Lunch',
          'Dinner'
        ];

        // Ensure we cycle through the selectedFoods by using the iterate index
        addFoodToMeal(
          mealPlan[mealsType[i]]!,
          [selectedFoods[iterate]],
          selectedFoods[iterate]['foodExchange'],
        );
        iterate++;
      }

      /* addFoodToMeal(mealPlan['Breakfast']!, selectedFoods, 1);
      addFoodToMeal(
          mealPlan['Morning Snack']!, selectedFoods, 1); // Added Morning Snack
      addFoodToMeal(mealPlan['Lunch']!, selectedFoods, 1);
      addFoodToMeal(mealPlan['Dinner']!, selectedFoods, 1); */
    } else if (totalExchanges == 5) {
      for (int i = 0; i < totalExchanges; i++) {
        List<String> mealsType = [
          'Breakfast',
          'Morning Snack',
          'Lunch',
          'Afternoon Snack',
          'Dinner',
          'Dinner'
        ];

        // Ensure we cycle through the selectedFoods by using the iterate index
        addFoodToMeal(
          mealPlan[mealsType[i]]!,
          [selectedFoods[iterate]],
          selectedFoods[iterate]['foodExchange'],
        );
        iterate++;
      }

      /* addFoodToMeal(mealPlan['Breakfast']!, selectedFoods, 1);
      addFoodToMeal(
          mealPlan['Morning Snack']!, selectedFoods, 1); // Added Morning Snack
      addFoodToMeal(mealPlan['Lunch']!, selectedFoods, 1);

      addFoodToMeal(mealPlan['Afternoon Snack']!, selectedFoods, 1);

      addFoodToMeal(mealPlan['Dinner']!, selectedFoods, 2); */
    }
  }

  void distributeSugar(Map<String, Map<String, dynamic>> mealPlan,
      List<Map<String, dynamic>> selectedFoods, double totalExchanges) {
    print("sugars exchange: $totalExchanges");
    int iterate = 0;

    if (totalExchanges == 3) {
      List<String> mealsType = [
        'Breakfast',
        'Afternoon Snack',
        'Afternoon Snack'
      ];

      for (int i = 0; i < totalExchanges; i++) {
        // Ensure we cycle through the selectedFoods by using the iterate index
        addFoodToMeal(
          mealPlan[mealsType[i]]!,
          [selectedFoods[iterate]],
          selectedFoods[iterate]['foodExchange'],
        );
        iterate++;
      }

      /* addFoodToMeal(mealPlan['Breakfast']!, [selectedFoods[iterate]],
          selectedFoods[iterate]['foodExchange']);
      iterate++;
      addFoodToMeal(mealPlan['Afternoon Snack']!, [selectedFoods[iterate]],
          selectedFoods[iterate]['foodExchange']);
      iterate++;
      addFoodToMeal(mealPlan['Afternoon Snack']!, [selectedFoods[iterate]],
          selectedFoods[iterate]['foodExchange']);
      iterate++; */
    } else if (totalExchanges == 4) {
      for (int i = 0; i < totalExchanges; i++) {
        List<String> mealsType = [
          'Breakfast',
          'Morning Snack',
          'Afternoon Snack',
          'Afternoon Snack'
        ];

        // Ensure we cycle through the selectedFoods by using the iterate index
        addFoodToMeal(
          mealPlan[mealsType[i]]!,
          [selectedFoods[iterate]],
          selectedFoods[iterate]['foodExchange'],
        );
        iterate++;
      }

      /* addFoodToMeal(mealPlan['Breakfast']!, selectedFoods, 1);
      addFoodToMeal(mealPlan['Morning Snack']!, selectedFoods, 1); // Added Morning Snack
      addFoodToMeal(mealPlan['Afternoon Snack']!, selectedFoods, 2); */
    } else if (totalExchanges == 5) {
      for (int i = 0; i < totalExchanges; i++) {
        List<String> mealsType = [
          'Breakfast',
          'Morning Snack',
          'Morning Snack',
          'Afternoon Snack',
          'Afternoon Snack'
        ];

        // Ensure we cycle through the selectedFoods by using the iterate index
        addFoodToMeal(
          mealPlan[mealsType[i]]!,
          [selectedFoods[iterate]],
          selectedFoods[iterate]['foodExchange'],
        );
        iterate++;
      }

      /* addFoodToMeal(mealPlan['Breakfast']!, selectedFoods, 1);
      addFoodToMeal(
          mealPlan['Morning Snack']!, selectedFoods, 2); // Added Morning Snack
      addFoodToMeal(mealPlan['Afternoon Snack']!, selectedFoods, 2); */
    } else if (totalExchanges == 6) {
      for (int i = 0; i < totalExchanges; i++) {
        List<String> mealsType = [
          'Breakfast',
          'Morning Snack',
          'Morning Snack',
          'Afternoon Snack',
          'Afternoon Snack',
          'Dinner'
        ];

        // Ensure we cycle through the selectedFoods by using the iterate index
        addFoodToMeal(
          mealPlan[mealsType[i]]!,
          [selectedFoods[iterate]],
          selectedFoods[iterate]['foodExchange'],
        );
        iterate++;
      }

      /* addFoodToMeal(mealPlan['Breakfast']!, selectedFoods, 1);
      addFoodToMeal(
          mealPlan['Morning Snack']!, selectedFoods, 2); // Added Morning Snack
      addFoodToMeal(mealPlan['Afternoon Snack']!, selectedFoods, 2);
      addFoodToMeal(mealPlan['Dinner']!, selectedFoods, 2); */
    }
  }

// Distribute rice according to the specified method
  void distributeRice(Map<String, Map<String, dynamic>> mealPlan,
      List<Map<String, dynamic>> selectedFoods, double totalExchanges) {
    print("rice ex: $totalExchanges");
    print(selectedFoods);
    int iterate = 0;
    while (totalExchanges > 0) {
      print("rices food: ${selectedFoods[iterate]['foodName']}");

      if (totalExchanges > 0) {
        if ((selectedFoods[iterate]['foodName']) != 'Bread') {
          print("riceExchange: ${selectedFoods[iterate]['foodExchange']}");

          addFoodToMeal(mealPlan['Dinner']!, [selectedFoods[iterate]],
              selectedFoods[iterate]['foodExchange']);
          totalExchanges -= selectedFoods[iterate]['foodExchange'];
          iterate++;
          print("rice ex: $totalExchanges");
        }
      }
      if (totalExchanges > 0) {
        print("riceExchange: ${selectedFoods[iterate]['foodExchange']}");

        /* if (totalExchanges >= 2) {
          addFoodToMeal(mealPlan['Lunch']!, selectedFoods, 2);
          totalExchanges - 2;
        } else {
          addFoodToMeal(mealPlan['Lunch']!, selectedFoods, 1);
          totalExchanges--;
        } */

        if ((selectedFoods[iterate]['foodName']) != 'Bread') {
          addFoodToMeal(mealPlan['Lunch']!, [selectedFoods[iterate]],
              selectedFoods[iterate]['foodExchange']);
          totalExchanges -= selectedFoods[iterate]['foodExchange'];
          iterate++;
          print("rice ex: $totalExchanges");
        }
      }
      if (totalExchanges > 0) {
        //if ((selectedFoods[iterate]['foodName']) == 'Bread') {
        print('executing');
        addFoodToMeal(mealPlan['Breakfast']!, [selectedFoods[iterate]],
            selectedFoods[iterate]['foodExchange']);
        totalExchanges -= selectedFoods[iterate]['foodExchange'];
        iterate++;
        print("rice ex: $totalExchanges");
        //}
      }
    }
  }

// Distribute meat according to the specified method
  void distributeMeat(Map<String, Map<String, dynamic>> mealPlan,
      List<Map<String, dynamic>> selectedFoods, double totalExchanges) {
    print("meat ex: $totalExchanges");
    int iterate = 0;

    while (totalExchanges > 0) {
      if (totalExchanges > 0) {
        print("meatExchange: ${selectedFoods[iterate]['foodExchange']}");

        addFoodToMeal(mealPlan['Lunch']!, [selectedFoods[iterate]],
            selectedFoods[iterate]['foodExchange']);
        totalExchanges -= selectedFoods[iterate]['foodExchange'];
        print(
            "meat TotalExchange reduced: ${totalExchanges - selectedFoods[iterate]['foodExchange']}");

        iterate++;
      }
      if (totalExchanges > 0) {
        print("meatExchange: ${selectedFoods[iterate]['foodExchange']}");

        addFoodToMeal(mealPlan['Lunch']!, [selectedFoods[iterate]],
            selectedFoods[iterate]['foodExchange']);
        totalExchanges -= selectedFoods[iterate]['foodExchange'];
        print(
            "meat TotalExchange reduced: ${totalExchanges - selectedFoods[iterate]['foodExchange']}");

        iterate++;
      }
      if (totalExchanges > 0) {
        print("meatExchange: ${selectedFoods[iterate]['foodExchange']}");

        addFoodToMeal(mealPlan['Breakfast']!, [selectedFoods[iterate]],
            selectedFoods[iterate]['foodExchange']);
        totalExchanges -= selectedFoods[iterate]['foodExchange'];
        print(
            "meat TotalExchange reduced: ${totalExchanges - selectedFoods[iterate]['foodExchange']}");

        iterate++;
      }
    }
  }

// Distribute fat according to the specified method
  void distributeFat(Map<String, Map<String, dynamic>> mealPlan,
      List<Map<String, dynamic>> selectedFoods, double totalExchanges) {
    print("fat ex: $totalExchanges");

    while (totalExchanges > 0) {
      if (totalExchanges > 0) {
        addFoodToMeal(mealPlan['Dinner']!, selectedFoods, 1);
        totalExchanges--;
      }
      if (totalExchanges > 0) {
        addFoodToMeal(mealPlan['Lunch']!, selectedFoods, 1);
        totalExchanges--;
      }
      if (totalExchanges > 0) {
        addFoodToMeal(mealPlan['Breakfast']!, selectedFoods, 1);
        totalExchanges--;
      }
    }
  }

  void addFoodToMeal(Map<String, dynamic> meal,
      List<Map<String, dynamic>> selectedFoods, double exchanges) {
    for (var food in selectedFoods) {
      // Check if the food's exchange value is less than or equal to the exchanges allowed
      if (food['foodExchange'] <= exchanges) {
        meal['foodName'] = meal['foodName'] == null
            ? food['foodName']
            : "${meal['foodName']}, ${food['foodName']}";
        meal['householdMeasure'] = meal['householdMeasure'] == null
            ? food['householdMeasure']
            : "${meal['householdMeasure']}, ${food['householdMeasure']}";
        meal['fats'] = (meal['fats'] ?? 0) + food['fats'];
        meal['carbs'] = (meal['carbs'] ?? 0) + food['carbs'];
        meal['proteins'] = (meal['proteins'] ?? 0) + food['proteins'];
        meal['foodExchange'] =
            (meal['foodExchange'] ?? 0) + food['foodExchange'];
        exchanges -=
            food['foodExchange']; // Deduct the added food's exchange value
      }

      // Exit the loop if no more exchanges are left
      if (exchanges <= 0) break;
    }
  }

  Future<void> saveMealsToFirestore(
      BuildContext context, List<Map<String, dynamic>> mealPlan) async {
    final firestore = FirebaseFirestore.instance;
    String userId = thisUser!.uid;

    try {
      await firestore.collection('userFoodBookMark').doc(userId).set({
        'selectedFoods': mealPlan,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: false));

      // Show Snackbar after successful save
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 3,
          duration: const Duration(seconds: 2),
          content: Text('All meals in the plan saved!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Handle errors here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 3,
          duration: const Duration(seconds: 2),
          content: Text('Error saving meals: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<Map<String, Map<String, dynamic>>> fetchMealPlans() async {
//    await Future.delayed(Duration(seconds: 30)); // Simulating backend delay

    // Assuming these are the user's macronutrient limits
    double maxCarbs = double.parse(maxNutrients["carbs"].toString());
    double maxFats = double.parse(maxNutrients["fats"].toString());
    double maxProteins = double.parse(maxNutrients["proteins"].toString());

    bool mealPlanValid = false;
    int iterationCount = 0;
    int maxIterations = 100;
    const timeoutDuration = Duration(seconds: 30); // Timeout after 30 seconds
    print("Total Macros: $maxCarbs , $maxFats , $maxProteins");
    print(iterationCount);
    // Declare mealPlansMap outside of try-catch
    Map<String, Map<String, dynamic>> mealPlansMap = {};

    while (!mealPlanValid) {
      iterationCount++;
      print("Iteration $iterationCount");
      /* 
      if (iterationCount > maxIterations) {
        print("Exceeded maximum iterations, returning fallback meal plans...");
        return {
          'No Data': {
            'No Data': {
              'carbs': 0,
              'fats': 0,
              'proteins': 0,
              'servingSize': ''
            },
          }
        };
      } */
      print("try");
      try {
        print("trying");
        // Wrap the generateMealPlans call in a Future with a timeout
        mealPlansMap = await Future.any([
          generateMealPlans(), // Assuming this is async
          Future.delayed(
              timeoutDuration,
              () =>
                  throw TimeoutException("Meal plan generation took too long"))
        ]);

        int totalCarbs = 0;
        int totalProteins = 0;
        int totalFats = 0;
        //print("Generated meal plans: $mealPlansMap");
        print("foods: ${mealPlansMap['Breakfast']?['foodName']}");
        mealPlansMap.forEach((mealName, mealData) {
          // Safely access the macros and cast to int
          totalFats += (mealData['fats'] as num).toInt() ?? 0;
          totalCarbs += (mealData['carbs'] as num).toInt() ?? 0;
          totalProteins += (mealData['proteins'] as num).toInt() ?? 0;
        });

        // Print the totals
        print('Total Carbs: $totalCarbs');
        print('Total Proteins: $totalProteins');
        print('Total Fats: $totalFats');
        globalCarbs = totalCarbs;
        globalFats = totalFats;
        globalProteins = totalProteins;

        // Check if the generated meal plans meet the user's macronutrient requirements
        if (globalCarbs >= (maxCarbs * 0.9) &&
            globalCarbs <= (maxCarbs * 1.1) &&
            globalFats >= (maxFats * 0.9) &&
            globalFats <= (maxFats * 1.1) &&
            globalProteins >= (maxProteins * 0.9) &&
            globalProteins <= (maxProteins * 1.1)) {
          mealPlanValid = true;
          break;
          //print("Valid meal plan generated: $mealPlansMap");
        } else {
          // print("Meal plan out of range, regenerating...");
        }
      } catch (e) {
        // Reset macronutrients to retry
        globalCarbs = 0;
        globalFats = 0;
        globalProteins = 0;
        print("error: $e");
        // Continue the loop to retry generating the meal plans
        print("Retrying meal plan generation...");
        await Future.delayed(Duration(milliseconds: 50));
        continue; // Go back to the start of the loop
      }

      if (iterationCount == maxIterations) {
        print("breaking");
        mealPlanValid = true;

        break;
      }
      await Future.delayed(Duration(milliseconds: 50));
    }
    print("returning: $mealPlansMap");
    print("total macros: $globalCarbs, $globalFats, $globalProteins");
    // Return the generated meal plan after validation
    return mealPlansMap;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Map<String, dynamic>>>(
      future: fetchMealPlans(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Color(0xfff1f1f1),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xff4b39ef)),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Generating meal plans...',
                    style: GoogleFonts.readexPro(
                      fontSize: 16,
                      color: Color(0xff4b39ef),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    label: Text(
                      "Cancel",
                      style: GoogleFonts.readexPro(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    icon: const Icon(
                      FontAwesomeIcons.xmark,
                      color: Colors.red,
                      size: 15,
                    ),
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Color(0xfff1f1f1),
            body: Center(
              child: Text(
                'There was an error in creating the meal plan',
                style: GoogleFonts.readexPro(
                  fontSize: 16,
                  color: Color(0xff4b39ef),
                ),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final mealPlansMap = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: Text('Meal Plan [Auto]',
                  style: GoogleFonts.readexPro(fontSize: 18)),
              backgroundColor: Color(0xff4b39ef),
              foregroundColor: Colors.white,
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Tooltip(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.info,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Help',
                          style: GoogleFonts.readexPro(color: Colors.white),
                        ),
                      ],
                    ),
                    triggerMode: TooltipTriggerMode.tap,
                    message:
                        "The Meal Plan function generates a list of raw ingredients for each mealtime, such as breakfast, lunch, and dinner. It is recommended to use these ingredients when preparing your meals to meet your body's nutritional needs.",
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    showDuration: Duration(seconds: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff4b39ef).withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    textStyle: TextStyle(color: Colors.black),
                    preferBelow: true,
                    verticalOffset: 20,
                  ),
                ),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Color(0xff4b39ef)),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Suggested Meal Plans',
                          style: GoogleFonts.readexPro(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Carbohydrates: ',
                                style: GoogleFonts.readexPro(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Fats: ',
                                style: GoogleFonts.readexPro(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Proteins: ',
                                style: GoogleFonts.readexPro(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${globalCarbs.toStringAsFixed(0)}g',
                                style:
                                    GoogleFonts.readexPro(color: Colors.white),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '${globalFats.toStringAsFixed(0)}g',
                                style:
                                    GoogleFonts.readexPro(color: Colors.white),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '${globalProteins.toStringAsFixed(0)}g',
                                style:
                                    GoogleFonts.readexPro(color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.white30),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      // Refresh meal plans
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.refresh,
                                          color: Colors.greenAccent),
                                      SizedBox(width: 4),
                                      Text(
                                        "Refresh",
                                        style: GoogleFonts.readexPro(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.greenAccent),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 80),
                    itemCount: mealPlansMap.keys.length,
                    itemBuilder: (context, index) {
                      String mealPlanName = mealPlansMap.keys.elementAt(index);
                      Map<String, dynamic> foodData =
                          mealPlansMap[mealPlanName]!;
                      print("meal data: $mealPlansMap");
                      // Ensure each food item is handled as a String at hindi list tng
                      String foodName = foodData['foodName'] ?? '';
                      String householdMeasure =
                          foodData['householdMeasure'] ?? '';
                      String fatValue = foodData['fats'].toString() ?? '0';
                      String carbValue = foodData['carbs'].toString() ?? '0';
                      String proteinValue =
                          foodData['proteins'].toString() ?? '0';

                      // hatiin niyo na buhay ko
                      List<String> foodItems = foodName.split(',');
                      List<String> householdMeasures =
                          householdMeasure.split(',');

                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Text(
                              mealPlanName,
                              style: GoogleFonts.readexPro(
                                textStyle: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 6, 145, 10),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  'Carbs: ${carbValue}g, Proteins: ${proteinValue}g, Fats: ${fatValue}g',
                                  style: GoogleFonts.readexPro(
                                    color: Colors.black45,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Table(
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  border: TableBorder.all(
                                    borderRadius: BorderRadius.circular(10),
                                    width: 0.5,
                                  ),
                                  columnWidths: {
                                    0: FlexColumnWidth(2), // Food Name
                                    2: FlexColumnWidth(2), // Serving Size
                                  },
                                  children: [
                                    // Table header
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Food Name',
                                              style: GoogleFonts.readexPro(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        /* TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Carbs (g)',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Fats (g)',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Proteins (g)',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ), */
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Serving Size',
                                              style: GoogleFonts.readexPro(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Table rows for each food item
                                    for (int i = 0; i < foodItems.length; i++)
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                foodItems[i]
                                                    .trim(), // Trim whitespace
                                                style: GoogleFonts.readexPro(
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                          /* TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                '${carbValue}g', // Use the carb value directly
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                '${fatValue}g', // Use the fat value directly
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                '${proteinValue}g', // Use the protein value directly
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ), */
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                (householdMeasures.length > i
                                                        ? householdMeasures[i]
                                                            .trim()
                                                        : '-') ??
                                                    '-', // Ensure valid access
                                                style: GoogleFonts.readexPro(
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color(0xff4b39ef),
              onPressed: () {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Center(
                        child: Text(
                          'Confirm Save',
                          style: GoogleFonts.readexPro(
                            color: Colors.black,
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      content: Text(
                        'Do you want to save this meal plan?',
                        style: GoogleFonts.readexPro(
                          color: Colors.black54,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.readexPro(
                              color: Colors.red,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Convert mealPlansMap to a list format suitable for saving
                            List<Map<String, dynamic>> mealPlanList =
                                mealPlansMap.entries.map((entry) {
                              String mealName = entry
                                  .key; // Meal name (e.g., Breakfast, Lunch, etc.)
                              Map<String, dynamic> innerMap = entry.value;

                              // Prepare the food names and serving sizes as lists
                              List<String> foodNames =
                                  innerMap['foodName'].split(', ');
                              List<String> householdMeasures =
                                  innerMap['householdMeasure'].split(', ');

                              // Create a list of food items for each meal
                              List<Map<String, dynamic>> foods =
                                  List.generate(foodNames.length, (index) {
                                return {
                                  'foodName': foodNames[index],
                                  'servingSize': householdMeasures.length >
                                          index
                                      ? householdMeasures[index]
                                      : 'N/A', // Provide a default if the size is missing
                                };
                              });

                              return {
                                'meal':
                                    mealName, // Use the outer map key as the meal name
                                'foods':
                                    foods, // List of food items for the meal
                              };
                            }).toList();

                            // Save all meals to Firestore with context
                            await saveMealsToFirestore(context, mealPlanList);

                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: Text(
                            'Confirm',
                            style: GoogleFonts.readexPro(
                              color: Colors.green,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 2,
                  ),
                  Icon(
                    IconlyBold.arrow_down_2,
                    color: Colors.white,
                  ),
                  Text(
                    'Save',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndFloat,
          );
        } else {
          return Scaffold(
            backgroundColor: Color(0xfff1f1f1),
            body: Center(
              child: Text(
                'No meal plans available. Please try again later.',
                style: GoogleFonts.readexPro(
                  fontSize: 16,
                  color: Color(0xff4b39ef),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
