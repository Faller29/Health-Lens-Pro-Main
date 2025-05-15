import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/backend_firebase/auth.dart';
import 'package:healthlens/entry_point.dart';
import 'package:healthlens/homepage.dart';
import 'package:healthlens/setup.dart';
import 'package:iconly/iconly.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:string_extensions/string_extensions.dart';
import 'profilepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Auth _authService = Auth();
  final AuthService forgotPassword = AuthService();
  var _firstPress = true;
  String _userName = '';
  String _email = ''; // Add this to store the email
  bool _isChangingAccount = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final String requiredPin = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> fromSignOut(String email, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    email = prefs.getString('email')!; // Load the saved email

    _email = email;
    _userName = username;
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email'); // Load the saved email

    setState(() {
      _email = email ?? ''; // Set the email to the saved one
      if (!_isChangingAccount) {
        _emailController.text = _email; // Pre-fill the email field
      }
    });
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    setState(() {
      _userName = '';
      _email = '';
      _isChangingAccount = true;
      _emailController.clear(); // Clear the email controller when signing out
    });
  }

  void _onLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Show the loading Snackbar
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 3,
      content: Row(
        children: [
          CircularProgressIndicator(
            strokeWidth: 2,
          ),
          SizedBox(width: 10),
          Expanded(child: Text('Logging in...')),
        ],
      ),
      duration: Duration(minutes: 1), // Keep it visible until dismissed
    );

    // Get email and pincode
    _emailController.text = _email;
    String email = _emailController.text;
    String pincode = _pincodeController.text;
    User? user;

    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Perform login
      user = await _authService.signInWithEmailAndPincode(email, pincode);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (user != null) {
        // Save user data locally
        await prefs.setString('userName', user.email ?? '');
        await prefs.setString('currentEmail', email); // Save email locally

        setState(() {
          _isChangingAccount = false;
        });

        // Navigate to the next page

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => EntryPoint(showTutorial: false)),
        );
      } else {
        // Show error message if login fails
        String errorMessage = 'Log in Failed. Check your Email and Password';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            elevation: 3,
            duration: const Duration(seconds: 2),
            content: Text(errorMessage),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 3,
          duration: const Duration(seconds: 2),
          content:
              Text('No Internet Connection. Check your Internet Connectivity'),
        ),
      );
    }
    setState(() {
      _firstPress = !_firstPress;
    });
    // Dismiss the Snackbar after login attempt
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: 670.0),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        'https://images.unsplash.com/photo-1551218808-94e220e084d2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Y29va2luZ3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
                      ),
                    ),
                  ),
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0x00FFFFFF), Colors.white],
                        stops: [0.0, 1.0],
                        begin: AlignmentDirectional(0.0, -1.0),
                        end: AlignmentDirectional(0, 1.0),
                      ),
                    ),
                    alignment: AlignmentDirectional(0.0, 1.0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          24.0, 64.0, 24.0, 24.0),
                      child: Text(
                        'HealthLens Pro',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          color: Color(0xFF101213),
                          fontSize: 45.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 20, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              initialValue: _email,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 10, 10, 10),
                                labelText: 'Email',
                                labelStyle: GoogleFonts.outfit(
                                  fontSize: 15.0,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffe0e3e7),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff4b39ef),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff4b39ef),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              style: GoogleFonts.outfit(
                                fontSize: 18.0,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (value == null || value.isEmpty) {
                                    // Handle empty or null value
                                  } else {
                                    _email = value;
                                  }
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Email';
                                }
                                return null; // Validation successful
                              },
                            ),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 15.0, 0.0, 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              PinCodeTextField(
                                blinkWhenObscuring: true,
                                controller: _pincodeController,
                                autoDisposeControllers: false,
                                appContext: context,
                                length: 6,
                                textStyle: GoogleFonts.readexPro(
                                  fontSize: 18.0,
                                ),
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                enableActiveFill: false,
                                autoFocus: false,
                                enablePinAutofill: false,
                                errorTextSpace: 16.0,
                                showCursor: true,
                                cursorColor: Color(0xff4b39ef),
                                obscureText: true,
                                hintCharacter: '●',
                                keyboardType: TextInputType.number,
                                pinTheme: PinTheme(
                                    fieldHeight: 44.0,
                                    fieldWidth: 44.0,
                                    borderWidth: 2.0,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12.0),
                                      bottomRight: Radius.circular(12.0),
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0),
                                    ),
                                    shape: PinCodeFieldShape.box,
                                    activeColor: Color(0xFF017E07),
                                    inactiveColor: Colors.grey,
                                    selectedColor: Color(0xff4b39ef),
                                    activeFillColor: Color(0xFF017E07),
                                    inactiveFillColor: Colors.grey,
                                    selectedFillColor: Color(0xff4b39ef),
                                    errorBorderColor: Colors.red),
                                onChanged: (_) {},
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: TextButton(
                                    child: Text(
                                      'Forgot Password',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 14.0),
                                    ),
                                    onPressed: () async {
                                      if (_email.isNotEmpty) {
                                        print(_email);
                                        _errorMessage = await forgotPassword
                                            .sendPasswordResetEmail(_email);
                                        // Optionally show a success message
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(_errorMessage!),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            elevation: 3,
                                            duration:
                                                const Duration(seconds: 2),
                                            content: Text(
                                                'Please Enter your Email.'),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_firstPress) {
                          _firstPress = false;
                          _onLogin();
                        }
                      },
                      child: Text(
                        'Log In',
                        style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white30),
                        backgroundColor: MaterialStatePropertyAll<Color>(
                          Color(0xff4b39ef),
                        ),
                        side: MaterialStatePropertyAll(
                          BorderSide(
                            color: Color(0xFFE0E3E7),
                            width: 1.0,
                          ),
                        ),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.fromLTRB(50, 10, 50, 10),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 64.0),
                      child: RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Don\'t have an account?',
                              style: GoogleFonts.plusJakartaSans(
                                color: Color(0xFF57636C),
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: ' Sign Up!',
                              style: GoogleFonts.plusJakartaSans(
                                color: Color(0xFF101213),
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SetupPage(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
