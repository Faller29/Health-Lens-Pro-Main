import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                IconlyLight.chart,
                size: 120,
                color: Colors.black,
              ),
              Text(
                'Camera Page',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          MaterialButton(
            elevation: 4,
            color: Colors.blueAccent,
            child: Text('Camera'),
            onPressed: () {
              _pickImageFromCamera();
            },
          ),
          MaterialButton(
            elevation: 4,
            color: Colors.blueAccent,
            child: Text('Gallery'),
            onPressed: () {
              _pickImageFromGallery();
            },
          ),
          _selectedImage != null ? Image.file(_selectedImage!) : Text('data'),
        ],
      ),
    );
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }
}
