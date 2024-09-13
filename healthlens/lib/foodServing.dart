import 'package:healthlens/camerapage.dart';
import 'package:healthlens/entry_point.dart';
import 'package:healthlens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class FoodServing extends StatefulWidget {
  @override
  _FoodServingState createState() => _FoodServingState();
}

class _FoodServingState extends State<FoodServing> {
  List<Map<String, dynamic>> foodItems = [];
  List<Map<String, dynamic>> _detectedItems = [];

  @override
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
      // Safely cast quantity to int
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
        foodItems.removeAt(index);
      }
    });
  }

  void increaseQuantity(int index) {
    setState(() {
      foodItems[index]['quantity']++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (foodItems[index]['quantity'] > 0) {
        foodItems[index]['quantity']--;
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  final item = foodItems[index];
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
                        title: Text(item['item']),
                        subtitle: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => decreaseQuantity(index),
                                ),
                                Text('${item['quantity']}'),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => increaseQuantity(index),
                                ),
                                IconButton(
                                  icon: const Icon(IconlyLight.delete),
                                  onPressed: () => removeItem(index),
                                ),
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
            SizedBox(height: 5.0),
            ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xff4b39ef),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Handle confirmation here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EntryPoint()),
                );
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
