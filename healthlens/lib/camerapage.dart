import 'dart:ui';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:google_fonts/google_fonts.dart';

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

    // Start a 10-second timer
    _detectionTimer = Timer(Duration(seconds: 10), () {
      if (_detections.isEmpty) {
        // Show a dialog or any other UI feedback
        showDialog(
          context: context,
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
          classThreshold: 0.75,
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
      _detections.clear();
    });

    // Cancel the timer when detection is stopped
    _detectionTimer?.cancel();

    await _cameraController.stopImageStream();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150.0,
                    height: 300.0, // Adjust the height if needed
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
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
                          child: Text(
                            "Ingredients Detected",
                            style: GoogleFonts.outfit(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
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
            bottom: 100,
            left: 0,
            right: 0,
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
                    backgroundColor: Colors
                        .lightBlueAccent, // Custom color for the clear button
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
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.greenAccent, width: 1.0),
          ),
          child: Text(
            result['tag'],
            style: TextStyle(
              backgroundColor: Colors.greenAccent,
              color: Colors.black,
            ),
          ),
        ),
      );
    }).toList();
  }
}
