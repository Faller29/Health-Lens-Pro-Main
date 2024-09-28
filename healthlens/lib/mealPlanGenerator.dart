import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
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
    print(chronicDisease);
  }

  List<Map<String, dynamic>> generateMealPlans() {
    final List<Map<String, dynamic>> mealPlans = [];

    // Separate lists for rice and non-rice foods
    List<Map<String, String>> riceFoods = [];
    List<Map<String, String>> nonRiceFoods = [];

    // Convert itemMacronutrients into two separate lists
    for (String food in itemMacronutrients.keys) {
      for (String part in itemMacronutrients[food]!.keys) {
        Map<String, int> nutrients = itemMacronutrients[food]![part]!;

        Map<String, String> meal = {
          'meal': food,
          'part': part,
          'carbs': nutrients['carbs'].toString(),
          'fats': nutrients['fats'].toString(),
          'proteins': nutrients['proteins'].toString(),
          'warning': nutrients['warnings'].toString(),
        };

        if (food.contains('Rice')) {
          riceFoods.add(meal);
        } else {
          nonRiceFoods.add(meal);
        }
      }
    }

    // Helper to extract the first word (base name) of a food
    String getFirstWord(String food) {
      return food.split(' ').first;
    }

    // Helper to generate meal plans
    void addMealPlan(int startIndex, int jumpBy) {
      int nonRiceIndex = startIndex;
      List<Map<String, dynamic>> tempMealPlan = [];
      Set<String> selectedFoods = {};
      Set<String> addedRice = {}; // Track added rice types

      int totalCarbs = 0;
      int totalFats = 0;
      int totalProteins = 0;

      // Add 4 non-rice meals, ensuring they are unique by base name
      while (selectedFoods.length < 4) {
        if (nonRiceIndex >= nonRiceFoods.length) {
          nonRiceIndex = 0; // Wrap around if index goes out of bounds
        }

        Map<String, String> currentFood = nonRiceFoods[nonRiceIndex];
        String baseName = getFirstWord(currentFood['meal']!);
        if (!selectedFoods.contains(baseName)) {
          // Add food with quantity
          tempMealPlan.add({
            ...currentFood,
            'quantity': 1, // Start with a quantity of 1
          });
          selectedFoods.add(baseName);

          // Add the macronutrients for the selected food
          totalCarbs += int.parse(currentFood['carbs']!);
          totalFats += int.parse(currentFood['fats']!);
          totalProteins += int.parse(currentFood['proteins']!);
        }
        nonRiceIndex += jumpBy;
      }

      // Add rice meals (maximum of 2, no duplicates)
      if (riceFoods.isNotEmpty) {
        int riceCount = 0; // Track number of rice added
        int whiteRiceQuantity = 0; // Track quantity of White Rice (Boiled Rice)

        for (var rice in riceFoods) {
          if (rice['meal'] == 'White Rice (Boiled Rice)' &&
              whiteRiceQuantity < 4) {
            // Only add White Rice (Boiled Rice) if not exceeding quantity
            tempMealPlan.add({
              ...rice,
              'quantity': 1,
            });
            addedRice.add(rice['meal']!); // Track added rice type
            whiteRiceQuantity++; // Increment white rice quantity
            totalCarbs += int.parse(rice['carbs']!);
            totalFats += int.parse(rice['fats']!);
            totalProteins += int.parse(rice['proteins']!);
          } else if (riceCount < 2 &&
              rice['meal'] != 'White Rice (Boiled Rice)' &&
              !addedRice.contains(rice['meal'])) {
            // Only add other rice types if we haven't added 2 yet
            tempMealPlan.add({
              ...rice,
              'quantity': 1,
            });
            addedRice.add(rice['meal']!); // Track added rice type
            riceCount++; // Increment rice count
            totalCarbs += int.parse(rice['carbs']!);
            totalFats += int.parse(rice['fats']!);
            totalProteins += int.parse(rice['proteins']!);
          }
        }
      }

      // Check if the total macronutrients are below the threshold (10% deficit)
      int maxCarbs = maxNutrients['carbs'];
      int maxFats = maxNutrients['fats'];
      int maxProteins = maxNutrients['proteins'];

      int thresholdCarbs = (maxCarbs * 0.90).toInt();
      int thresholdFats = (maxFats * 0.90).toInt();
      int thresholdProteins = (maxProteins * 0.90).toInt();

      // Try to add quantities to the rice food items
      for (var food in tempMealPlan) {
        if (food['meal'] == 'White Rice (Boiled Rice)' &&
            food['quantity'] < 4) {
          while (totalCarbs < thresholdCarbs ||
              totalFats < thresholdFats ||
              totalProteins < thresholdProteins) {
            // Calculate new quantities
            int newCarbs = totalCarbs + int.parse(food['carbs']!);
            int newFats = totalFats + int.parse(food['fats']!);
            int newProteins = totalProteins + int.parse(food['proteins']!);

            // Check if the new totals exceed the max limits
            if (newCarbs <= maxCarbs &&
                newFats <= maxFats &&
                newProteins <= maxProteins) {
              food['quantity']++; // Increase the quantity of the rice
              totalCarbs = newCarbs;
              totalFats = newFats;
              totalProteins = newProteins;
            } else {
              break; // Exit the loop if we can't add more without exceeding limits
            }
          }
        }
      }

      // Add the completed meal plan to the list
      mealPlans.add({
        'mealPlan': tempMealPlan,
        'totalCarbs': totalCarbs,
        'totalFats': totalFats,
        'totalProteins': totalProteins,
      });
    }

    // Generate meal plans using jumps
    for (int i = 0; i < nonRiceFoods.length; i++) {
      addMealPlan(i, 2);
      if (mealPlans.length >= 10) break; // Limit to 10 meal plans
    }

    return mealPlans;
  }

  Future<void> saveMealsToFirestore(
      BuildContext context, List<Map<String, dynamic>> mealPlan) async {
    final firestore = FirebaseFirestore.instance;
    String userId = thisUser!.uid;

    // Prepare the array of selected foods
    List<Map<String, dynamic>> selectedFoods = mealPlan.map((meal) {
      return {
        'foodName': meal['meal'],
        'servingPart': meal['part'],
        'quantity': meal['quantity'], // Include quantity
      };
    }).toList();

    try {
      await firestore.collection('userFoodBookMark').doc(userId).set({
        'selectedFoods': selectedFoods,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

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

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> mealPlans = generateMealPlans();

    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Plan', style: GoogleFonts.readexPro(fontSize: 18)),
        backgroundColor: Color(0xff4b39ef),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Suggested Meal Plans',
              style: GoogleFonts.readexPro(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: mealPlans.length,
                itemBuilder: (context, index) {
                  List<Map<String, dynamic>> mealPlan =
                      mealPlans[index]['mealPlan'];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          title: Text(
                            'Meal Plan ${index + 1}',
                            style: GoogleFonts.readexPro(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Macronutrients:',
                                style: GoogleFonts.readexPro(
                                  textStyle: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Text(
                                'Carbs: ${mealPlans[index]['totalCarbs']}g, '
                                'Fats: ${mealPlans[index]['totalFats']}g, '
                                'Proteins: ${mealPlans[index]['totalProteins']}g',
                                style: GoogleFonts.readexPro(
                                  textStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Column(
                              children: mealPlan.map((meal) {
                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  title: Text(
                                    '${meal['meal']} - ${meal['part']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'Quantity: x${meal['quantity']}, '
                                    'Carbs: ${meal['carbs']}g, '
                                    'Fats: ${meal['fats']}g, '
                                    'Proteins: ${meal['proteins']}g',
                                  ),
                                  trailing:
                                      Icon(Icons.fastfood, color: Colors.teal),
                                );
                              }).toList(),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent,
                              ),
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
                                            // Save all meals to Firestore with context
                                            await saveMealsToFirestore(
                                                context, mealPlan);

                                            Navigator.of(context)
                                                .pop(); // Close the dialog
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
                              child: Text(
                                'Save Meal Plan',
                                style: GoogleFonts.readexPro(
                                  fontSize: 14.0,
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
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
