import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart'; // Add this for Firestore
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/main.dart';
import 'package:iconly/iconly.dart';
import 'package:healthlens/entry_point.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'backend_firebase/foodExchange.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class FoodServing extends StatefulWidget {
  @override
  _FoodServingState createState() => _FoodServingState();
}

class _FoodServingState extends State<FoodServing> {
  List<Map<String, dynamic>> foodItems = [];
  List<Map<String, dynamic>> _detectedItems = [];
  int idNum = 1;
  bool _isLoading = false;
  var _firstPress = true;

  int _generateUniqueId() {
    idNum++;
    return idNum; // Use timestamp as a simple unique key
  }

  // Store selected parts for each item
  Map<String, String?> selectedParts = {};

  // Macronutrient data based on the part selected for each item

  String removeId(String tag) {
    return tag.replaceAll(RegExp(r'\d+'), '');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve the detected items passed from CameraPage
    final args = ModalRoute.of(context)?.settings.arguments
        as List<Map<String, dynamic>>?;
    if (args != null) {
      setState(() {
        _detectedItems = args;

        // Process detected items to add them to foodItems
        _processDetectedItems();
      });
    }
  }

  void _processDetectedItems() {
    final itemMap = <String, int>{};

    for (var item in _detectedItems) {
      final label = item['tag'];
      final quantity = (item['quantity'] is int)
          ? item['quantity'] as int
          : (item['quantity'] as num).toInt();

      if (itemMap.containsKey(label)) {
        itemMap[label] = itemMap[label]! + quantity;
      } else {
        itemMap[label] = quantity;
      }
    }

    setState(() {
      foodItems = itemMap.entries
          .map((entry) => {'item': entry.key, 'quantity': entry.value})
          .toList();
    });
  }

  void removeItem(int index) {
    setState(() {
      if (index >= 0 && index < foodItems.length) {
        // Remove the item from the selectedParts map before removing the item itself
        final itemToRemove = foodItems[index]['item'];
        selectedParts
            .remove(itemToRemove); // Ensure selectedParts are cleaned up

        // Now remove the item from the foodItems list
        foodItems.removeAt(index);
        _detectedItems.removeAt(index);
      }
    });
  }

  void increaseQuantity(int index) {
    setState(() {
      _detectedItems[index]['quantity']++;
      foodItems[index]['quantity']++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (foodItems[index]['quantity'] > 1) {
        foodItems[index]['quantity']--;
        _detectedItems[index]['quantity']--;
      }
    });
  }

