import 'dart:io';
import 'package:flutter/material.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            IconlyLight.chart,
            size: 120,
            color: Colors.black,
          ),
          Text(
            'Analytics Page',
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700),
          ),
          MaterialButton(
            child: Text('Camera'),
            onPressed: () {
              _pickImageFromCamera();
            },
          ),
          SizedBox(
            height: 20,
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
}
