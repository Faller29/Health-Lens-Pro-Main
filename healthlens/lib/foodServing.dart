import 'package:flutter/material.dart';
import 'package:healthlens/camerapage.dart';
import 'package:healthlens/entry_point.dart';
import 'package:healthlens/homepage.dart';
import 'package:iconly/iconly.dart';

class FoodServing extends StatefulWidget {
  @override
  _FoodServingState createState() => _FoodServingState();
}

class _FoodServingState extends State<FoodServing> {
  List<Map<String, dynamic>> foodItems = [
    {'item': 'Item 1', 'quantity': 10},
    {'item': 'Item 2', 'quantity': 3},
    {'item': 'Item 2', 'quantity': 3},

    {'item': 'Item 2', 'quantity': 3},

    {'item': 'Item 2', 'quantity': 3},

    {'item': 'Item 2', 'quantity': 3},

    {'item': 'Item 2', 'quantity': 3},

    {'item': 'Item 2', 'quantity': 3},

    // Add more items with desired quantities
  ];

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
    return Center(
      child: Card(
        color: Colors.white,
        elevation: 50,
        margin: const EdgeInsets.fromLTRB(20, 150, 20, 150),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Food Serving',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: Colors.black,
                indent: 50,
                endIndent: 50,
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  itemCount: foodItems.length,
                  itemBuilder: (context, index) {
                    final item = foodItems[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10,
                          5), // Adjust the vertical padding as needed
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
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
              SizedBox(height: 5.0), // Add a SizedBox at the bottom for spacing
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
      ),
    );
  }
}
