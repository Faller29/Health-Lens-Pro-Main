import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:healthlens/main.dart';
import 'package:iconly/iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  late FlutterVision _flutterVision;
  List<Map<String, dynamic>> _detections = [];
  CameraImage? _cameraImage;
  bool _isInitialized = false;
  bool _isDetecting = false;
  Timer? _detectionTimer;

  // Track the detected objects with their counts
  Map<String, int> _detectedObjectCounts = {};

  @override
  void initState() {
    super.initState();
    _flutterVision = FlutterVision();
    _initializeCameraAndModel();
  }

  Future<void> _initializeCameraAndModel() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);

    await _cameraController.initialize();
    await _flutterVision.loadYoloModel(
      labels: 'assets/labels.txt',
      modelPath: 'assets/model.tflite',
      modelVersion: 'yolov8',
      numThreads: 1,
      useGpu: true,
    );

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _flutterVision.closeYoloModel();
    super.dispose();
  }

  void _toggleDetection() {
    if (_isDetecting) {
      _stopDetection();
    } else {
      _startDetection();
    }
  }

  Future<void> _startDetection() async {
    setState(() {
      _isDetecting = true;
    });

    // Start a 10 second timer
    _detectionTimer = Timer(Duration(seconds: 10), () {
      if (_detections.isEmpty) {
        // Show a dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white.withOpacity(.8),
              shadowColor: Colors.black,
              elevation: 5,
              title: Text(
                "No food Detected",
                style: GoogleFonts.readexPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              content: Text(
                "No food detected within 10 seconds.\n\nKeep your Camera Steady and Make sure that the Food is within the Scope of the app",
                style: GoogleFonts.readexPro(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.justify,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _stopDetection(); // Stop detection when closing the dialog
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    });

    _cameraController.startImageStream((image) async {
      if (_isDetecting) {
        _cameraImage = image;
        final results = await _flutterVision.yoloOnFrame(
          bytesList: image.planes.map((plane) => plane.bytes).toList(),
          imageHeight: image.height,
          imageWidth: image.width,
          iouThreshold: 0.5,
          confThreshold: 0.6,
          classThreshold: 0.6,
        );

        if (results.isNotEmpty) {
          _detectionTimer?.cancel();
          _updateDetectedObjectCounts(results);
          setState(() {
            _detections = results;
          });
        }
      }
    });
  }

  Future<void> _stopDetection() async {
    setState(() {
      _isDetecting = false;
    });

    // Cancel the timer when detection is stopped
    _detectionTimer?.cancel();

    await _cameraController.stopImageStream();
    await Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _detections
            .clear(); // Clear detections after 1 seconds to ensure that the paint will be wiped
      });
    });
  }

  void _clearIngredients() {
    setState(() {
      _detectedObjectCounts.clear();
      _detections.clear();
    });
  }

  void _updateDetectedObjectCounts(List<Map<String, dynamic>> results) {
    final newDetectedObjectCounts = <String, int>{};

    for (var result in results) {
      final label = result['tag'];
      if (newDetectedObjectCounts.containsKey(label)) {
        newDetectedObjectCounts[label] = newDetectedObjectCounts[label]! + 1;
      } else {
        newDetectedObjectCounts[label] = 1;
      }
    }

    setState(() {
      _detectedObjectCounts.addAll(newDetectedObjectCounts);
    });
  }

  Future<void> _pauseCamera() async {
    await _cameraController.pausePreview(); // Pause the camera preview
  }

  Future<void> _resumeCamera() async {
    await _cameraController.resumePreview(); // Resume the camera preview
  }

  void _scanProduct() async {
    setState(() {
      _isDetecting = false;
      _detections.clear();
    });

    try {
      // Step 1: Trigger the flash effect for 0.5 seconds
      _triggerFlashEffect();

      // Step 2: Capture the image from the camera after the flash
      final image = await _cameraController.takePicture();

      // Step 3: Show scanning animation with captured image
      _showCapturedImageAndScanAnimation(image);

      // Process the image using Google ML Kit Text Recognition
      final inputImage = InputImage.fromFilePath(image.path);
      final textDetector = TextRecognizer();
      final recognizedText = await textDetector.processImage(inputImage);

      // Initialize macronutrient totals
      int totalCarbs = 0;
      int totalFats = 0;
      int protein = 0;

      // Regular expressions for macronutrient extraction
      final carbsPattern = RegExp(
          r'(?:(total\s*carbohydrates?)|(?:carbs?))\s*[:,]?\s*(\d+)\s*[g]?',
          caseSensitive: false);

      final fatsPattern = RegExp(r'(total\s*fats?)\s*[:,]?\s*(\d+)\s*[g]?',
          caseSensitive: false);
      final proteinPattern =
          RegExp(r'(protein)\s*[:,]?\s*(\d+)\s*[g]?', caseSensitive: false);

      // Iterate through recognized text blocks and lines
      for (TextBlock block in recognizedText.blocks) {
        print(
            "Detected block: ${block.text}"); // Print the entire block of text for debugging

        String combinedText = ''; // Variable to accumulate lines in a block
        for (TextLine line in block.lines) {
          combinedText +=
              line.text.trim() + ' '; // Combine lines into a single string

          print("Detected line: $combinedText"); // Print each detected line

          // Check for macronutrient patterns
          if (carbsPattern.hasMatch(combinedText)) {
            final match = carbsPattern.firstMatch(combinedText);
            totalCarbs = int.parse(match?.group(2) ?? '0');
            print("Carbs found: $totalCarbs"); // Print the carbs value
          }
          if (fatsPattern.hasMatch(combinedText)) {
            final match = fatsPattern.firstMatch(combinedText);
            totalFats = int.parse(match?.group(2) ?? '0');
            print("Fats found: $totalFats"); // Print the fats value
          }
          if (proteinPattern.hasMatch(combinedText)) {
            final match = proteinPattern.firstMatch(combinedText);
            protein = int.parse(match?.group(2) ?? '0');
            print("Protein found: $protein"); // Print the protein value
          }
        }
      }

      // Close scanning animation
      Navigator.of(context).pop(); // Close scanning animation dialog

      // Step 4: Show the results or "Nothing Detected"
      if (totalCarbs == 0 && totalFats == 0 && protein == 0) {
        _showNoContentDetected();
      } else {
        _showNutritionDialog(totalCarbs, totalFats, protein);
      }

      // Close the text detector to release resources
      textDetector.close();
    } catch (e) {
      print('Error scanning product: $e');
    }
  }

  // Trigger flash effect for 0.5 seconds
  void _triggerFlashEffect() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing flash
      builder: (BuildContext context) {
        return FlashOverlay();
      },
    );

    // Remove the flash effect after 0.5 seconds
    Future.delayed(Duration(milliseconds: 100), () {
      Navigator.of(context).pop(); // Close flash effect
    });
  }

