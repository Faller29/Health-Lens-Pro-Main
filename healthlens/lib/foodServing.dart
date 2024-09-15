import 'package:cloud_firestore/cloud_firestore.dart'; // Add this for Firestore
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/main.dart';
import 'package:iconly/iconly.dart';
import 'package:healthlens/entry_point.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodServing extends StatefulWidget {
  @override
  _FoodServingState createState() => _FoodServingState();
}

class _FoodServingState extends State<FoodServing> {
  List<Map<String, dynamic>> foodItems = [];
  List<Map<String, dynamic>> _detectedItems = [];
  int idNum = 1;
  bool _isLoading = false;

  int _generateUniqueId() {
    idNum++;
    return idNum; // Use timestamp as a simple unique key
  }

  // Store selected parts for each item
  Map<String, String?> selectedParts = {};

  // Macronutrient data based on the part selected for each item
  final Map<String, Map<String, Map<String, int>>> itemMacronutrients = {
    'spoon': {
      'Leg': {'fats': 5, 'carbs': 5, 'proteins': 5},
      'Wing': {'fats': 5, 'carbs': 5, 'proteins': 5},
      'Breast': {'fats': 5, 'carbs': 5, 'proteins': 5},
      'Thigh': {'fats': 5, 'carbs': 5, 'proteins': 5},
    },
    'fork': {
      'Head': {'fats': 5, 'carbs': 5, 'proteins': 5},
      'Body': {'fats': 5, 'carbs': 5, 'proteins': 5},
      'Tail': {'fats': 5, 'carbs': 5, 'proteins': 5},
    }
  };

