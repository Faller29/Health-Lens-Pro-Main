import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/main.dart';
import 'package:iconly/iconly.dart';
import 'backend_firebase/foodExchange.dart'; // Import your existing file

class FoodSelectorPage extends StatefulWidget {
  @override
  _FoodSelectorPageState createState() => _FoodSelectorPageState();
}

class _FoodSelectorPageState extends State<FoodSelectorPage> {
  final Set<String> selectedItems = {};
  final Map<String, int> selectedQuantities =
      {}; // Store quantities for selected foods

  int totalCarbs = 0;
  int totalFats = 0;
  int totalProteins = 0;

  int userCurrentCarbs = 0;
  int userCurrentFats = 0;
  int userCurrentProteins = 0;

  int userMaxCarbs = 375; // Example maximum values from Firebase
  int userMaxFats = 70; // Example maximum values from Firebase
  int userMaxProteins = 95; // Example maximum values from Firebase

  List<String> chronicDiseases = ['Obesity']; // Example chronic diseases
  List<int> chronicIndexList = [];

  @override
  void initState() {
    super.initState();
    fetchUserMacros();
  }

  Future<void> fetchUserMacros() async {
    String userId = thisUser!.uid; // Fetch the actual UID dynamically

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('user').doc(userId).get();
    setState(() {
      userMaxCarbs = userDoc['gramCarbs'] ?? 375; // Default value
      userMaxFats = userDoc['gramFats'] ?? 70; // Default value
      userMaxProteins = userDoc['gramProtein'] ?? 95; // Default value
    });

    DocumentSnapshot userMacrosDoc = await FirebaseFirestore.instance
        .collection('userMacros')
        .doc(userId)
        .get();
    setState(() {
      userCurrentCarbs = userMacrosDoc['carbs'] ?? 0;
      userCurrentFats = userMacrosDoc['fats'] ?? 0;
      userCurrentProteins = userMacrosDoc['proteins'] ?? 0;
    });
  }

  void calculateTotal() {
    totalCarbs = 0;
    totalFats = 0;
    totalProteins = 0;
    chronicIndexList.clear();

    for (var food in itemMacronutrients.keys) {
      for (var serving in itemMacronutrients[food]!.keys) {
        String key = '$food ($serving)';
        if (selectedItems.contains(key)) {
          int quantity =
              selectedQuantities[key] ?? 1; // Default to 1 if no quantity set
          totalCarbs += int.parse(
                  (itemMacronutrients[food]![serving]!['carbs']).toString()) *
              quantity;
          totalFats += int.parse(
                  (itemMacronutrients[food]![serving]!['fats']).toString()) *
              quantity;
          totalProteins += int.parse(
                  (itemMacronutrients[food]![serving]!['proteins'])
                      .toString()) *
              quantity;

          int? warnings =
              itemMacronutrients[food]![serving]!.containsKey('warnings')
                  ? itemMacronutrients[food]![serving]!['warnings']
                  : 0;

          if (warnings == 4 && chronicDiseases.contains('Obesity')) {
            chronicIndexList.add(1);
          } else if (warnings == 3 &&
              chronicDiseases.contains('Hypertension')) {
            chronicIndexList.add(2);
          } else if (warnings == 2 &&
              chronicDiseases.contains('Diabetes [Type 1 & 2]')) {
            chronicIndexList.add(3);
          } else {
            chronicIndexList.add(4);
          }
        }
      }
    }

    setState(() {}); // Ensure to call setState here to refresh the UI
  }

  void updateQuantity(String food, String serving, int change) {
    String key = '$food ($serving)';
    if (change < 0 && (selectedQuantities[key] ?? 1) + change < 1) {
      return; // Prevent decreasing below 1
    }

    setState(() {
      selectedQuantities[key] =
          (selectedQuantities[key] ?? 1) + change; // Update quantity
      if (selectedQuantities[key]! <= 0) {
        selectedQuantities.remove(key);
        selectedItems.remove(key);
      }
      calculateTotal(); // Recalculate totals after changing quantity

      // Check if current totals exceed user limits
      if ((userCurrentCarbs + totalCarbs) > userMaxCarbs ||
          (userCurrentFats + totalFats) > userMaxFats ||
          (userCurrentProteins + totalProteins) > userMaxProteins) {
        // If exceeded, remove the last added item and show a warning
        selectedQuantities[key] = (selectedQuantities[key] ?? 1) - change;
        if (selectedQuantities[key]! <= 0) {
          selectedQuantities.remove(key);
          selectedItems.remove(key);
        }
        calculateTotal(); // Recalculate totals after removal
        _showExceedWarning(); // Show warning
      }
    });
  }

