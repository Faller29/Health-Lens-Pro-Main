import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crea_radio_button/crea_radio_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  // Controllers for the form fields
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _mNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? lifeStyle;
  List<String> chronicDisease = [];
  List<Map> categories = [
    {"name": "Diabetes [Type 1 & 2]", "isChecked": false},
    {"name": "Hypertension", "isChecked": false},
    {"name": "Obesity", "isChecked": false},
  ];
  @override
  void initState() {
    super.initState();
    _fNameController.text = firstName!;
    _mNameController.text = middleName!;
    _lNameController.text = lastName!;
    _ageController.text = age.toString();
    _loadChronicDiseasesFromFirestore();
    fetchPhysicalLifestyle();
  }

  int getPreSelectedIndex(String lifeStyle) {
    switch (lifeStyle) {
      case "Sedentary":
        print('0S');
        return 0;
      case "Light":
        print('1S');

        return 1;
      case "Moderate":
        print('2S');

        return 2;
      case "Vigorous":
        print('3S');

        return 3;
      default:
        print('0');

        return 0; // Default to first option if not found
    }
  }

  Future<void> fetchPhysicalLifestyle() async {
    String userId = thisUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('user').doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        lifeStyle = userDoc['lifestyle'];
        print('this' + lifeStyle!);
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
    _fNameController.dispose();
    _mNameController.dispose();
    _lNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        firstName = _fNameController.text;
        middleName = _mNameController.text;
        lastName = _lNameController.text;
        age = int.parse(_ageController.text);
      });

      // Update Firestore with profile information
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        final String userId = userUid!;
        String userFullname = _fNameController.text +
            " " +
            _mNameController.text +
            " " +
            _lNameController.text;
        String initial = _mNameController.text[0].toUpperCase();

        await FirebaseFirestore.instance.collection('user').doc(userId).update({
          'fullName': userFullname,
          'firstName': _fNameController.text,
          'middleName': _mNameController.text,
          'lastName': _lNameController.text,
          'middleInitial': initial,
          'age': int.parse(_ageController.text),
          'chronicDisease': chronicDisease,
        });

        await prefs.setString('userFullName', userFullname);
        await prefs.setString('firstName', _fNameController.text);
        await prefs.setString('middleName', _mNameController.text);
        await prefs.setString('middleInitial', initial);
        await prefs.setString('lastName', _lNameController.text);
        await prefs.setInt('age', int.parse(_ageController.text));

        saveData();

        // Show success message for Firestore update
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully in Firestore!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile in Firestore: $e')),
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
              TextFormField(
                controller: _fNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: GoogleFonts.readexPro(fontSize: 16),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _mNameController,
                decoration: InputDecoration(
                  labelText: 'Middle Name',
                  labelStyle: GoogleFonts.readexPro(fontSize: 16),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your middle name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _lNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: GoogleFonts.readexPro(fontSize: 16),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
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
                        preSelectedIdx: lifeStyle != null
                            ? getPreSelectedIndex(lifeStyle!)
                            : 2,
                        options: [
                          RadioOption("SEDENTARY", "Sedentary"),
                          RadioOption("LIGHT", "Light"),
                          RadioOption("MODERATE", "Moderate"),
                          RadioOption("VIGOROUS", "Vigorous"),
                        ],
                        callback: (RadioOption val) {
                          setState(() {
                            lifeStyle = val.label;
                            print(lifeStyle);
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