  // Build item options with parts and display macronutrients
  Widget _buildItemOptions(String item) {
    List<int> chronicIndexList = [];

    String itemRemovedId = '';
    itemRemovedId = removeId(item);
    final parts = itemMacronutrients[itemRemovedId]?.keys.toList() ?? [];

    if (parts.isEmpty) return SizedBox.shrink();

    // Ensure selectedParts[itemRemovedId] is set to the first item if null
    if (selectedParts[item] == null && parts.isNotEmpty) {
      selectedParts[item] = parts.first;
    }
    if (chronicDisease!.contains('Obesity')) {
      chronicIndexList.add(1);
    } else if (chronicDisease!.contains('Hypertension')) {
      chronicIndexList.add(2);
    } else if (chronicDisease!.contains('Diabetes [Type 1 & 2]')) {
      chronicIndexList.add(3);
    } else {
      chronicIndexList.add(4);
    }
    print(chronicIndexList);
    // Helper function to get the warning message based on the chronic index
    String _getWarningMessage(int chronicIndex) {
      switch (chronicIndex) {
        case 1:
          return 'This food is bad for your health if you have Obesity.\nKeep out of too much Oily Foods as it is bad for your Health';
        case 2:
          return 'This food is bad for your health if you have Hypertension.\nKeep out of too much Oily Foods as it is bad for your Health';
        case 3:
          return 'This food is bad for your health if you have Diabetes.\nKeep out of too much Oily or Sweet Foods as it is bad for your Health';
        case 4:
          return 'This food is not healthy for you.\nKeep out of Oily Foods as it is bad for your Health';
        default:
          return '';
      }
    }

    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Builder(
                builder: (context) {
                  if (itemRemovedId.contains('Egg') ||
                      itemRemovedId.contains('Tortang Talong') ||
                      itemRemovedId.contains('Bread')) {
                    return Text('Food Type:', style: GoogleFonts.readexPro());
                  } else if (itemRemovedId.contains('Rice') ||
                      itemRemovedId.contains('Potato') ||
                      itemRemovedId.contains('Onion') ||
                      itemRemovedId.contains('Kamatis') ||
                      itemRemovedId.contains('Boiled') ||
                      itemRemovedId.contains('Pork (Lechon Kawali)') ||
                      itemRemovedId.contains('Chicken (Adobong Iga)')) {
                    return Text('Serving Size:',
                        style: GoogleFonts.readexPro());
                  } else if (itemRemovedId
                          .contains('Pork (Breaded Pork Chop)') ||
                      itemRemovedId.contains('Fish (Daing na Bangus)')) {
                    return Text('Slice:', style: GoogleFonts.readexPro());
                  } else {
                    return Text('Select serving:',
                        style: GoogleFonts.readexPro());
                  }
                },
              ),
            ),
            SizedBox(
              width: 20,
            ),
            DropdownButton<String>(
              isExpanded: true,
              menuMaxHeight: 400,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              borderRadius: BorderRadius.circular(10),
              isDense: true,
              dropdownColor: Colors.white,
              value: selectedParts[item],
              items: parts.map((part) {
                return DropdownMenuItem<String>(
                  value: part,
                  child: Text(part,
                      style: GoogleFonts.readexPro(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      )),
                );
              }).toList(),
              onChanged: (String? selectedPart) {
                setState(() {
                  selectedParts[item] = selectedPart;
                  print(selectedPart);
                  print(item);
                  print(foodItems);
                });
              },
            ),
          ],
        ),
        if (selectedParts[item] != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Macronutrients:',
                style: GoogleFonts.readexPro(),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fats: ${itemMacronutrients[itemRemovedId]?[selectedParts[item]]?['fats']}g',
                    style: GoogleFonts.readexPro(
                      textStyle: TextStyle(
                        color: const Color(0xff249689),
                      ),
                    ),
                  ),
                  Text(
                    'Carbs: ${itemMacronutrients[itemRemovedId]?[selectedParts[item]]?['carbs']}g',
                    style: GoogleFonts.readexPro(
                      textStyle: TextStyle(
                        color: const Color(0xff4b39ef),
                      ),
                    ),
                  ),
                  Text(
                    'Proteins: ${itemMacronutrients[itemRemovedId]?[selectedParts[item]]?['proteins']}g',
                    style: GoogleFonts.readexPro(
                      textStyle: TextStyle(
                        color: const Color(0xffff5963),
                      ),
                    ),
                  ),
                  // Check for warnings based on chronicDisease
                ],
              ),
            ],
          ),
        SizedBox(
          height: 10,
        ),
        for (var chronicIndex in chronicIndexList)
          if (itemMacronutrients[itemRemovedId]?[selectedParts[itemRemovedId]]
                      ?['warnings'] ==
                  chronicIndex ||
              itemMacronutrients[itemRemovedId]?[selectedParts[itemRemovedId]]
                      ?['warnings'] ==
                  4)
            Row(
              children: [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    _getWarningMessage(chronicIndex),
                    style: GoogleFonts.readexPro(
                      fontSize: 12,
                      textStyle: TextStyle(
                        color: const Color.fromARGB(255, 177, 41, 31),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        if (itemRemovedId.contains('Pork'))
          Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 10),
              Flexible(
                child: Text(
                  "\nDon't eat Fatty Part of Pork as it is Bad for your health condition.",
                  style: GoogleFonts.readexPro(
                    fontSize: 12,
                    textStyle: TextStyle(
                      color: const Color.fromARGB(255, 177, 41, 31),
                    ),
                  ),
                ),
              ),
            ],
          )
      ],
    );
  }

  // Function to wrap the data for Firebase submission
  // Function to wrap the data for Firebase submission
  Map<String, dynamic> _wrapDataForFirebase() {
    // Instead of removing unique ID, we will use the original unique ID for processing
    List<Map<String, dynamic>> wrappedItems = foodItems.map((foodItem) {
      final originalItemId = foodItem['item'] as String;
      final itemRemovedId =
          removeId(originalItemId); // Still remove the ID for other purposes

      // Get selected part based on the original unique ID, not the modified one
      final selectedPart = selectedParts[originalItemId];
      final macronutrients =
          itemMacronutrients[itemRemovedId]?[selectedPart] ?? {};

      return {
        'item': itemRemovedId, // Use item without unique ID for display
        'quantity': foodItem['quantity'],
        'part': selectedPart,
        'fats': _parseInt(macronutrients['fats']),
        'carbs': _parseInt(macronutrients['carbs']),
        'proteins': _parseInt(macronutrients['proteins']),
      };
    }).toList();

    return {
      'timestamp': DateTime.now().toIso8601String(),
      'items': wrappedItems,
      'userId': thisUser?.uid, // Associate the data with the current user
    };
  }

