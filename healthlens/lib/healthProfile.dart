import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crea_radio_button/crea_radio_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:healthlens/backend_firebase/signUp.dart';
import 'package:healthlens/entry_point.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:firebase_storage/firebase_storage.dart';

class healthProfile extends StatefulWidget {
  const healthProfile({super.key});

  @override
  State<healthProfile> createState() => _healthProfile();
}

class _healthProfile extends State<healthProfile> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  double? thisWeight, thisHeight;
  // Controllers for the form fields
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String? lifeStyle;
  List<String> chronicDisease = [];
  List<Map> categories = [
    {"name": "Diabetes [Type 1 & 2]", "isChecked": false},
    {"name": "Hypertension", "isChecked": false},
    {"name": "Obesity", "isChecked": false},
  ];
  int heightHere = height!.toInt();
  int weightHere = weight!.toInt();

  @override
  void initState() {
    super.initState();
    _heightController.text = heightHere.toString();
    _weightController.text = weightHere.toString();

    _loadChronicDiseasesFromFirestore();
  }

  int getPreSelectedIndex(String lifestyle) {
    switch (lifestyle) {
      case "Sedentary":
        return 0;
      case "Light":
        return 1;
      case "Moderate":
        return 2;
      case "Vigorous":
        return 3;
      default:
        return 0; // Default to first option if not found
    }
  }

  Future<void> fetchPhysicalLifestyle() async {
    String userId = thisUser!.uid;
    print(userId);
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('user').doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        lifestyle = userDoc.get('lifestyle');
        print('this' + lifestyle!);
      });
    }
  }

  Future<void> _loadChronicDiseasesFromFirestore() async {
    String userId = thisUser!.uid;

    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('user').doc(userId).get();

      // Assume the chronic diseases are stored as a list in Firestore
      List<dynamic> fetchedDiseases = userDoc.get('chronicDisease');

      setState(() {
        chronicDisease = List<String>.from(fetchedDiseases);

        // Update the checkbox list based on the fetched data
        for (var category in categories) {
          if (chronicDisease.contains(category['name'])) {
            category['isChecked'] = true;
          }
        }
      });
    } catch (e) {
      print('Error fetching chronic diseases: $e');
    }
  }

  void getCheckedDiseases() {
    chronicDisease = categories
        .where((disease) => disease['isChecked'] == true)
        .map((disease) => disease['name'].toString())
        .toList();
    // Save the updated diseases list to Firestore if needed
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();

    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        thisHeight = double.parse(_heightController.text);
        thisWeight = double.parse(_weightController.text);
      });

      // Update Firestore with profile information
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        desiredBodyWeight = desiredBW(thisHeight!);
        double? doubleWeight = thisWeight;
        String strWeight = doubleWeight!.toStringAsFixed(0);
        int intWeight = int.parse(strWeight);

        //getting the bmi
        double bodyMass = (intWeight / pow(height! / 100, 2));
        String roundedString = bodyMass.toStringAsFixed(1);
        double totalBMI = double.parse(roundedString);
        String bmi;

        if (totalBMI < 18.5) {
          bmi = 'Underweight';
        } else if (totalBMI >= 18.5 && totalBMI <= 24.9) {
          bmi = 'Normal';
        } else if (totalBMI >= 25.0 && totalBMI <= 29.9) {
          bmi = 'Pre-obesity';
        } else if (totalBMI >= 30.0 && totalBMI <= 34.9) {
          bmi = 'Obesity Class 1';
        } else if (totalBMI >= 35.0 && totalBMI <= 39.9) {
          bmi = 'Obesity Class 2';
        } else {
          bmi = 'Obesity Class 3';
        }

        int PA;
        //getting TER
        switch (lifestyle) {
          case 'Sedentary':
            PA = 30;
            break;
          case 'Light':
            PA = 35;
            break;
          case 'Moderate':
            PA = 40;
            break;
          case 'Vigorous':
            PA = 45;
            break;
          default:
            PA = 0;
        }
        print('object');
        double thisTER = (desiredBodyWeight! * PA);
        print(thisTER);

        String strThisTER = thisTER.toStringAsFixed(0);
        int intTER = int.parse(strThisTER);
        TER = roundUp50s(intTER);
        print(TER);

        int carbs = 0, protein = 0, fats = 0;
        double doubleCarbs = 0, doubleProtein = 0, doubleFats = 0;

        //required TER per chronic disease
        if (chronicDisease.length == 1 &&
            chronicDisease.contains('Hypertension')) {
          carbs = (TER! * 0.60).round();
          protein = (TER! * 0.15).round();
          fats = (TER! * 0.25).round();
        } else if (chronicDisease.length == 2 &&
            chronicDisease.contains('Obesity') &&
            chronicDisease.contains('Hypertension')) {
          carbs = (TER! * 0.65).round();
          protein = (TER! * 0.15).round();
          fats = (TER! * 0.20).round();
        } else if (chronicDisease.isEmpty) {
          carbs = (TER! * 0.60).round();
          protein = (TER! * 0.15).round();
          fats = (TER! * 0.25).round();
        } else {
          carbs = (TER! * 0.55).round();
          protein = (TER! * 0.20).round();
          fats = (TER! * 0.25).round();
        }

        //required daily grams of macronutrients

        doubleCarbs = carbs / 4;
        doubleFats = fats / 9;
        doubleProtein = protein / 4;

        //parsing double to interget no need to pay attention
        String strCarbs = doubleCarbs.toStringAsFixed(0);
        String strProtein = doubleProtein.toStringAsFixed(0);
        String strFats = doubleFats.toStringAsFixed(0);
        int gCarbs = int.parse(strCarbs);
        int gFats = int.parse(strFats);
        int gProtein = int.parse(strProtein);
        gCarbs = roundUp5s(gCarbs);
        gProtein = roundUp5s(gProtein);
        gFats = roundUp5s(gFats);

        final String userId = thisUser!.uid;

        await FirebaseFirestore.instance.collection('user').doc(userId).update({
          'bmi': bmi,
          'TER': TER,
          'physicalActivity': PA,
          'reqCarbs': carbs,
          'reqProtein': protein,
          'reqFats': fats,
          'gramCarbs': gCarbs,
          'gramProtein': gProtein,
          'gramFats': gFats,
          'desiredBodyWeight': desiredBodyWeight,
          'lifestyle': lifestyle,
          'height': double.parse(_heightController.text),
          'weight': double.parse(_weightController.text),
          'chronicDisease': chronicDisease,
        });
        print('lifestyle' + lifestyle!);
        await prefs.setStringList(
            'chronicDisease', chronicDisease.cast<String>());
        await prefs.setDouble('desiredBW', desiredBodyWeight!);
        await prefs.setInt('gramCarbs', gCarbs);
        await prefs.setInt('gramProtein', gProtein);
        await prefs.setInt('gramFats', gFats);
        await prefs.setString('lifestyle', lifestyle!);
        await prefs.setString('userBMI', bmi);
        await prefs.setInt('TER', TER!);
        await prefs.setDouble('height', double.parse(_heightController.text));
        await prefs.setDouble('weight', double.parse(_weightController.text));

        saveData();
        Navigator.of(context).pop();

        // Show success message for Firestore update
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              elevation: 3,
              duration: const Duration(seconds: 2),
              content: Text('Profile updated successfully in Firestore!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              elevation: 3,
              duration: const Duration(seconds: 2),
              content: Text('Error updating profile in Firestore: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: GoogleFonts.readexPro(fontSize: 18)),
        backgroundColor: Color(0xff4b39ef),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Height',
                  labelStyle: GoogleFonts.readexPro(fontSize: 16),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weight',
                  labelStyle: GoogleFonts.readexPro(fontSize: 16),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Material(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'Chronic Disease:',
                          style: GoogleFonts.readexPro(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: categories.map((disease) {
                            return CheckboxListTile(
                              title: Text(disease['name']),
                              checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              value: disease['isChecked'],
                              onChanged: (val) {
                                setState(() {
                                  disease['isChecked'] = val;
                                  getCheckedDiseases();
                                  print(
                                      '${disease['name']} isChecked: ${disease['isChecked']}');
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Material(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                        'Physical Lifestyle: ',
                        style: GoogleFonts.readexPro(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    RadioButtonGroup(
                        multilineNumber: 2,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spaceBetween: 1,
                        betweenMultiLines: 10,
                        buttonHeight: 30,
                        buttonWidth: 115,
                        circular: true,
                        textStyle: TextStyle(fontSize: 14, color: Colors.white),
                        mainColor: Colors.grey,
                        selectedColor: Color(0xff4b39ef),
                        selectedBorderSide:
                            BorderSide(width: 1, color: Color(0xff4b39ef)),
                        preSelectedIdx: lifestyle != null
                            ? getPreSelectedIndex(lifestyle!)
                            : 0,
                        options: [
                          RadioOption("SEDENTARY", "Sedentary"),
                          RadioOption("LIGHT", "Light"),
                          RadioOption("MODERATE", "Moderate"),
                          RadioOption("VIGOROUS", "Vigorous"),
                        ],
                        callback: (RadioOption val) {
                          setState(() {
                            lifestyle = val.label;
                            print(val.label);
                            print(lifestyle);
                          });
                        }),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Color(0xff4b39ef),
                ),
                child: Text(
                  'Save',
                  style: GoogleFonts.readexPro(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}