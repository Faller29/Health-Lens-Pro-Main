import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'main.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String _profileImageUrl = 'https://picsum.photos/seed/529/600';

  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _mNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<String> _uploadProfilePicture(File imageFile) async {
    print(_profileImage);
    print('try upload');
    try {
      print('try upload1');

      final String userId = userUid;
      final userRef = _storage.ref().child('users/$userId/profile.jpg');
      print('try upload2');

      final uploadTask = userRef.putFile(imageFile);
      print('try upload2.1');
      print('File exists: ${imageFile.existsSync()}');
      print('File size: ${imageFile.lengthSync()} bytes');
      final snapshot = await uploadTask.whenComplete(() => null);
      print('try upload2.2');

      final downloadURL = await snapshot.ref.getDownloadURL();
      print('try upload3');

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow; // Rethrow the error for proper handling
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fNameController.text = firstName!;
    _mNameController.text = middleName!;
    _lNameController.text = lastName!;
    _ageController.text = age.toString();
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
      // Here, you can add logic to save updated information to Firebase or locally
      if (_profileImage != null) {
        try {
          final downloadURL = await _uploadProfilePicture(_profileImage!);
          // Save downloadURL to your database or user profile
          print(_profileImage);
          _profileImageUrl = downloadURL;
        } catch (e) {
          // Handle upload errors
          print('Error uploading profile picture: $e');
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: GoogleFonts.readexPro(fontSize: 18)),
        backgroundColor: Color(0xFF39D2C0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0x4D39D2C0),
                  child: _profileImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            _profileImage!,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl:
                              'https://flutter.io/images/flutter-mark-square-100.png',
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                          width: 110,
                          height: 110,
                        ),
                ),
              ),

              SizedBox(height: 20),
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
              // Name Field
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
              // Age Field
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
              SizedBox(height: 30),
              // Save Button
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Color(0xFF39D2C0),
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
