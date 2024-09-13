import 'dart:math';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_vision/flutter_vision.dart'; // Import flutter_vision package

class ScanController extends GetxController {
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  var isCameraInitialized = false.obs;
  var cameraCount = 0;
  late FlutterVision flutterVision; // Initialize FlutterVision
  String modelPath = "assets/yolov8n.tflite"; // Update the model path
  String labelsPath = "assets/labels.txt";

  @override
  void onInit() {
    super.onInit();
    initCamera();
    initModel();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
    flutterVision.closeYoloModel(); // Properly dispose of the model
  }

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();

      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.max,
        imageFormatGroup: ImageFormatGroup.bgra8888,
      );
      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            objectDetector(image);
          }
          update();
        });
      });
      isCameraInitialized(true);
      update();
    } else {
      print('Permission Denied');
    }
  }

  // Initialize YOLO model using flutter_vision
  initModel() async {
    flutterVision = FlutterVision();
    await flutterVision.loadYoloModel(
      modelPath: "assets/model.tflite",
      labels: "assets/labels.txt",
      modelVersion: "yolov8",
      numThreads: 1, // Adjust based on your preference
      useGpu: false, // Set to true if you want to use GPU
    );
  }

  objectDetector(CameraImage image) async {
    final results = await flutterVision.yoloOnFrame(
      bytesList: image.planes.map((plane) => plane.bytes).toList(),
      imageHeight: image.height,
      imageWidth: image.width,
      iouThreshold: 0.4,
      confThreshold: 0.4,
      classThreshold: 0.5, // Non-maximum suppression threshold
    );

    if (results.isNotEmpty) {
      print("Detections: $results");
    }
  }
}