  String removeId(String tag) {
    return tag.replaceAll(RegExp(r'\s?\d+'), '');
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
    print('item: $item');

    String itemRemovedId = '';
    itemRemovedId = removeId(item);
    print(itemRemovedId);
    final parts =
        itemMacronutrients[itemRemovedId.toLowerCase()]?.keys.toList() ?? [];

    if (parts.isEmpty) return SizedBox.shrink();

    return Column(
      children: [
        Text('Select part:'),
        DropdownButton<String>(
          value: selectedParts[item],
          items: parts.map((part) {
            return DropdownMenuItem<String>(
              value: part,
              child: Text(part),
            );
          }).toList(),
          onChanged: (String? selectedPart) {
            setState(() {
              selectedParts[item] = selectedPart;
              print('part: $selectedPart');
            });
          },
        ),
        if (selectedParts[itemRemovedId] != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Macronutrients:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Fats: ${itemMacronutrients[itemRemovedId.toLowerCase()]?[selectedParts[itemRemovedId]]?['fats']}g',
              ),
              Text(
                'Carbs: ${itemMacronutrients[itemRemovedId.toLowerCase()]?[selectedParts[itemRemovedId]]?['carbs']}g',
              ),
              Text(
                'Proteins: ${itemMacronutrients[itemRemovedId.toLowerCase()]?[selectedParts[itemRemovedId]]?['proteins']}g',
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
      print(foodItemsRemovedId['item']);
    });
    List<Map<String, dynamic>> wrappedItems = foodItemsRemovedId.map((item) {
      final selectedPart = selectedParts[item['item']];
      final macronutrients =
          itemMacronutrients[item['item'].toLowerCase()]?[selectedPart] ?? {};

      print(macronutrients['carbs']);
      print(macronutrients['proteins']);
      print(macronutrients['fats']);

      print(macronutrients['carbs'].runtimeType);
      print(macronutrients['proteins'].runtimeType);
      print(macronutrients['fats'].runtimeType);
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

      print('start');
      print(wrappedData);

      print(wrappedData['carbs']);
      print(wrappedData['proteins']);
      print(wrappedData['fats']);
      // Get the current date in 'yyyy-MM-dd' format
      final String currentDate = DateTime.now().toIso8601String().split('T')[0];
      print(currentDate);
      // Get the current time in 'hh:mm' format
      final String currentTime =
          "${DateTime.now().hour}:${DateTime.now().minute}";
      print('checking');
      // Check if adding the current food serving will exceed the user's max intake
      print(thisUser?.uid);
      // Check the data structure of wrappedData
      print('Wrapped Data: $wrappedData');

      // Adjust according to the actual structure
      final bool canAdd = await _checkIfWithinMaxLimits(wrappedData['items']);

      print('proceeding to add');
      if (canAdd) {
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EntryPoint()),
        );
      } else {
        // Notify user that the food exceeds their daily max intake
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('This food exceeds your daily macronutrient limits!')),
        );
      }
    } catch (e) {
      print("Error submitting data to Firebase: $e");
    }
  }

  Future<bool> _checkIfWithinMaxLimits(
      List<Map<String, dynamic>> newMacrosList) async {
    try {
      // Retrieve the user's maximum macronutrient limits
      final userMaxDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(thisUser?.uid)
          .get();

      if (!userMaxDoc.exists || userMaxDoc.data() == null) {
        print('Error: No max limits found for user or data is null.');
        return false;
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
          : {'carbs': 0, 'proteins': 0, 'fats': 0};

      final currentCarbs = _parseInt(currentMacros?['carbs']);
      final currentProteins = _parseInt(currentMacros?['proteins']);
      final currentFats = _parseInt(currentMacros?['fats']);
      print(currentMacros);
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

      // Check if adding the new macronutrients exceeds the user's max daily limits
      return totalCarbs <= maxCarbs &&
          totalProteins <= maxProteins &&
          totalFats <= maxFats;
    } catch (e) {
      print("Error checking macronutrient limits: $e");
      return false;
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
          : {'carbs': 0, 'proteins': 0, 'fats': 0};

      int totalCarbs = _parseInt(currentMacros?['carbs']);
      int totalProteins = _parseInt(currentMacros?['proteins']);
      int totalFats = _parseInt(currentMacros?['fats']);

      // Sum up macronutrients from the newMacrosList, considering quantity
      for (var item in newMacrosList) {
        final quantity = _parseInt(item['quantity']); // Get the item quantity
        totalCarbs += _parseInt(item['carbs']) * quantity;
        totalProteins += _parseInt(item['proteins']) * quantity;
        totalFats += _parseInt(item['fats']) * quantity;
      }

      // Update user macros document in Firebase
      await FirebaseFirestore.instance
          .collection('userMacros')
          .doc(thisUser?.uid)
          .set({
        'carbs': totalCarbs,
        'proteins': totalProteins,
        'fats': totalFats,
      }, SetOptions(merge: true));

      // Update SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('dailyCarbs', totalCarbs);
      await prefs.setInt('dailyProtein', totalProteins);
      await prefs.setInt('dailyFats', totalFats);

      dailyCarbs = prefs.getInt('dailyCarbs') ?? 0;
      dailyProtein = prefs.getInt('dailyProtein') ?? 0;
      dailyFats = prefs.getInt('dailyFats') ?? 0;

      final thisUserUid = thisUser?.uid;
      final String currentDate = DateTime.now().toIso8601String().split('T')[0];
      final dailyUserMacros = db
          .collection("userMacros")
          .doc(thisUserUid)
          .collection('MacrosIntakeHistory')
          .doc(currentDate);
      await dailyUserMacros.set({
        'carbs': dailyCarbs,
        'fats': dailyFats,
        'proteins': dailyProtein,
      });

      print('User macros updated successfully.');
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
        'tag': "${originalItem['tag']} ${id.toString()}",
        'quantity': newQuantity,
      };

      final separatedFoodItem = {
        'item': "${originalItem['tag']} ${id.toString()}",
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
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      final item = foodItems[index]['item'];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            isThreeLine: true,
                            leading: Icon(Icons.restaurant_menu_outlined),
                            title: Text(item),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildItemOptions(item),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                          Icons.remove_circle_outline),
                                      onPressed: () => decreaseQuantity(index),
                                    ),
                                    Text('${foodItems[index]['quantity']}'),
                                    IconButton(
                                      icon:
                                          const Icon(Icons.add_circle_outline),
                                      onPressed: () => increaseQuantity(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(IconlyLight.delete),
                                      onPressed: () => removeItem(index),
                                    ),
                                    TextButton(
                                      onPressed: () => separateItem(index),
                                      child: Text('separate'),
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
                          backgroundColor: Color.fromARGB(255, 57, 239, 81),
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Add'),
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