  void toggleSelection(String food, String serving) {
    String key = '$food ($serving)';
    setState(() {
      if (selectedItems.contains(key)) {
        selectedItems.remove(key);
        print('Removed: $key');
      } else {
        selectedItems.add(key);
        print('Added: $key');
      }
      calculateTotal();

      if ((userCurrentCarbs + totalCarbs) > userMaxCarbs ||
          (userCurrentFats + totalFats) > userMaxFats ||
          (userCurrentProteins + totalProteins) > userMaxProteins) {
        selectedItems.remove(key);
        calculateTotal();
        _showExceedWarning();
      }

      print(
          'Total Carbs: $totalCarbs, Fats: $totalFats, Proteins: $totalProteins');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Plan [Manual]',
            style: GoogleFonts.readexPro(fontSize: 18)),
        backgroundColor: Color(0xff4b39ef),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Sticky Header for total macronutrients
          Container(
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xff4b39ef),
              //borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Column(
              children: [
                Text(
                  'Macronutrients Counter',
                  style: GoogleFonts.readexPro(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Carbs: ',
                          style: GoogleFonts.readexPro(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          'Fats: ',
                          style: GoogleFonts.readexPro(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          'Proteins: ',
                          style: GoogleFonts.readexPro(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userCurrentCarbs + totalCarbs} / $userMaxCarbs g',
                          style: GoogleFonts.readexPro(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          '${userCurrentFats + totalFats} / $userMaxFats g',
                          style: GoogleFonts.readexPro(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          '${userCurrentProteins + totalProteins} / $userMaxProteins g',
                          style: GoogleFonts.readexPro(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50),
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
                          "Create your own Meal Plan by Selecting the Foods on the List while paying attention to the Macronutrients Counter to manage what you eat.\n\nWarning Icon indicates that the food is bad for your Health Condition",
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(20),
                      showDuration: Duration(seconds: 10),
                      decoration: BoxDecoration(
                        color: Color(0xff4b39ef).withOpacity(0.9),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      textStyle: TextStyle(color: Colors.white),
                      preferBelow: true,
                      verticalOffset: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Food List
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 70),
              itemCount: itemMacronutrients.length,
              itemBuilder: (context, index) {
                String food = itemMacronutrients.keys.elementAt(index);
                bool hasSelectedItems = itemMacronutrients[food]!.keys.any(
                  (serving) {
                    String key = '$food ($serving)';
                    return selectedItems.contains(key);
                  },
                );

                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  shadowColor: Color(0xff4b39ef),
                  child: Material(
                    elevation: 3,
                    color: Colors.white,
                    shadowColor: Color(0xff4b39ef),
                    borderRadius: BorderRadius.circular(10),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Row(
                          children: [
                            if (hasSelectedItems)
                              Icon(Icons.check, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              food,
                              style: GoogleFonts.readexPro(
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                              textScaler: TextScaler.linear(1.15),
                            ),
                          ],
                        ),
                        children: itemMacronutrients[food]!.keys.map((serving) {
                          String key = '$food ($serving)';
                          bool hasWarning = itemMacronutrients[food]![serving]!
                              .containsKey('warnings');
                          Map<String, dynamic> macronutrients =
                              itemMacronutrients[food]![serving]!;

                          return CheckboxListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    key,
                                    style: GoogleFonts.readexPro(
                                      textStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                if (hasWarning)
                                  Icon(IconlyBold.danger, color: Colors.red),
                              ],
                            ),
                            subtitle: Column(
                              children: [
                                Text(
                                  'Carbs: ${macronutrients['carbs']} g, Fats: ${macronutrients['fats']} g, Proteins: ${macronutrients['proteins']} g',
                                  style: GoogleFonts.readexPro(
                                    textStyle: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                // Quantity buttons
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Quantity: "),
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: selectedItems.contains(key)
                                          ? () =>
                                              updateQuantity(food, serving, -1)
                                          : null,
                                    ),
                                    Text('${selectedQuantities[key] ?? 1}'),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: selectedItems.contains(key)
                                          ? () =>
                                              updateQuantity(food, serving, 1)
                                          : null,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            value: selectedItems.contains(key),
                            onChanged: (bool? value) {
                              toggleSelection(food, serving);
                            },
                          );
                        }).toList(),
                      ),
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
        elevation: 5,
        onPressed: () {
          showSelectedFoodsBottomSheet(context);
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
    );
  }

  void showSelectedFoodsBottomSheet(BuildContext context) {
    int totalCarbs = 0;
    int totalFats = 0;
    int totalProteins = 0;

    List<Map<String, dynamic>> selectedFoodList = [];

    for (var food in itemMacronutrients.keys) {
      for (var serving in itemMacronutrients[food]!.keys) {
        String key = '$food ($serving)';
        if (selectedItems.contains(key)) {
          int quantity = selectedQuantities[key] ?? 1; // Get the quantity
          selectedFoodList.add({
            'foodName': food, // e.g., Chicken (Chicken Inasal)
            'servingPart': serving, // e.g., Breast
            'quantity': quantity, // Include quantity
          });
          totalCarbs += int.parse(
                  (itemMacronutrients[food]![serving]!['carbs']).toString()) *
              quantity;
          totalFats += int.parse(
                  (itemMacronutrients[food]![serving]!['fats']).toString()) *
              quantity;
          totalProteins += int.parse(
                  (itemMacronutrients[food]![serving]!['proteins'])
                      .toString()) *
              quantity;
        }
      }
    }

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Center(
          child: Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.fromLTRB(10, 120, 10, 120),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    'Selected Foods',
                    style: GoogleFonts.readexPro(
                      fontSize: 18.0,
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (selectedFoodList.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Center(
                      child: Text(
                        'No foods selected',
                        style: GoogleFonts.readexPro(
                          fontSize: 20.0,
                          textStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(children: [
                          ...selectedFoodList
                              .map(
                                (food) => Column(
                                  children: [
                                    Table(
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      /* border: TableBorder.all(
                                      borderRadius: BorderRadius.circular(10),
                                      width: 0.5,
                                    ), */
                                      /* columnWidths: {
                                      0: FlexColumnWidth(1),
                                      2: FlexColumnWidth(1),
                                      3: FlexColumnWidth(1),
                                    }, */
                                      children: [
                                        TableRow(
                                          children: [
                                            TableCell(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Text(
                                                '${food['foodName']}', // Include quantity
                                                style: GoogleFonts.readexPro(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  textStyle: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            )),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2),
                                                child: Text(
                                                  '(${food['servingPart']})', // Include quantity
                                                  style: GoogleFonts.readexPro(
                                                    fontSize: 14.0,
                                                    textStyle: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                    ),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Text(
                                                'x${food['quantity']}', // Include quantity
                                                style: GoogleFonts.readexPro(
                                                  fontSize: 14.0,
                                                  textStyle: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 0.5,
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ]),
                      ),
                    ),
                  ),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: Color(0xff4b39ef),
                  ),
                  width: MediaQuery.sizeOf(context).width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Total Macronutrients:',
                          style: GoogleFonts.readexPro(
                            fontSize: 16.0,
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Carbs: $totalCarbs g',
                              style: GoogleFonts.readexPro(
                                fontSize: 14.0,
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              'Fats: $totalFats g',
                              style: GoogleFonts.readexPro(
                                fontSize: 14.0,
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              'Proteins: $totalProteins g',
                              style: GoogleFonts.readexPro(
                                fontSize: 14.0,
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (selectedFoodList.isNotEmpty)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent,
                                ),
                                onPressed: () async {
                                  await saveSelectedFoods(selectedFoodList);
                                  print(selectedFoodList);
                                  // Show success Snackbar after saving
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      elevation: 3,
                                      duration: const Duration(seconds: 2),
                                      content: Text('Saved successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Save',
                                  style: GoogleFonts.readexPro(
                                    fontSize: 14.0,
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            if (selectedFoodList.isNotEmpty)
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedItems
                                        .clear(); // Clear all selected items
                                    totalCarbs =
                                        0; // Reset total macronutrients
                                    totalFats = 0;
                                    totalProteins = 0;
                                    calculateTotal(); // Recalculate totals to update UI
                                  });
                                  Navigator.pop(
                                      context); // Close the bottom sheet
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent),
                                child: Text(
                                  'Clear All Foods',
                                  style: GoogleFonts.readexPro(
                                    fontSize: 14.0,
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /* Future<void> saveSelectedFoods(
      List<Map<String, dynamic>> selectedFoodList) async {
    String userId = thisUser!.uid;
    await FirebaseFirestore.instance
        .collection('userFoodBookMark')
        .doc(userId)
        .set({
      'selectedFoods': selectedFoodList,
      'timestamp': FieldValue.serverTimestamp(),
    });
  } */
  Future<void> saveSelectedFoods(
      List<Map<String, dynamic>> selectedFoodList) async {
    String userId = thisUser!.uid;

    // Create a structured map for saving to Firestore
    List<Map<String, dynamic>> foods = [];

    // Add selected foods to the foods array, duplicating based on quantity
    for (var food in selectedFoodList) {
      int quantity =
          food['quantity'] ?? 1; // Get the quantity, default to 1 if missing

      // Duplicate the food entry based on the quantity
      for (int i = 0; i < quantity; i++) {
        foods.add({
          'foodName': food['foodName'] ?? 'N/A', // Default to 'N/A' if missing
          'servingSize':
              food['servingPart'] ?? 'N/A', // Default to 'N/A' if missing
        });
      }
    }

    // Create a meal entry with the specified name and foods
    Map<String, dynamic> mealEntry = {
      'meal': 'Manually Added Meal',
      'foods': foods,
    };

    // Save the structured data to Firestore
    await FirebaseFirestore.instance
        .collection('userFoodBookMark')
        .doc(userId)
        .set({
      'selectedFoods': [mealEntry], // Wrap the mealEntry in an array
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _showExceedWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Warning',
            style: GoogleFonts.readexPro(
              textStyle: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'You have exceeded your daily macronutrient limits.',
            style: GoogleFonts.readexPro(
              textStyle: TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Confirm',
                style: GoogleFonts.readexPro(
                  textStyle: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}
