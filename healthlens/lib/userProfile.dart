import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:healthlens/entry_point.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Initial profile image URL
  String _profileImageUrl = '';
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Controllers for the form fields
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _mNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fNameController.text = firstName!;
    _mNameController.text = middleName!;
    _lNameController.text = lastName!;
    _ageController.text = age.toString();

    _loadProfilePicture();
  }

  Future<void> _loadProfilePicture() async {
    final thisUserUid = thisUser?.uid;

    try {
      final ref = _storage.ref().child('users/$thisUserUid/profile.jpg');
      final profileImageUrl = await ref.getDownloadURL();

      setState(() {
        _profileImageUrl = profileImageUrl;
      });
    } catch (e) {
      print('Error loading profile picture: $e');
    }
  }

  @override
  void dispose() {
    _fNameController.dispose();
    _mNameController.dispose();
    _lNameController.dispose();
    _ageController.dispose();
    super.dispose();
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

  Future<String> _uploadProfilePicture(File imageFile) async {
    try {
      final String userId = thisUser!.uid;
      final userRef = _storage.ref().child('users/$userId/profile.jpg');

      final uploadTask = userRef.putFile(imageFile);

      final snapshot = await uploadTask.whenComplete(() => null);

      final downloadURL = await snapshot.ref.getDownloadURL();
      print('Upload successful, download URL: $downloadURL');
      print(userId);
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        firstName = _fNameController.text;
        middleName = _mNameController.text;
        lastName = _lNameController.text;
        age = int.parse(_ageController.text);
      });

      if (_profileImage != null) {
        try {
          final downloadURL = await _uploadProfilePicture(_profileImage!);
          setState(() {
            _profileImageUrl = downloadURL;
          });

          print('Profile picture uploaded successfully!');
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                behavior: SnackBarBehavior.floating,
                elevation: 3,
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
                content: Text('Error uploading profile picture\n$e')),
          );
        }
      }

      // Update Firestore with profile information
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        final String userId = thisUser!.uid;

        print(_fNameController.text);
        print(_lNameController.text);
        String userFullname = _fNameController.text +
            " " +
            _mNameController.text +
            " " +
            _lNameController.text;

        print(userFullname);
        String initial = _mNameController.text[0].toUpperCase();
        await FirebaseFirestore.instance.collection('user').doc(userId).update({
          'fullName': userFullname,
          'firstName': _fNameController.text,
          'middleName': _mNameController.text,
          'lastName': _lNameController.text,
          'middleInitial': initial,
          'age': int.parse(_ageController.text),
        });
        await prefs.setString('userFullName', userFullname);
        await prefs.setString('firstName', _fNameController.text);
        await prefs.setString('middleName', _mNameController.text);
        await prefs.setString('middleInitial', initial);

        await prefs.setString('lastName', _lNameController.text);
        await prefs.setInt('age', int.parse(_ageController.text));
        await prefs.setString('profileImageUrl', _profileImageUrl);
        saveData();

        // Show success message for Firestore update
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            elevation: 3,
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
            content: Text('Profile updated successfully!'),
          ),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              elevation: 3,
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.red,
              content: Text('Error updating profile\n$e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PROFILE',
              style: GoogleFonts.outfit(fontSize: 12),
            ),
            Text(
              'Edit Profile',
              style: GoogleFonts.readexPro(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 0.9),
            ),
          ],
        ),
        backgroundColor: Color(0xff4b39ef),
        foregroundColor: Colors.white,
      ),
      //backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 5,
          color: Colors.white,
          shadowColor: Color(0xff4b39ef),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 75,
                          backgroundColor: Color(0xff4b39ef),
                          child: _profileImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                    _profileImage!,
                                    width: 140,
                                    height: 140,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : _profileImageUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        imageUrl: _profileImageUrl,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        fit: BoxFit.cover,
                                        width: 140,
                                        height: 140,
                                      ),
                                    )
                                  : Icon(
                                      Icons.account_circle,
                                      size: 110,
                                      color: Colors.grey,
                                    ),
                        ),
                        ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            //padding: EdgeInsets.symmetric(vertical: 14.0),
                            backgroundColor: Color(0xff4b39ef),
                          ),
                          child: Text(
                            'Change Profile',
                            style: GoogleFonts.readexPro(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _fNameController,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      style: GoogleFonts.readexPro(
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffe0e3e7),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff4b39ef),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff4b39ef),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
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
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      controller: _mNameController,
                      style: GoogleFonts.readexPro(
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffe0e3e7),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff4b39ef),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff4b39ef),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
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
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      controller: _lNameController,
                      style: GoogleFonts.readexPro(
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffe0e3e7),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff4b39ef),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff4b39ef),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
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
                      maxLength: 3,
                      controller: _ageController,
                      style: GoogleFonts.readexPro(
                        fontSize: 16,
                      ),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffe0e3e7),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff4b39ef),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff4b39ef),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
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
          ),
        ),
      ),
    );
  }
}