// Show captured image with scanning animation
  void _showCapturedImageAndScanAnimation(XFile image) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal during scanning
      builder: (BuildContext context) {
        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Wrap the image in a container with a green border
              Container(
                width: 250, // Adjust the size as needed
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.greenAccent, width: 4), // Green border
                ),
                child: Image.file(
                  File(image.path),
                  fit: BoxFit.cover,
                ),
              ),
              // Scanning animation - a moving line
              Positioned.fill(
                child: AnimatedScannerLine(),
              ),
            ],
          ),
        );
      },
    );
  }

// Show dialog if no content detected
  void _showNoContentDetected() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(15),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          title: Text(
            'No Data Found',
            style: GoogleFonts.readexPro(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'No macronutrients Detected from the image of Nutrition Facts.\n\nPlease try again with a clearer image or Manually add the Nutrition Facts.',
            style: GoogleFonts.readexPro(fontSize: 14),
            textAlign: TextAlign.justify,
          ),
          actionsAlignment: MainAxisAlignment.end,
          actionsPadding: EdgeInsets.fromLTRB(0, 0, 10, 10),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close',
                  style: GoogleFonts.readexPro(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  )),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.of(context).pop();

                _showNutritionDialog(0, 0, 0);
              },
              child: Text(
                'Manually Add',
                style: GoogleFonts.readexPro(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNutritionDialog(
      int initialCarbs, int initialFats, int initialProtein) {
    // Macronutrient values tracked separately
    int currentCarbs = initialCarbs;
    int currentFats = initialFats;
    int currentProtein = initialProtein;

    // Serving size and quantity variables
    int quantity = 1;
    String selectedServingSize = '1 cup/piece';
    Map<String, double> servingSizeMultipliers = {
      '1 cup/piece': 1.0,
      '1/2 cup/piece': 0.5,
    };

    // Controllers for adjusting the macros and displaying them
    TextEditingController productNameController =
        TextEditingController(text: "Scanned Product");
    TextEditingController carbsController =
        TextEditingController(text: currentCarbs.toString());
    TextEditingController fatsController =
        TextEditingController(text: currentFats.toString());
    TextEditingController proteinController =
        TextEditingController(text: currentProtein.toString());

    // Calculate total macros based on current quantity and serving size
    void updateMacros() {
      double servingMultiplier = servingSizeMultipliers[selectedServingSize]!;
      carbsController.text =
          ((currentCarbs * servingMultiplier) * quantity).toStringAsFixed(0);
      fatsController.text =
          ((currentFats * servingMultiplier) * quantity).toStringAsFixed(0);
      proteinController.text =
          ((currentProtein * servingMultiplier) * quantity).toStringAsFixed(0);
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Card(
              elevation: 5,
              margin: EdgeInsets.fromLTRB(10, 60, 10, 60),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                'Nutritional Facts Scanned',
                                style: GoogleFonts.readexPro(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: productNameController,
                              style: GoogleFonts.readexPro(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                              decoration: InputDecoration(
                                labelText: 'Product Name',
                                isDense: true,
                                labelStyle: GoogleFonts.readexPro(fontSize: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),

                            // Macronutrient adjustment fields with add/remove buttons
                            Text(
                              'Total Carbohydrates (g):',
                              style: GoogleFonts.readexPro(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      if (currentCarbs > 0) {
                                        currentCarbs--; // Decrement carbs
                                        updateMacros(); // Update displayed values
                                      }
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 150,
                                  child: TextField(
                                    controller: carbsController,
                                    readOnly: true,
                                    style: GoogleFonts.readexPro(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      isDense: true,
                                      labelStyle:
                                          GoogleFonts.readexPro(fontSize: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      currentCarbs++; // Increment carbs
                                      updateMacros(); // Update displayed values
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            Text(
                              'Total Fats (g):',
                              style: GoogleFonts.readexPro(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      if (currentFats > 0) {
                                        currentFats--; // Decrement fats
                                        updateMacros(); // Update displayed values
                                      }
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 150,
                                  child: SizedBox(
                                    width: 150,
                                    child: TextField(
                                      controller: fatsController,
                                      readOnly: true,
                                      style: GoogleFonts.readexPro(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        isDense: true,
                                        labelStyle:
                                            GoogleFonts.readexPro(fontSize: 10),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      currentFats++; // Increment fats
                                      updateMacros(); // Update displayed values
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            Text(
                              'Total Protein (g):',
                              style: GoogleFonts.readexPro(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      if (currentProtein > 0) {
                                        currentProtein--; // Decrement protein
                                        updateMacros(); // Update displayed values
                                      }
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 150,
                                  child: TextField(
                                    controller: proteinController,
                                    readOnly: true,
                                    style: GoogleFonts.readexPro(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      isDense: true,
                                      labelStyle:
                                          GoogleFonts.readexPro(fontSize: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      currentProtein++; // Increment protein
                                      updateMacros(); // Update displayed values
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            // Quantity adjustment
                            Text(
                              'Quantity:',
                              style: GoogleFonts.readexPro(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      if (quantity > 1) {
                                        quantity--;
                                        updateMacros(); // Update macros based on new quantity
                                      }
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 150,
                                  child: TextField(
                                    readOnly: true,
                                    style: GoogleFonts.readexPro(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      isDense: true,
                                      labelStyle:
                                          GoogleFonts.readexPro(fontSize: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      hintText: quantity.toString(),
                                      hintStyle: GoogleFonts.readexPro(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                      updateMacros(); // Update macros based on new quantity
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            // Serving size dropdown
                            Row(
                              children: [
                                Text(
                                  'Serving Size: ',
                                  style: GoogleFonts.readexPro(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                DropdownButton<String>(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  elevation: 3,
                                  borderRadius: BorderRadius.circular(20),
                                  style: GoogleFonts.readexPro(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  alignment: Alignment.center,
                                  value: selectedServingSize,
                                  items: servingSizeMultipliers.keys
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedServingSize = newValue!;
                                      updateMacros(); // Update macros based on new serving size
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Action buttons

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              Navigator.of(context).pop(); // Cancel button
                            },
                            child: Text('Cancel',
                                style: GoogleFonts.readexPro(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: Text('Confirm',
                                style: GoogleFonts.readexPro(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              // Show loader
                              showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // Prevent dismissing the loader by tapping outside
                                builder: (BuildContext context) {
                                  return Center(
                                    child:
                                        CircularProgressIndicator(), // Loader widget
                                  );
                                },
                              );

                              List<Map<String, dynamic>> wrappedItems = [
                                {
                                  'item': productNameController
                                      .text, // Replace with the actual product name
                                  'quantity':
                                      quantity, // This is the quantity from your dialog
                                  'part':
                                      selectedServingSize, // This is the serving size from your dialog
                                  'fats': _parseInt(double.parse(fatsController
                                      .text)), // Parse and convert to int
                                  'carbs': _parseInt(double.parse(
                                      carbsController
                                          .text)), // Parse and convert to int
                                  'proteins': _parseInt(double.parse(
                                      proteinController
                                          .text)), // Parse and convert to int
                                }
                              ];

                              // Get current date and time
                              final String currentDate = DateTime.now()
                                  .toIso8601String()
                                  .split('T')[0];
                              final String currentTime =
                                  "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";

                              print('wowers');
                              // Retrieve existing macro values from Firestore
                              final DocumentSnapshot userMacrosSnapshot =
                                  await FirebaseFirestore.instance
                                      .collection('userMacros')
                                      .doc(thisUser?.uid)
                                      .get();

                              // Initialize current macro values
                              print(thisUser?.uid);
                              print('wowers1');

                              // Check if the document exists and retrieve current macro values
                              final data = userMacrosSnapshot.data()
                                  as Map<String, dynamic>;
                              print('wowers1.1');

                              final thiscurrentCarbs = (data['carbs'] ?? 0);
                              final thiscurrentFats = (data['fats'] ?? 0);
                              final thiscurrentProtein =
                                  (data['proteins'] ?? 0);
                              final thiscurrentCalories =
                                  (data['calories'] ?? 0);
                              print('wowers1.2');

                              int currentCarbs = thiscurrentCarbs;
                              int currentFats = thiscurrentFats;
                              int currentProtein = thiscurrentProtein;
                              int currentCalories = thiscurrentCalories;
                              print('wowers2');

                              // Assuming these are the initial macro values you retrieved or calculated
                              int initialCarbs =
                                  _parseInt(double.parse(carbsController.text));
                              int initialFats =
                                  _parseInt(double.parse(fatsController.text));
                              int initialProtein = _parseInt(
                                  double.parse(proteinController.text));
                              // Retrieve max macros from Firestore
                              final userMaxDoc = await FirebaseFirestore
                                  .instance
                                  .collection('user')
                                  .doc(thisUser?.uid)
                                  .get();
                              print('get?');
                              final userMaxData = userMaxDoc.data()!;
                              print('sure?');
                              // Convert the values to double
                              double maxCarbs =
                                  (userMaxData['gramCarbs'] as num).toDouble();
                              double maxProteins =
                                  (userMaxData['gramProtein'] as num)
                                      .toDouble();
                              double maxFats =
                                  (userMaxData['gramFats'] as num).toDouble();
                              print('all right');
                              // Add 20%
                              double adjustedMaxCarbs =
                                  maxCarbs + (maxCarbs * 0.20);
                              double adjustedMaxProteins =
                                  maxProteins + (maxProteins * 0.20);
                              double adjustedMaxFats =
                                  maxFats + (maxFats * 0.20);

                              print('wowers3');
                              // Calculate final macros based on quantity
                              int finalCarbs =
                                  currentCarbs + (initialCarbs * quantity);
                              int finalFats =
                                  currentFats + (initialFats * quantity);
                              int finalProtein =
                                  currentProtein + (initialProtein * quantity);
                              print((finalFats >= adjustedMaxFats &&
                                  finalCarbs >= adjustedMaxCarbs &&
                                  finalProtein >= adjustedMaxProteins));

                              if (finalFats >= adjustedMaxFats &&
                                  finalCarbs >= adjustedMaxCarbs &&
                                  finalProtein >= adjustedMaxProteins) {
                                Navigator.of(context).pop();

                                Navigator.of(context).pop();
                                return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Warning'),
                                      content: Text(
                                        "You have reached your maximum recommended daily macronutrients intake",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              print('wowers4');
                              // Calculate total calories
                              int calories = currentCalories +
                                  (((initialCarbs * quantity) * 4) +
                                      ((initialFats * quantity) * 9) +
                                      ((initialProtein * quantity) * 4));
                              print(finalFats);
                              print('wowers5');
                              // Save data to userMacros collection
                              await FirebaseFirestore.instance
                                  .collection('userMacros')
                                  .doc(thisUser?.uid)
                                  .set(
                                {
                                  'carbs': finalCarbs,
                                  'fats': finalFats,
                                  'proteins': finalProtein,
                                  'calories': calories,
                                  'lastLogIn':
                                      currentDate, // Update the last login date
                                },
                                SetOptions(merge: true),
                              ); // Merge to prevent overwriting

                              print('wowers6');
                              // Save data to MacrosIntakeHistory collection
                              await FirebaseFirestore.instance
                                  .collection("userMacros")
                                  .doc(thisUser?.uid)
                                  .collection('MacrosIntakeHistory')
                                  .doc(currentDate)
                                  .set({
                                'carbs': finalCarbs,
                                'fats': finalFats,
                                'proteins': finalProtein,
                                'calories': calories,
                              }, SetOptions(merge: true));

                              print('wowers7');
                              // Save food history
                              await FirebaseFirestore.instance
                                  .collection('food_history')
                                  .doc(thisUser?.uid)
                                  .collection(currentDate)
                                  .doc(currentTime)
                                  .set({
                                'items':
                                    wrappedItems, // Make sure wrappedItems is defined in scope
                                'timestamp': DateTime.now()
                                    .toIso8601String(), // Add timestamp
                                'userId': thisUser?.uid, // Add user ID
                              });

                              dailyCarbs = finalCarbs;
                              dailyFats = finalFats;
                              dailyProtein = finalProtein;
                              dailyCalories = calories;
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              await prefs.setInt('dailyCarbs', dailyCarbs!);
                              await prefs.setInt('dailyProtein', dailyProtein!);
                              await prefs.setInt('dailyFats', dailyFats!);
                              await prefs.setInt(
                                  'dailyCalories', dailyCalories!);
                              Navigator.of(context).pop(); // Confirm button

                              // Show success snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text('Success!'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              Navigator.of(context).pop(); // Confirm button
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

/* 
  void _showNutritionDialog(
      int initialCarbs, int initialFats, int initialProtein) {
    // Create a TextEditingController for the product name
    TextEditingController productNameController =
        TextEditingController(text: "Scanned Product");

    // Create controllers for adjusting the macros
    TextEditingController carbsController =
        TextEditingController(text: initialCarbs.toString());
    TextEditingController fatsController =
        TextEditingController(text: initialFats.toString());
    TextEditingController proteinController =
        TextEditingController(text: initialProtein.toString());

    // Quantity and serving size variables
    int quantity = 1;
    String selectedServingSize = '1 cup';

    // Create a TextEditingController for the quantity
    TextEditingController quantityController =
        TextEditingController(text: quantity.toString());

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Using StatefulBuilder to manage state
            return Card(
              elevation: 5,
              margin: EdgeInsets.fromLTRB(10, 100, 10, 100),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: productNameController,
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                        ),
                      ),
                      SizedBox(height: 10),

                      // Macronutrient Fields
                      Text('Total Carbs:'),
                      TextField(
                        controller: carbsController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),

                      Text('Total Fats:'),
                      TextField(
                        controller: fatsController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),

                      Text('Protein:'),
                      TextField(
                        controller: proteinController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Quantity Field
                      Text('Quantity:'),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (quantity > 1) {
                                quantity--;
                                quantityController.text = quantity
                                    .toString(); // Update the quantity text
                                updateMacros(
                                    carbsController,
                                    fatsController,
                                    proteinController,
                                    initialCarbs,
                                    initialFats,
                                    initialProtein,
                                    selectedServingSize,
                                    quantity);
                              }
                            },
                          ),
                          Expanded(
                            child: TextField(
                              controller: quantityController,
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter quantity',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              quantity++;
                              quantityController.text = quantity
                                  .toString(); // Update the quantity text
                              updateMacros(
                                  carbsController,
                                  fatsController,
                                  proteinController,
                                  initialCarbs,
                                  initialFats,
                                  initialProtein,
                                  selectedServingSize,
                                  quantity);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      // Serving Size Dropdown
                      Text('Serving Size:'),
                      DropdownButton<String>(
                        value: selectedServingSize,
                        items: <String>['1 cup', '1/2 cup']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedServingSize =
                                  newValue; // Update the selected value
                              updateMacros(
                                  carbsController,
                                  fatsController,
                                  proteinController,
                                  initialCarbs,
                                  initialFats,
                                  initialProtein,
                                  selectedServingSize,
                                  quantity);
                            });
                          }
                        },
                      ),
                      SizedBox(height: 20),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Cancel button
                            },
                            child: Text('Cancel'),
                          ),
                          SizedBox(width: 10),
                          TextButton(
                            onPressed: () async {
                              // Show loader
                              showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // Prevent dismissing the loader by tapping outside
                                builder: (BuildContext context) {
                                  return Center(
                                    child:
                                        CircularProgressIndicator(), // Loader widget
                                  );
                                },
                              );

                              List<Map<String, dynamic>> wrappedItems = [
                                {
                                  'item': productNameController
                                      .text, // Replace with the actual product name
                                  'quantity':
                                      quantity, // This is the quantity from your dialog
                                  'part':
                                      selectedServingSize, // This is the serving size from your dialog
                                  'fats': _parseInt(double.parse(fatsController
                                      .text)), // Parse and convert to int
                                  'carbs': _parseInt(double.parse(
                                      carbsController
                                          .text)), // Parse and convert to int
                                  'proteins': _parseInt(double.parse(
                                      proteinController
                                          .text)), // Parse and convert to int
                                }
                              ];

                              // Get current date and time
                              final String currentDate = DateTime.now()
                                  .toIso8601String()
                                  .split('T')[0];
                              final String currentTime =
                                  "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";

                              print('wowers');
                              // Retrieve existing macro values from Firestore
                              final DocumentSnapshot userMacrosSnapshot =
                                  await FirebaseFirestore.instance
                                      .collection('userMacros')
                                      .doc(thisUser?.uid)
                                      .get();

                              // Initialize current macro values
                              print(thisUser?.uid);
                              print('wowers1');

                              // Check if the document exists and retrieve current macro values
                              final data = userMacrosSnapshot.data()
                                  as Map<String, dynamic>;
                              print('wowers1.1');

                              final thiscurrentCarbs = (data['carbs'] ?? 0);
                              final thiscurrentFats = (data['fats'] ?? 0);
                              final thiscurrentProtein =
                                  (data['proteins'] ?? 0);
                              final thiscurrentCalories =
                                  (data['calories'] ?? 0);
                              print('wowers1.2');

                              int currentCarbs = thiscurrentCarbs;
                              int currentFats = thiscurrentFats;
                              int currentProtein = thiscurrentProtein;
                              int currentCalories = thiscurrentCalories;
                              print('wowers2');

                              // Assuming these are the initial macro values you retrieved or calculated
                              int initialCarbs =
                                  _parseInt(double.parse(carbsController.text));
                              int initialFats =
                                  _parseInt(double.parse(fatsController.text));
                              int initialProtein = _parseInt(
                                  double.parse(proteinController.text));
                                  // Retrieve max macros from Firestore
                              final userMaxDoc = await FirebaseFirestore
                                  .instance
                                  .collection('user')
                                  .doc(thisUser?.uid)
                                  .get();
                              print('get?');
                              final userMaxData = userMaxDoc.data()!;
                              print('sure?');
                                  // Convert the values to double
                              double maxCarbs =
                                  (userMaxData['gramCarbs'] as num).toDouble();
                              double maxProteins =
                                  (userMaxData['gramProtein'] as num)
                                      .toDouble();
                              double maxFats =
                                  (userMaxData['gramFats'] as num).toDouble();
                              print('all right');
                                // Add 20%
                              double adjustedMaxCarbs =
                                  maxCarbs + (maxCarbs * 0.20);
                              double adjustedMaxProteins =
                                  maxProteins + (maxProteins * 0.20);
                              double adjustedMaxFats =
                                  maxFats + (maxFats * 0.20);

                              print('wowers3');
                              // Calculate final macros based on quantity
                              int finalCarbs =
                                  currentCarbs + (initialCarbs * quantity);
                              int finalFats =
                                  currentFats + (initialFats * quantity);
                              int finalProtein =
                                  currentProtein + (initialProtein * quantity);
                              print((finalFats >= adjustedMaxFats &&
                                  finalCarbs >= adjustedMaxCarbs &&
                                  finalProtein >= adjustedMaxProteins));

                              if (finalFats >= adjustedMaxFats &&
                                  finalCarbs >= adjustedMaxCarbs &&
                                  finalProtein >= adjustedMaxProteins) {
                                Navigator.of(context).pop();

                                Navigator.of(context).pop();
                                return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Warning'),
                                      content: Text(
                                        "You have reached your maximum recommended daily macronutrients intake",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              print('wowers4');
                              // Calculate total calories
                              int calories = currentCalories +
                                  (((initialCarbs * quantity) * 4) +
                                      ((initialFats * quantity) * 9) +
                                      ((initialProtein * quantity) *
                                          4)); 
                              print(finalFats);
                              print('wowers5');
                              // Save data to userMacros collection
                              await FirebaseFirestore.instance
                                  .collection('userMacros')
                                  .doc(thisUser?.uid)
                                  .set(
                                {
                                  'carbs': finalCarbs,
                                  'fats': finalFats,
                                  'proteins': finalProtein,
                                  'calories': calories,
                                  'lastLogIn':
                                      currentDate, // Update the last login date
                                },
                                SetOptions(merge: true),
                              ); // Merge to prevent overwriting

                              print('wowers6');
                              // Save data to MacrosIntakeHistory collection
                              await FirebaseFirestore.instance
                                  .collection("userMacros")
                                  .doc(thisUser?.uid)
                                  .collection('MacrosIntakeHistory')
                                  .doc(currentDate)
                                  .set({
                                'carbs': finalCarbs,
                                'fats': finalFats,
                                'proteins': finalProtein,
                                'calories': calories,
                              }, SetOptions(merge: true));

                              print('wowers7');
                              // Save food history
                              await FirebaseFirestore.instance
                                  .collection('food_history')
                                  .doc(thisUser?.uid)
                                  .collection(currentDate)
                                  .doc(currentTime)
                                  .set({
                                'items':
                                    wrappedItems, // Make sure wrappedItems is defined in scope
                                'timestamp': DateTime.now()
                                    .toIso8601String(), // Add timestamp
                                'userId': thisUser?.uid, // Add user ID
                              });

                              dailyCarbs = finalCarbs;
                              dailyFats = finalFats;
                              dailyProtein = finalProtein;
                              dailyCalories = calories;
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              await prefs.setInt('dailyCarbs', dailyCarbs!);
                              await prefs.setInt('dailyProtein', dailyProtein!);
                              await prefs.setInt('dailyFats', dailyFats!);
                              await prefs.setInt(
                                  'dailyCalories', dailyCalories!);
                              Navigator.of(context).pop(); // Confirm button

                              // Show success snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text('Success!'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              Navigator.of(context).pop(); // Confirm button
                            },
                            child: Text('Confirm'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
 */
  int _parseInt(double value) {
    return value.round();
  }

  int calculateCalories(int carbs, int fats, int proteins) {
    return (carbs * 4) +
        (fats * 9) +
        (proteins * 4); // Adjust calorie calculation as needed
  }

// Method to update the macro values based on serving size and quantity
  void updateMacros(
      TextEditingController carbsController,
      TextEditingController fatsController,
      TextEditingController proteinController,
      int initialCarbs,
      int initialFats,
      int initialProtein,
      String servingSize,
      int quantity) {
    double servingMultiplier = servingSize == '1 cup/piece' ? 1.0 : 0.5;

    // Calculate adjusted macros based on quantity and serving size
    double adjustedCarbs = initialCarbs * servingMultiplier * quantity;
    double adjustedFats = initialFats * servingMultiplier * quantity;
    double adjustedProtein = initialProtein * servingMultiplier * quantity;

    // Update the text fields
    carbsController.text =
        adjustedCarbs.toStringAsFixed(1); // Show 1 decimal place
    fatsController.text =
        adjustedFats.toStringAsFixed(1); // Show 1 decimal place
    proteinController.text =
        adjustedProtein.toStringAsFixed(1); // Show 1 decimal place
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          if (_isInitialized)
            Positioned.fill(
              child: CameraPreview(_cameraController),
            )
          else
            Center(child: CircularProgressIndicator()),
          ..._displayDetectionResults(),
          Positioned(
            top: 110,
            right: 0,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                14.0,
                0.0,
                14.0,
                0.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 150.0,
                    height: 300.0, // Adjust the height if needed
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          blurStyle: BlurStyle.outer,
                          blurRadius: 10.0,
                          color: Colors.white.withOpacity(0.8),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 14.0, 8.0, 0.0),
                          child: Center(
                            child: Text(
                              "Food Detected",
                              style: GoogleFonts.outfit(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: _detectedObjectCounts.entries
                                .map((entry) => ListTile(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      title: Text(
                                        '${entry.key}: ${entry.value}',
                                        style: GoogleFonts.outfit(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: 8.0), // Space between detected items and button
                  ElevatedButton(
                    onPressed: () {
                      _stopDetection();
                      _pauseCamera();
                      Navigator.pushNamed(
                        context,
                        '/foodServing',
                        arguments: _detectedObjectCounts.entries
                            .map((entry) => {
                                  'tag': entry.key,
                                  'quantity': entry.value,
                                })
                            .toList(), // Convert to list of maps with quantity
                      ).then((_) {
                        _resumeCamera(); // Resume the camera when coming back
                      });
                    },
                    child: Text(
                      'Eat Food',
                      style: GoogleFonts.outfit(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.4),
                      side: BorderSide(
                        width: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 160,
            left: 25,
            child: ElevatedButton(
              onPressed:
                  _scanProduct, // Call the _scanProduct function when clicked
              style: ElevatedButton.styleFrom(
                elevation: 5,
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              child: Row(
                children: [
                  Icon(
                    IconlyBold.scan,
                    color: Colors.black,
                  ),
                  Text(
                    'Scan Product',
                    style: GoogleFonts.outfit(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _toggleDetection,
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: _isDetecting
                        ? Colors.redAccent
                        : Colors.green, // Color based on state
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    _isDetecting ? 'Stop Detection' : 'Start Detection',
                    style: GoogleFonts.outfit(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _clearIngredients,
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor:
                        Colors.red, // Custom color for the clear button
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'Clear Ingredients',
                    style: GoogleFonts.outfit(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            width: MediaQuery.sizeOf(context).width,
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Camera",
                    style: GoogleFonts.readexPro(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 0.5,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Stay still for 10 seconds to scan",
                    style: GoogleFonts.readexPro(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _displayDetectionResults() {
    if (_detections.isEmpty || _cameraImage == null) return [];

    final Size screenSize = MediaQuery.of(context).size;
    final double factorX = screenSize.width / (_cameraImage?.height ?? 1);
    final double factorY = screenSize.height / (_cameraImage?.width ?? 1);

    return _detections.map((result) {
      final rect = Rect.fromLTRB(
        result['box'][0].toDouble() * factorX,
        result['box'][1].toDouble() * factorY,
        result['box'][2].toDouble() * factorX,
        result['box'][3].toDouble() * factorY,
      );

      return Positioned(
        left: rect.left,
        top: rect.top,
        width: rect.width,
        height: rect.height,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Color(0xff4b39ef), width: 3),
          ),
          child: Text(
            result['tag'],
            style: GoogleFonts.readexPro(
              backgroundColor: Color(0xff4b39ef),
              color: Colors.white,
            ),
          ),
        ),
      );
    }).toList();
  }
}

// Custom scanning line animation (up and down)
class AnimatedScannerLine extends StatefulWidget {
  @override
  _AnimatedScannerLineState createState() => _AnimatedScannerLineState();
}

class _AnimatedScannerLineState extends State<AnimatedScannerLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Repeat the animation (up and down)

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: MediaQuery.of(context).size.height * _animation.value,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            color: Colors.greenAccent,
          ),
        );
      },
    );
  }
}

// Flash overlay widget to simulate camera flash
class FlashOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(1.0), // Full white flash effect
    );
  }
}
