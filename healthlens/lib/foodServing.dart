import 'package:cloud_firestore/cloud_firestore.dart'; // Add this for Firestore
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/main.dart';
import 'package:iconly/iconly.dart';
import 'package:healthlens/entry_point.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'backend_firebase/foodExchange.dart';

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
      if (foodItems[index]['quantity'] > 0) {
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
    if (selectedParts[itemRemovedId] == null && parts.isNotEmpty) {
      selectedParts[itemRemovedId] = parts.first;
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Builder(
              builder: (context) {
                if (itemRemovedId.contains('Egg') ||
                    itemRemovedId.contains('Bread')) {
                  return Text('Type:', style: GoogleFonts.readexPro());
                } else if (itemRemovedId.contains('Rice') ||
                    itemRemovedId.contains('Potato') ||
                    itemRemovedId.contains('Onion') ||
                    itemRemovedId.contains('Onion') ||
                    itemRemovedId.contains('Pork (Lechon Kawali)') ||
                    itemRemovedId.contains('Chicken (Adobong Iga)')) {
                  return Text('Serving Size:', style: GoogleFonts.readexPro());
                } else if (itemRemovedId.contains('Pork (Breaded Pork Chop)') ||
                    itemRemovedId.contains('Fish (Daing na Bangus)')) {
                  return Text('Slice:', style: GoogleFonts.readexPro());
                } else {
                  return Text('Select part:', style: GoogleFonts.readexPro());
                }
              },
            ),
            SizedBox(
              width: 20,
            ),
            DropdownButton<String>(
              dropdownColor: Colors.white,
              value: selectedParts[itemRemovedId],
              items: parts.map((part) {
                return DropdownMenuItem<String>(
                  value: part,
                  child: Text(part, style: GoogleFonts.readexPro(fontSize: 14)),
                );
              }).toList(),
              onChanged: (String? selectedPart) {
                setState(() {
                  selectedParts[itemRemovedId] = selectedPart;
                });
              },
            ),
          ],
        ),
        if (selectedParts[itemRemovedId] != null)
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
                    'Fats: ${itemMacronutrients[itemRemovedId]?[selectedParts[itemRemovedId]]?['fats']}g',
                    style: GoogleFonts.readexPro(
                      textStyle: TextStyle(
                        color: const Color(0xff249689),
                      ),
                    ),
                  ),
                  Text(
                    'Carbs: ${itemMacronutrients[itemRemovedId]?[selectedParts[itemRemovedId]]?['carbs']}g',
                    style: GoogleFonts.readexPro(
                      textStyle: TextStyle(
                        color: const Color(0xff4b39ef),
                      ),
                    ),
                  ),
                  Text(
                    'Proteins: ${itemMacronutrients[itemRemovedId]?[selectedParts[itemRemovedId]]?['proteins']}g',
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
    List<Map<String, dynamic>> foodItemsRemovedId;
    foodItemsRemovedId = foodItems;
    foodItemsRemovedId.forEach((foodItemsRemovedId) {
      foodItemsRemovedId['item'] =
          removeId(foodItemsRemovedId['item'] as String);
    });
    List<Map<String, dynamic>> wrappedItems = foodItemsRemovedId.map((item) {
      final selectedPart = selectedParts[item['item']];
      final macronutrients =
          itemMacronutrients[item['item']]?[selectedPart] ?? {};

      return {
        'item': item['item'],
        'quantity': item['quantity'],
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
          builder: (BuildContext context) {
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
                "You have reached your recommended daily macronutrients and You are only allowed to exceed upto 20%.\n\nDo you want to Continue?",
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            behavior: SnackBarBehavior.floating,
                            elevation: 3,
                            duration: const Duration(seconds: 2),
                            content: Text('Processing....')),
                      );

                      Navigator.of(context).pop();
                      await FirebaseFirestore.instance
                          .collection('food_history')
                          .doc(thisUser?.uid)
                          .collection(currentDate)
                          .doc(currentTime)
                          .set(wrappedData); // Store the data

                      // Now accumulate the macronutrients
                      await _updateUserMacros(wrappedData['items']);

                      setState(() {
                        _firstPress = true;
                      });
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          behavior: SnackBarBehavior.floating,
                          elevation: 3,
                          duration: const Duration(seconds: 2),
                          content: Text(
                              'This food exceeds your daily macronutrient limits!')),
                    );
                    Navigator.of(context).pop(); // Close dialog
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
      Navigator.of(context).pop();
    } catch (e) {
      print('Error updating user macros: $e');
    }
  }

  void separateItem(int index) {
    setState(() {
      final originalItem = _detectedItems[index];
      final newQuantity = 1; // Default quantity for the separated part

      int id = _generateUniqueId();
      // Create a new entry for the separated item
      final separatedItem = {
        'tag': "${originalItem['tag']}${id.toString()}",
        'quantity': newQuantity,
      };
      final separatedFoodItem = {
        'item': "${originalItem['tag']}${id.toString()}",
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
      appBar: AppBar(
        title: Text('Food Serving', style: GoogleFonts.readexPro(fontSize: 18)),
        backgroundColor: Color(0xff4b39ef),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (foodItems.isNotEmpty)
                    ? Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                    side: BorderSide(
                                        color: const Color.fromARGB(
                                            255, 95, 95, 95),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  isThreeLine: true,
                                  leading: Icon(Icons.restaurant_menu_outlined),
                                  title: Text(
                                    item,
                                    style: GoogleFonts.readexPro(
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildItemOptions(item),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.remove_circle_outline),
                                            onPressed: () =>
                                                decreaseQuantity(index),
                                          ),
                                          Text(
                                              '${foodItems[index]['quantity']}'),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.add_circle_outline),
                                            onPressed: () =>
                                                increaseQuantity(index),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              IconlyLight.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () => removeItem(index),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                separateItem(index),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.arrow_downward_outlined,
                                                  size: 15,
                                                ),
                                                Text(
                                                  'Separate',
                                                  style: GoogleFonts.readexPro(
                                                      fontSize: 13),
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
                    : Container(
                        height: (MediaQuery.sizeOf(context).height - 210),
                        child: Center(
                          child: Text(
                            'No food scanned.\nUse the Add button to manually Add',
                            style: GoogleFonts.readexPro(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xff4b39ef),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                await _confirmAndSendToFirebase();
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
                        ),
                        child: Text('Add', style: GoogleFonts.readexPro()),
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoActionSheet(
                                title: Text('Select an item to add'),
                                actions: itemMacronutrients.keys.map((item) {
                                  return CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        // Check if item already exists in _detectedItems

                                        final existingItemIndex =
                                            _detectedItems.indexWhere(
                                          (element) => element['tag'] == item,
                                        );

                                        if (existingItemIndex != -1) {
                                          // If item already exists, increment the quantity
                                          _detectedItems[existingItemIndex]
                                                  ['quantity'] =
                                              (_detectedItems[existingItemIndex]
                                                      ['quantity'] as int) +
                                                  1;
                                        } else {
                                          // If item doesn't exist, add it with quantity 1
                                          _detectedItems.add({
                                            'tag': item,
                                            'quantity': 1,
                                          } as Map<String, dynamic>);
                                        }
                                      });
                                    },
                                    child: Text(item),
                                  );
                                }).toList(),
                                cancelButton: CupertinoActionSheetAction(
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
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