// Function to safely parse integer values, defaulting to 0 if parsing fails
  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        return 0; // Default to 0 if parsing fails
      }
    }
    return 0;
  }

  Future<void> _confirmAndSendToFirebase() async {
    try {
      // Wrap the data into a map that will be sent to Firebase
      final wrappedData = _wrapDataForFirebase();

      // Get the current date in 'yyyy-MM-dd' format
      final String currentDate = DateTime.now().toIso8601String().split('T')[0];
      // Get the current time in 'hh:mm' format
      final String currentTime =
          "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
      // Check if adding the current food serving will exceed the user's max intake

      final String canAdd = await _checkIfWithinMaxLimits(wrappedData['items']);

      if (canAdd == 'canAdd') {
        // Save the food serving data in 'food_history'
        await FirebaseFirestore.instance
            .collection('food_history')
            .doc(thisUser?.uid)
            .collection(currentDate)
            .doc(currentTime)
            .set(wrappedData); // Store the data

        // Now accumulate the macronutrients
        await _updateUserMacros(wrappedData['items']);

        // Navigate to the EntryPoint page after confirming
      } else if (canAdd == 'allowed') {
        // Notify user that the food exceeds their daily max intake
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Warning",
                style: GoogleFonts.readexPro(
                  fontSize: 20.0,
                  textStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              content: Text(
                "You have reached your recommended daily macronutrients and You are only allowed to exceed up to 20%.\n\nDo you want to Continue?",
                style: GoogleFonts.readexPro(
                  fontSize: 14.0,
                  textStyle: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
                textAlign: TextAlign.justify,
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (_firstPress) {
                      _firstPress = false;

                      // Show the snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          elevation: 3,
                          duration: const Duration(seconds: 2),
                          content: Text('Processing....'),
                        ),
                      );

                      // Check if the widget is still mounted before popping
                      if (mounted) {
                        Navigator.pop(context);
                      }

                      await FirebaseFirestore.instance
                          .collection('food_history')
                          .doc(thisUser?.uid)
                          .collection(currentDate)
                          .doc(currentTime)
                          .set(wrappedData); // Store the data

                      // Now accumulate the macronutrients
                      await _updateUserMacros(wrappedData['items']);

                      // Reset the first press state if still mounted
                      if (mounted) {
                        setState(() {
                          _firstPress = true;
                        });
                      }
                    }
                  },
                  child: Text(
                    "Confirm",
                    style: GoogleFonts.readexPro(
                      fontSize: 15.0,
                      textStyle: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Show the snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        elevation: 3,
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                        content: Text(
                            'This food exceeds your daily macronutrient limits!'),
                      ),
                    );

                    // Check if the widget is still mounted before popping
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "No",
                    style: GoogleFonts.readexPro(
                      fontSize: 15.0,
                      textStyle: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              elevation: 3,
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
              content:
                  Text('This food exceeds your daily macronutrient limits!')),
        );
      }
    } catch (e) {
      print("Error submitting data to Firebase: $e");
    }
  }

  Future<String> _checkIfWithinMaxLimits(
      List<Map<String, dynamic>> newMacrosList) async {
    try {
      // Retrieve the user's maximum macronutrient limits
      final userMaxDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(thisUser?.uid)
          .get();

      if (!userMaxDoc.exists || userMaxDoc.data() == null) {
        print('Error: No max limits found for user or data is null.');
        return 'error';
      }

      final userMaxData = userMaxDoc.data()!;
      final maxCarbs = _parseInt(userMaxData['gramCarbs']);
      final maxProteins = _parseInt(userMaxData['gramProtein']);
      final maxFats = _parseInt(userMaxData['gramFats']);

      // Retrieve the user's current macronutrients
      final userMacrosDoc = await FirebaseFirestore.instance
          .collection('userMacros')
          .doc(thisUser?.uid)
          .get();

      final currentMacros = userMacrosDoc.exists
          ? userMacrosDoc.data()! as Map<String, dynamic>?
          : {'carbs': 0, 'proteins': 0, 'fats': 0, 'calories': 0};

      final currentCarbs = _parseInt(currentMacros?['carbs']);
      final currentProteins = _parseInt(currentMacros?['proteins']);
      final currentFats = _parseInt(currentMacros?['fats']);
      int totalCarbs = currentCarbs;
      int totalProteins = currentProteins;
      int totalFats = currentFats;
      // Sum up macronutrients from the newMacrosList, taking quantity into account
      for (var item in newMacrosList) {
        final quantity = _parseInt(item['quantity']); // Get the item quantity
        totalCarbs += _parseInt(item['carbs']) * quantity;
        totalProteins += _parseInt(item['proteins']) * quantity;
        totalFats += _parseInt(item['fats']) * quantity;
      }

      //add 20%
      final double adjustedMaxCarbs = maxCarbs + (maxCarbs * 0.20);
      final double adjustedMaxProteins = maxProteins + (maxProteins * 0.20);
      final double adjustedMaxFats = maxFats + (maxFats * 0.20);

      // Check if adding the new macronutrients exceeds the user's max daily limits
      if (totalCarbs <= maxCarbs &&
          totalProteins <= maxProteins &&
          totalFats <= maxFats) {
        return 'canAdd';
      }

      if (totalCarbs <= adjustedMaxCarbs &&
          totalProteins <= adjustedMaxProteins &&
          totalFats <= adjustedMaxFats) {
        return 'allowed';
      }

      return 'error';
    } catch (e) {
      print("Error checking macronutrient limits: $e");
      return 'error';
    }
  }

  Future<void> _updateUserMacros(
      List<Map<String, dynamic>> newMacrosList) async {
    try {
      // Retrieve the user's current macronutrients
      final userMacrosDoc = await FirebaseFirestore.instance
          .collection('userMacros')
          .doc(thisUser?.uid)
          .get();

      final currentMacros = userMacrosDoc.exists
          ? userMacrosDoc.data()! as Map<String, dynamic>?
          : {
              'carbs': 0,
              'proteins': 0,
              'fats': 0,
              'calories': 0,
            };
      int TotalDailyCalories = _parseInt(currentMacros?['calories']);
      int totalCarbs = _parseInt(currentMacros?['carbs']);
      int totalProteins = _parseInt(currentMacros?['proteins']);
      int totalFats = _parseInt(currentMacros?['fats']);

      for (var items in newMacrosList) {
        final quantity = _parseInt(items['quantity']);
        TotalDailyCalories += (((_parseInt(items['carbs']) * quantity) * 4) +
            ((_parseInt(items['fats']) * quantity) * 9) +
            ((_parseInt(items['proteins']) * quantity) * 4));
      }

      // Sum up macronutrients from the newMacrosList, considering quantity
      for (var item in newMacrosList) {
        final quantity = _parseInt(item['quantity']); // Get the item quantity
        totalCarbs += _parseInt(item['carbs']) * quantity;
        totalProteins += _parseInt(item['proteins']) * quantity;
        totalFats += _parseInt(item['fats']) * quantity;
      }
      final userMaxDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(thisUser?.uid)
          .get();

      if (!userMaxDoc.exists || userMaxDoc.data() == null) {
        print('Error: No max limits found for user or data is null.');
      }

      final thisUserUid = thisUser?.uid;
      final String currentDate = DateTime.now().toIso8601String().split('T')[0];
      final dailyUserMacros = db
          .collection("userMacros")
          .doc(thisUserUid)
          .collection('MacrosIntakeHistory')
          .doc(currentDate);
      await dailyUserMacros.set({
        'carbs': totalCarbs,
        'fats': totalFats,
        'proteins': totalProteins,
        'calories': TotalDailyCalories,
      });

      /* 
      final userMaxData = userMaxDoc.data()!;
      final maxCarbs = _parseInt(userMaxData['gramCarbs']);
      final maxProteins = _parseInt(userMaxData['gramProtein']);
      final maxFats = _parseInt(userMaxData['gramFats']);
      final maxCalories = _parseInt(userMaxData['TER']);
      if (totalCarbs >= maxCarbs) {
        totalCarbs = maxCarbs;
      }
      if (totalFats >= maxFats) {
        totalFats = maxFats;
      }

      if (totalProteins >= maxProteins) {
        totalProteins = maxProteins;
      }
      if (TotalDailyCalories >= maxCalories) {
        TotalDailyCalories = maxCalories;
      } */
      // Update user macros document in Firebase

      await FirebaseFirestore.instance
          .collection('userMacros')
          .doc(thisUser?.uid)
          .set({
        'carbs': totalCarbs,
        'proteins': totalProteins,
        'fats': totalFats,
        'calories': TotalDailyCalories,
        'lastLogIn': currentDate,
      }, SetOptions(merge: true));

      // Update SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('dailyCarbs', totalCarbs);
      await prefs.setInt('dailyProtein', totalProteins);
      await prefs.setInt('dailyFats', totalFats);
      await prefs.setInt('dailyCalories', TotalDailyCalories);

      dailyCarbs = prefs.getInt('dailyCarbs') ?? 0;
      dailyProtein = prefs.getInt('dailyProtein') ?? 0;
      dailyFats = prefs.getInt('dailyFats') ?? 0;
      dailyCalories = prefs.getInt('dailyCalories') ?? 0;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            behavior: SnackBarBehavior.floating,
            elevation: 3,
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
            content: Text('Added successfully')),
      );
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    } catch (e) {
      print('Error updating user macros\n$e');
    }
  }

  void separateItem(int index) {
    setState(() {
      final originalItem = _detectedItems[index];
      final newQuantity = 1; // Default quantity for the separated part

      int id = _generateUniqueId();
      // Create a new entry for the separated item
      final separatedItem = {
        'tag':
            "${originalItem['tag'].replaceAll(RegExp(r'\d+'), '')}${id.toString()}",
        'quantity': newQuantity,
      };
      final separatedFoodItem = {
        'item':
            "${originalItem['tag'].replaceAll(RegExp(r'\d+'), '')}${id.toString()}",
        'quantity': newQuantity,
      };

      // Add the separated item to the detected items list
      try {
        _detectedItems.add(separatedItem);
      } catch (e) {
        print('error: $e');
      }
      try {
        foodItems.add(separatedFoodItem);
      } catch (e) {
        print('error: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Food Serving', style: GoogleFonts.readexPro(fontSize: 18)),
        backgroundColor: Color(0xff4b39ef),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              richMessage: WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Column(
                    children: [
                      Text(
                        'Food Serving',
                        style: GoogleFonts.readexPro(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        child: RichText(
                          text: TextSpan(
                              style: GoogleFonts.readexPro(),
                              children: [
                                TextSpan(
                                  text:
                                      " In order to determine the right serving size, users are advised to use measuring cups. However, if there are no present measuring cups, be advised that you can use your fist or hand to determine the level of serving size.\n\nTake note that",
                                ),
                                TextSpan(
                                  text: " A CUP ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                    text:
                                        "of food (e.g. cup of rice) is equivalent to a"),
                                TextSpan(
                                  text: " CLOSED ADULT FIST",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                    text:
                                        ". By establishing this technique, you can estimate the measurement of a cup."),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Image.asset(
                        'assets/images/serving.jpg',
                        height: 200,
                        width: MediaQuery.sizeOf(context).width,
                        fit: BoxFit.cover,
                      )
                    ],
                  ),
                ),
              ),
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              showDuration: Duration(seconds: 10),
              decoration: BoxDecoration(
                color: Color(0xff4b39ef).withOpacity(0.9),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              preferBelow: true,
              verticalOffset: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    FontAwesomeIcons.circleQuestion,
                    size: 16,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                (foodItems.isNotEmpty)
                    ? Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          itemCount: foodItems.length,
                          itemBuilder: (context, index) {
                            final item = foodItems[index]['item'];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: Material(
                                elevation: 5,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    /* 
                                    side: BorderSide(
                                        color: const Color.fromARGB(
                                            255, 95, 95, 95),
                                        width: 1), */
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  isThreeLine: true,
                                  leading: Icon(Icons.restaurant_menu_outlined,
                                      color: Colors.green),
                                  title: Text(
                                    item,
                                    style: GoogleFonts.readexPro(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildItemOptions(item),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Quantity: ',
                                            style: GoogleFonts.readexPro(
                                              fontSize: 14,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                FontAwesomeIcons.minus,
                                                size: 16),
                                            onPressed: () =>
                                                decreaseQuantity(index),
                                          ),
                                          Text(
                                            '${foodItems[index]['quantity']}',
                                            style: GoogleFonts.readexPro(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              FontAwesomeIcons.plus,
                                              size: 16,
                                            ),
                                            onPressed: () =>
                                                increaseQuantity(index),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  IconlyBold.delete,
                                                  color: Colors.red,
                                                  size: 16,
                                                ),
                                                Text(
                                                  'Delete',
                                                  style: GoogleFonts.readexPro(
                                                      color: Colors.red,
                                                      fontSize: 14),
                                                )
                                              ],
                                            ),
                                            onPressed: () => removeItem(index),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                separateItem(index),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  IconlyBold.arrow_down_2,
                                                  color: Colors.green,
                                                  size: 24,
                                                ),
                                                Text(
                                                  'Separate',
                                                  style: GoogleFonts.readexPro(
                                                      color: Colors.green,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: Container(
                          height: MediaQuery.sizeOf(context).height,
                          child: Center(
                            child: Text(
                              'No food scanned.\nUse the Add button to manually Add',
                              style: GoogleFonts.readexPro(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          Positioned(
            bottom: 15,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xff4b39ef),
                        foregroundColor: Colors.white,
                        elevation: 5,
                      ),
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              if (foodItems.isNotEmpty) {
                                await _confirmAndSendToFirebase();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      elevation: 3,
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: Colors.red,
                                      content: Text('No Food to add')),
                                );
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            },
                      child: Text('Confirm'),
                    ),
                    ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 16, 150, 34),
                        foregroundColor: Colors.white,
                        elevation: 5,
                      ),
                      child: Text('Add', style: GoogleFonts.readexPro()),
                      onPressed: () {
                        // Declare the search controller and filtered items outside the bottom sheet
                        TextEditingController searchController =
                            TextEditingController();
                        List<String> filteredItems = itemMacronutrients.keys
                            .toList(); // Initial list of items

                        // Open the bottom sheet with a search bar
                        showCupertinoModalPopup(
                          context: _scaffoldKey.currentContext!,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Center(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    child: CupertinoActionSheet(
                                      title: Text('Select an item to add'),
                                      message: CupertinoSearchTextField(
                                        controller: searchController,
                                        itemSize: 30,
                                        placeholder: 'Search',
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        onChanged: (query) {
                                          // Update filtered items based on the search query
                                          setState(() {
                                            filteredItems = itemMacronutrients
                                                .keys
                                                .where((item) => item
                                                    .toLowerCase()
                                                    .contains(
                                                        query.toLowerCase()))
                                                .toList();
                                          });
                                        },
                                      ),
                                      actions: filteredItems.isEmpty
                                          ? [
                                              CupertinoActionSheetAction(
                                                onPressed: () {},
                                                child: Text('No items found'),
                                              ),
                                            ]
                                          : filteredItems.map((item) {
                                              return CupertinoActionSheetAction(
                                                onPressed: () {
                                                  SchedulerBinding.instance!
                                                      .addPostFrameCallback(
                                                    (_) {
                                                      Navigator.pop(context);
                                                    },
                                                  );

                                                  // Add or increment the selected item
                                                  setState(() {
                                                    // Check if item already exists in _detectedItems
                                                    final existingItemIndex =
                                                        _detectedItems
                                                            .indexWhere(
                                                                (element) =>
                                                                    element[
                                                                        'tag'] ==
                                                                    item);

                                                    if (existingItemIndex !=
                                                        -1) {
                                                      // If item already exists, increment the quantity
                                                      _detectedItems[
                                                              existingItemIndex]
                                                          [
                                                          'quantity'] = (_detectedItems[
                                                                  existingItemIndex]
                                                              [
                                                              'quantity'] as int) +
                                                          1;
                                                    } else {
                                                      // If item doesn't exist, add it with quantity 1
                                                      _detectedItems.add({
                                                        'tag': item,
                                                        'quantity': 1,
                                                      } as Map<String,
                                                          dynamic>);
                                                    }
                                                  });
                                                },
                                                child: Text(item),
                                              );
                                            }).toList(),
                                      cancelButton: CupertinoActionSheetAction(
                                        isDefaultAction: true,
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the sheet
                                        },
                                        child: Text('Cancel'),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Material(
              color: Color.fromARGB(92, 37, 37, 37),
              child: Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
