import 'package:cached_network_image/cached_network_image.dart';
import 'package:crea_radio_button/crea_radio_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthlens/entry_point.dart';
import 'package:healthlens/login_page.dart';
import 'package:iconly/iconly.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:string_extensions/string_extensions.dart';
import 'backend_firebase/signUp.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

// Usage:

class _SetupPageState extends State<SetupPage> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;
  List<RadioOption> options = [
    RadioOption("MALE", "Male"),
    RadioOption("FEMALE", "Female")
  ];

  List<Map> categories = [
    {"name": "Diabetes [Type 1 or 2]", "isChecked": false},
    {"name": "Hypertension", "isChecked": false},
    {"name": "Obesity", "isChecked": false},
  ];
  bool visible = true;
  List<String> chronicDisease = [];
  String nextText = "Next";
  String? email,
      code,
      gender = 'Male',
      lifeStyle = 'Sedentary',
      fName,
      mName,
      lName;
  late String pinCode;
  int genderIndex = 0;
  late int age = 0;
  late double height = 0, weight = 0;
  final emailRegex =
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

  bool _isPrivacyChecked = false;
  var _firstPress = true;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null; // Validation successful
  }

  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  void _handlePageChange(int index) {
    setState(() {
      _currentPageIndex = index;
      if (_currentPageIndex == 4) {
        nextText = "Finish";
      } else {
        nextText = "Next";
      }
    });
  }

  void getCheckedDiseases() {
    chronicDisease = categories
        .where((disease) => disease['isChecked'] == true)
        .map((disease) => disease['name'] as String)
        .toList();

    print(chronicDisease);
  }

  void _previousPage() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        visible = false;
        _currentPageIndex--;
      });
      if (_currentPageIndex == 0) {
        setState(() {
          visible = true;
          _currentPageIndex = 0;
        });
      }
    }
    if (_currentPageIndex < 4) {
      setState(() {
        nextText = "Next";
      });
    }
  }

  void _nextPage() async {
    if (gender == 'Female') {
      genderIndex = 1;
    } else {
      genderIndex = 0;
    }
    if (_currentPageIndex > 0) {
      formKey.currentState!.validate();

      if (formKey.currentState!.validate() == false) {
        return;
      }
    }
    if (_currentPageIndex < 4) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        _currentPageIndex++;
        visible = false;
        if (_currentPageIndex == 4) {
          nextText = "Finish";
        }
      });
      print(_currentPageIndex);
    } else if (_currentPageIndex == 4) {
      if (_isPrivacyChecked) {
        _firstPress = false;
        print(_firstPress);
        final snackBar = SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 10),
              Expanded(child: Text('Signing up...')),
            ],
          ),

          behavior: SnackBarBehavior.floating,
          elevation: 3,
          duration: Duration(minutes: 1), // Keep it visible until dismissed
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        try {
          print('success');
          bool signUpSuccess = await signUp(
            email!,
            pinCode,
            gender!,
            lifeStyle!,
            fName!,
            mName!,
            lName!,
            age,
            height,
            weight,
            chronicDisease,
          );
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          setState(() {
            _firstPress = !_firstPress;
          });
          if (signUpSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => EntryPoint(showTutorial: true)),
              (route) => false, // Remove all previous routes
            );
          } else {
            // Generic sign-up failed message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  behavior: SnackBarBehavior.floating,
                  elevation: 3,
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.red,
                  content: Text(
                      'Sign up failed.\nPlease check the information you Provided and try again.')),
            );
            setState(() {
              _firstPress = !_firstPress;
            });
          }
        } on WeakPasswordException {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                behavior: SnackBarBehavior.floating,
                elevation: 3,
                duration: const Duration(seconds: 2),
                content: Text('Weak password. Please choose a stronger one.')),
          );
          setState(() {
            _firstPress = !_firstPress;
          });
        } on EmailAlreadyInUseException {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                behavior: SnackBarBehavior.floating,
                elevation: 3,
                duration: const Duration(seconds: 2),
                content: Text(
                    'Email already in use. Please use a different email.')),
          );
          setState(() {
            _firstPress = !_firstPress;
          });
        } catch (e) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                behavior: SnackBarBehavior.floating,
                elevation: 3,
                duration: const Duration(seconds: 2),
                content: Text('Sign up failed. Please try again.')),
          );
          setState(() {
            _firstPress = !_firstPress;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              elevation: 3,
              duration: const Duration(seconds: 2),
              content: Text('Agree to the Data Privacy Policy to Continue.')),
        );
        setState(() {
          _firstPress = !_firstPress;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        top: true,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.935,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 500.0,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 10.0),
                                  child: PageView(
                                    controller: _pageController,
                                    onPageChanged: _handlePageChange,
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      PageViewPage(
                                        children: [
                                          Center(
                                            //alignment: Alignment.center,
                                            child: Text(
                                              'Welcome To',
                                              style: GoogleFonts.outfit(
                                                fontSize: 24.0,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            //alignment: Alignment.center,
                                            child: Text(
                                              ' HealthLens Pro!',
                                              style: GoogleFonts.outfit(
                                                  fontSize: 40.0,
                                                  fontWeight: FontWeight.bold,
                                                  height: 0.9),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 15.0, 0.0, 15.0),
                                            child: Text(
                                              'HealthLens Pro is a mobile application designed to raise awareness and guide individuals about their chronic illnesses. This is to help them reduce health-risk-related issues.',
                                              style: GoogleFonts.readexPro(
                                                fontSize: 14.0,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://images.unsplash.com/photo-1494390248081-4e521a5940db?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxOHx8aGVhbHRofGVufDB8fHx8MTcxMzk1NDY2MXww&ixlib=rb-4.0.3&q=80&w=1080',
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                                fit: BoxFit.cover,
                                                width: 300.0,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      PageViewPage(
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Text(
                                              'Profile Set Up',
                                              style: GoogleFonts.outfit(
                                                fontSize: 40.0,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        24.0, 24.0, 24.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 20, 0, 10),
                                                      child: Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Text(
                                                          'STEP 1/4',
                                                          style: GoogleFonts
                                                              .readexPro(
                                                                  fontSize:
                                                                      18.0,
                                                                  color: Color(
                                                                      0xff4b39ef)),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'User Information',
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 30.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Please enter your Name and Sex to continue.',
                                                      style:
                                                          GoogleFonts.readexPro(
                                                        fontSize: 14.0,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Expanded(
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0,
                                                                      -1.0),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8.0,
                                                                            30.0,
                                                                            8.0,
                                                                            0.0),
                                                                child:
                                                                    TextFormField(
                                                                  textCapitalization:
                                                                      TextCapitalization
                                                                          .words,
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .next,
                                                                  initialValue:
                                                                      fName,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    contentPadding:
                                                                        EdgeInsets.fromLTRB(
                                                                            10,
                                                                            10,
                                                                            10,
                                                                            10),
                                                                    labelText:
                                                                        'First Name',
                                                                    labelStyle:
                                                                        GoogleFonts
                                                                            .outfit(
                                                                      fontSize:
                                                                          15.0,
                                                                    ),
                                                                    enabledBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xffe0e3e7),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xff4b39ef),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    errorBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .red,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedErrorBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xff4b39ef),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                  style:
                                                                      GoogleFonts
                                                                          .outfit(
                                                                    fontSize:
                                                                        16.0,
                                                                  ),
                                                                  onChanged:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      // Handle empty or null value
                                                                    } else {
                                                                      fName = value
                                                                          .toTitleCase;
                                                                      print(
                                                                          fName);
                                                                    }
                                                                  },
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please enter your First Name';
                                                                    }
                                                                    return null; // Validation successful
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0,
                                                                      -1.0),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8.0,
                                                                            30.0,
                                                                            8.0,
                                                                            0.0),
                                                                child:
                                                                    TextFormField(
                                                                  textCapitalization:
                                                                      TextCapitalization
                                                                          .words,
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .next,
                                                                  initialValue:
                                                                      mName,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    contentPadding:
                                                                        EdgeInsets.fromLTRB(
                                                                            10,
                                                                            10,
                                                                            10,
                                                                            10),
                                                                    labelText:
                                                                        'Middle Name',
                                                                    labelStyle:
                                                                        GoogleFonts
                                                                            .outfit(
                                                                      fontSize:
                                                                          15.0,
                                                                    ),
                                                                    enabledBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xffe0e3e7),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xff4b39ef),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    errorBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .red,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedErrorBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xff4b39ef),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                  style:
                                                                      GoogleFonts
                                                                          .outfit(
                                                                    fontSize:
                                                                        16.0,
                                                                  ),
                                                                  onChanged:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      // Handle empty or null value
                                                                    } else {
                                                                      print(
                                                                          mName);
                                                                      mName = value
                                                                          .toTitleCase;
                                                                    }
                                                                  },
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please enter your Middle Name';
                                                                    }
                                                                    // Validation successful
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0,
                                                                      -1.0),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8.0,
                                                                            30.0,
                                                                            8.0,
                                                                            0.0),
                                                                child:
                                                                    TextFormField(
                                                                  textCapitalization:
                                                                      TextCapitalization
                                                                          .words,
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .next,
                                                                  initialValue:
                                                                      lName,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    contentPadding:
                                                                        EdgeInsets.fromLTRB(
                                                                            10,
                                                                            10,
                                                                            10,
                                                                            10),
                                                                    labelText:
                                                                        'Last Name',
                                                                    labelStyle:
                                                                        GoogleFonts
                                                                            .outfit(
                                                                      fontSize:
                                                                          15.0,
                                                                    ),
                                                                    enabledBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xffe0e3e7),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xff4b39ef),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    errorBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .red,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedErrorBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xff4b39ef),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                  style:
                                                                      GoogleFonts
                                                                          .outfit(
                                                                    fontSize:
                                                                        16.0,
                                                                  ),
                                                                  onChanged:
                                                                      (value) {
                                                                    lName = value
                                                                        .toTitleCase;
                                                                  },
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please enter your Last Name';
                                                                    }
                                                                    return null; // Validation successful
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          15.0,
                                                                          0.0,
                                                                          15.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        'Sex:',
                                                                        style: GoogleFonts
                                                                            .readexPro(
                                                                          fontSize:
                                                                              17.0,
                                                                        ),
                                                                      ),
                                                                      RadioButtonGroup(
                                                                          textStyle: TextStyle(
                                                                              fontSize:
                                                                                  14,
                                                                              color: Colors
                                                                                  .white),
                                                                          buttonHeight:
                                                                              30,
                                                                          buttonWidth:
                                                                              100,
                                                                          circular:
                                                                              true,
                                                                          mainColor: Colors.grey.withOpacity(
                                                                              0.2),
                                                                          selectedColor: Color(
                                                                              0xff4b39ef),
                                                                          selectedBorderSide: BorderSide(
                                                                              width:
                                                                                  1,
                                                                              color: Color(
                                                                                  0xff4b39ef)),
                                                                          preSelectedIdx:
                                                                              genderIndex,
                                                                          options:
                                                                              options,
                                                                          callback:
                                                                              (RadioOption val) {
                                                                            setState(() {
                                                                              gender = val.label;
                                                                              print(gender);
                                                                            });
                                                                          })
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      PageViewPage(
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Text(
                                              'Profile Set Up',
                                              style: GoogleFonts.outfit(
                                                fontSize: 40.0,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      24.0, 24.0, 24.0, 0.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 20, 0, 10),
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Text(
                                                        'STEP 2/4',
                                                        style: GoogleFonts
                                                            .readexPro(
                                                                fontSize: 18.0,
                                                                color: Color(
                                                                    0xff4b39ef)),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'User Information',
                                                    style: GoogleFonts.outfit(
                                                      fontSize: 30.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Please enter your Age, Height, and Weight.',
                                                    style:
                                                        GoogleFonts.readexPro(
                                                      fontSize: 14.0,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Expanded(
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, -1.0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          30.0,
                                                                          8.0,
                                                                          0.0),
                                                              child:
                                                                  TextFormField(
                                                                initialValue:
                                                                    (age == 0)
                                                                        ? ''
                                                                        : age.toStringAsFixed(
                                                                            0),
                                                                maxLength: 3,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .next,
                                                                keyboardType: TextInputType
                                                                    .numberWithOptions(
                                                                        decimal:
                                                                            true),
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .allow(RegExp(
                                                                          '[0-9.]')),
                                                                ],
                                                                //onChanged: (value) => doubleVar = double.parse(value),

                                                                decoration:
                                                                    InputDecoration(
                                                                  counterText:
                                                                      "",
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .fromLTRB(
                                                                              10,
                                                                              10,
                                                                              10,
                                                                              10),
                                                                  labelText:
                                                                      'Age',
                                                                  labelStyle:
                                                                      GoogleFonts
                                                                          .outfit(
                                                                    fontSize:
                                                                        15.0,
                                                                  ),
                                                                  enabledBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Color(
                                                                          0xffe0e3e7),
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  focusedBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Color(
                                                                          0xff4b39ef),
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  errorBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  focusedErrorBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                                style:
                                                                    GoogleFonts
                                                                        .outfit(
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                                onChanged:
                                                                    (value) {
                                                                  age = int.tryParse(
                                                                          value ??
                                                                              '') ??
                                                                      0;
                                                                  print(age);
                                                                },
                                                                validator:
                                                                    (value) {
                                                                  if (value ==
                                                                          null ||
                                                                      value
                                                                          .isEmpty) {
                                                                    return 'Please enter your age';
                                                                  }
                                                                  return null; // Validation successful
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, -1.0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          30.0,
                                                                          8.0,
                                                                          0.0),
                                                              child:
                                                                  TextFormField(
                                                                initialValue:
                                                                    (height ==
                                                                            0)
                                                                        ? ''
                                                                        : height
                                                                            .toStringAsFixed(0),
                                                                maxLength: 3,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .next,
                                                                keyboardType: TextInputType
                                                                    .numberWithOptions(
                                                                        decimal:
                                                                            true),
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .allow(RegExp(
                                                                          '[0-9.]')),
                                                                ],
                                                                //onChanged: (value) => doubleVar = double.parse(value),
                                                                decoration:
                                                                    InputDecoration(
                                                                  counterText:
                                                                      "",
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .fromLTRB(
                                                                              10,
                                                                              10,
                                                                              10,
                                                                              10),
                                                                  labelText:
                                                                      'Height [cm]',
                                                                  labelStyle:
                                                                      GoogleFonts
                                                                          .outfit(
                                                                    fontSize:
                                                                        15.0,
                                                                  ),
                                                                  enabledBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Color(
                                                                          0xffe0e3e7),
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  focusedBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Color(
                                                                          0xff4b39ef),
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  errorBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  focusedErrorBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                                style:
                                                                    GoogleFonts
                                                                        .outfit(
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                                onChanged:
                                                                    (value) {
                                                                  height = double.tryParse(
                                                                          value ??
                                                                              '') ??
                                                                      0;
                                                                  print(height);
                                                                },
                                                                validator:
                                                                    (height) {
                                                                  if (height ==
                                                                          null ||
                                                                      height
                                                                          .isEmpty) {
                                                                    return 'Please enter your Height';
                                                                  }
                                                                  if (height
                                                                          .length <
                                                                      1) {
                                                                    return 'Please make sure your height is in cm';
                                                                  }

                                                                  return null; // Validation successful
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, -1.0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          30.0,
                                                                          8.0,
                                                                          0.0),
                                                              child:
                                                                  TextFormField(
                                                                initialValue:
                                                                    (weight ==
                                                                            0)
                                                                        ? ''
                                                                        : weight
                                                                            .toStringAsFixed(0),
                                                                maxLength: 3,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .next,
                                                                keyboardType: TextInputType
                                                                    .numberWithOptions(
                                                                        decimal:
                                                                            true),
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .allow(RegExp(
                                                                          '[0-9.]')),
                                                                ],
                                                                //onChanged: (value) => doubleVar = double.parse(value),
                                                                decoration:
                                                                    InputDecoration(
                                                                  counterText:
                                                                      "",
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .fromLTRB(
                                                                              10,
                                                                              10,
                                                                              10,
                                                                              10),
                                                                  labelText:
                                                                      'Weight [kg]',
                                                                  labelStyle:
                                                                      GoogleFonts
                                                                          .outfit(
                                                                    fontSize:
                                                                        15.0,
                                                                  ),
                                                                  enabledBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Color(
                                                                          0xffe0e3e7),
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  focusedBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Color(
                                                                          0xff4b39ef),
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  errorBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  focusedErrorBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                                style:
                                                                    GoogleFonts
                                                                        .outfit(
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                                onChanged:
                                                                    (value) {
                                                                  weight = double.tryParse(
                                                                          value ??
                                                                              '') ??
                                                                      0;
                                                                  print(weight);
                                                                },
                                                                validator:
                                                                    (value) {
                                                                  if (value ==
                                                                          null ||
                                                                      value
                                                                          .isEmpty) {
                                                                    return 'Please enter your weight';
                                                                  }
                                                                  if (value
                                                                          .length <
                                                                      1) {
                                                                    return 'Please enter a valid weight';
                                                                  }

                                                                  return null; // Validation successful
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      PageViewPage(
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Text(
                                              'Profile Set Up',
                                              style: GoogleFonts.outfit(
                                                fontSize: 40.0,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            24.0,
                                                            24.0,
                                                            24.0,
                                                            0.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 20, 0, 10),
                                                          child: Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Text(
                                                              'STEP 3/4',
                                                              style: GoogleFonts
                                                                  .readexPro(
                                                                fontSize: 18.0,
                                                                color: Color(
                                                                    0xff4b39ef),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          'Health Information',
                                                          style: GoogleFonts
                                                              .outfit(
                                                            fontSize: 30.0,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Please Select your current health status and Lifestyle.',
                                                          style: GoogleFonts
                                                              .readexPro(
                                                            fontSize: 14.0,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Material(
                                                            color: Colors.white,
                                                            elevation: 4,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            shadowColor: Color(
                                                                0xFF2336E2),
                                                            /* borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8), */
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          10,
                                                                          0,
                                                                          8),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        'Physical Lifestyle',
                                                                        style: GoogleFonts.readexPro(
                                                                            fontSize:
                                                                                18.0,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          showCupertinoModalPopup(
                                                                              context: context,
                                                                              builder: ((context) {
                                                                                return Center(
                                                                                  child: Card(
                                                                                    color: Color.fromARGB(234, 255, 255, 255),
                                                                                    elevation: 3,
                                                                                    margin: const EdgeInsets.fromLTRB(10, 150, 10, 150),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.all(20),
                                                                                      child: SingleChildScrollView(
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          //mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Physical Lifestyle',
                                                                                              style: GoogleFonts.readexPro(
                                                                                                fontSize: 18.0,
                                                                                                fontWeight: FontWeight.bold,
                                                                                              ),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 20,
                                                                                            ),
                                                                                            Text(
                                                                                              'Sedentary: ',
                                                                                              style: GoogleFonts.readexPro(
                                                                                                fontSize: 14.0,
                                                                                                fontWeight: FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              'Mostly Resting with little or no Activity.',
                                                                                              style: GoogleFonts.readexPro(
                                                                                                fontSize: 14.0,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 20,
                                                                                            ),
                                                                                            Text(
                                                                                              'Light: ',
                                                                                              style: GoogleFonts.readexPro(
                                                                                                fontSize: 14.0,
                                                                                                fontWeight: FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              'Occupations that require minimal movement.',
                                                                                              style: GoogleFonts.readexPro(
                                                                                                fontSize: 14.0,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 20,
                                                                                            ),
                                                                                            Text(
                                                                                              'Moderate: ',
                                                                                              style: GoogleFonts.readexPro(
                                                                                                fontSize: 14.0,
                                                                                                fontWeight: FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              'Occupations that require periods of movement.',
                                                                                              style: GoogleFonts.readexPro(
                                                                                                fontSize: 14.0,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 20,
                                                                                            ),
                                                                                            Text(
                                                                                              'Vigorous: ',
                                                                                              style: GoogleFonts.readexPro(
                                                                                                fontSize: 14.0,
                                                                                                fontWeight: FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              'Occupations that require extensive movement.',
                                                                                              style: GoogleFonts.readexPro(
                                                                                                fontSize: 14.0,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              }));
                                                                        },
                                                                        icon:
                                                                            Icon(
                                                                          FontAwesomeIcons
                                                                              .solidCircleQuestion,
                                                                          size:
                                                                              16,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: RadioButtonGroup(
                                                                          multilineNumber: 2,
                                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          spaceBetween: 1,
                                                                          betweenMultiLines: 10,
                                                                          buttonHeight: 30,
                                                                          buttonWidth: 115,
                                                                          circular: true,
                                                                          textStyle: TextStyle(fontSize: 13, color: Colors.white),
                                                                          mainColor: Colors.grey,
                                                                          selectedColor: Color(0xff4b39ef),
                                                                          selectedBorderSide: BorderSide(width: 1, color: Color(0xff4b39ef)),
                                                                          preSelectedIdx: 0,
                                                                          options: [
                                                                            RadioOption("SEDENTARY",
                                                                                "Sedentary"),
                                                                            RadioOption("LIGHT",
                                                                                "Light"),
                                                                            RadioOption("MODERATE",
                                                                                "Moderate"),
                                                                            RadioOption("VIGOROUS",
                                                                                "Vigorous"),
                                                                          ],
                                                                          callback: (RadioOption val) {
                                                                            setState(() {
                                                                              lifeStyle = val.label;
                                                                              print(lifeStyle);
                                                                            });
                                                                          }),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                              ],
                                                            )),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 0, 10),
                                                          child: Material(
                                                            elevation: 4,
                                                            color: Colors.white,
                                                            shadowColor: Color(
                                                                0xFF2336E2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Text(
                                                                  'Chronic Disease:',
                                                                  style: GoogleFonts.readexPro(
                                                                      fontSize:
                                                                          18.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              15.0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children:
                                                                        categories
                                                                            .map((disease) {
                                                                      return CheckboxListTile(
                                                                        title:
                                                                            Text(
                                                                          disease[
                                                                              'name'],
                                                                          style:
                                                                              GoogleFonts.readexPro(),
                                                                        ),
                                                                        checkboxShape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(6),
                                                                        ),
                                                                        value: disease[
                                                                            'isChecked'],
                                                                        onChanged:
                                                                            (val) {
                                                                          setState(
                                                                              () {
                                                                            disease['isChecked'] =
                                                                                val;
                                                                            getCheckedDiseases();
                                                                            print('${disease['name']} isChecked: ${disease['isChecked']}');
                                                                          });
                                                                        },
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      PageViewPage(
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Text(
                                              'Profile Set Up',
                                              style: GoogleFonts.outfit(
                                                fontSize: 40.0,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(24.0, 24.0,
                                                          24.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 20, 0, 10),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Text(
                                                            'STEP 4/4',
                                                            style: GoogleFonts
                                                                .readexPro(
                                                                    fontSize:
                                                                        18.0,
                                                                    color: Color(
                                                                        0xff4b39ef)),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        'Account & Security',
                                                        style:
                                                            GoogleFonts.outfit(
                                                          fontSize: 30.0,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Create an Account to save and retrieve your data.',
                                                        style: GoogleFonts
                                                            .readexPro(
                                                          fontSize: 14.0,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                      ),
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width /
                                                                1.2,
                                                            child:
                                                                TextFormField(
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .emailAddress,
                                                              initialValue:
                                                                  email,
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            10,
                                                                            10,
                                                                            10),
                                                                labelText:
                                                                    'Personal Email',
                                                                labelStyle:
                                                                    GoogleFonts
                                                                        .outfit(
                                                                  fontSize:
                                                                      15.0,
                                                                ),
                                                                enabledBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        0xffe0e3e7),
                                                                    width: 2.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                focusedBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        0xff4b39ef),
                                                                    width: 2.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                errorBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 2.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                focusedErrorBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 2.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                              ),
                                                              style: GoogleFonts
                                                                  .outfit(
                                                                fontSize: 18.0,
                                                              ),
                                                              onChanged:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  // Handle empty or null value
                                                                } else {
                                                                  email = value;
                                                                }
                                                                print(email);
                                                              },
                                                              validator:
                                                                  validateEmail,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                      ),
                                                      Text(
                                                        'Set up 6 Digit Pin Code.',
                                                        style: GoogleFonts
                                                            .readexPro(
                                                          fontSize: 14.0,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      10.0,
                                                                      0.0,
                                                                      0.0),
                                                          child:
                                                              PinCodeTextField(
                                                            blinkWhenObscuring:
                                                                true,
                                                            autoDisposeControllers:
                                                                false,
                                                            appContext: context,
                                                            length: 6,
                                                            textStyle:
                                                                GoogleFonts
                                                                    .readexPro(
                                                              fontSize: 18.0,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            enableActiveFill:
                                                                false,
                                                            autoFocus: false,
                                                            enablePinAutofill:
                                                                false,
                                                            errorTextSpace:
                                                                16.0,
                                                            showCursor: true,
                                                            cursorColor: Color(
                                                                0xff4b39ef),
                                                            obscureText: true,
                                                            hintCharacter: '●',
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            pinTheme: PinTheme(
                                                              fieldHeight: 44.0,
                                                              fieldWidth: 44.0,
                                                              borderWidth: 2.0,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        12.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        12.0),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        12.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        12.0),
                                                              ),
                                                              shape:
                                                                  PinCodeFieldShape
                                                                      .box,
                                                              activeColor: Color(
                                                                  0xFF017E07),
                                                              inactiveColor:
                                                                  Colors.grey,
                                                              selectedColor:
                                                                  Color(
                                                                      0xff4b39ef),
                                                              activeFillColor:
                                                                  Color(
                                                                      0xFF017E07),
                                                              inactiveFillColor:
                                                                  Colors.grey,
                                                              selectedFillColor:
                                                                  Color(
                                                                      0xff4b39ef),
                                                              errorBorderColor:
                                                                  Colors.red,
                                                            ),
                                                            onCompleted:
                                                                (value) async {
                                                              pinCode = value;
                                                              print(pinCode);

                                                              final SharedPreferences
                                                                  prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              await prefs
                                                                  .setString(
                                                                      'pinCode',
                                                                      pinCode);
                                                              print(pinCode);
                                                            },
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter your Pincode';
                                                              }
                                                              if (value
                                                                      .length !=
                                                                  6) {
                                                                return 'Please enter a 6 digit Pincode';
                                                              }
                                                              return null;
                                                            },
                                                            autovalidateMode:
                                                                AutovalidateMode
                                                                    .onUserInteraction,
                                                            onChanged: (String
                                                                value) {},
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Checkbox(
                                                            value:
                                                                _isPrivacyChecked,
                                                            onChanged: (bool?
                                                                newValue) {
                                                              setState(() {
                                                                _isPrivacyChecked =
                                                                    newValue ??
                                                                        false;
                                                              });
                                                            },
                                                          ),
                                                          Expanded(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                showCupertinoModalPopup(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return StatefulBuilder(builder: (BuildContext
                                                                              context,
                                                                          StateSetter
                                                                              setState) {
                                                                        return Center(
                                                                          child:
                                                                              Card(
                                                                            color: const Color.fromARGB(
                                                                                234,
                                                                                255,
                                                                                255,
                                                                                255),
                                                                            elevation:
                                                                                0,
                                                                            margin: const EdgeInsets.fromLTRB(
                                                                                10,
                                                                                200,
                                                                                10,
                                                                                200),
                                                                            child:
                                                                                SingleChildScrollView(
                                                                              child: Column(
                                                                                children: [
                                                                                  Center(
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(15.0),
                                                                                      child: Text(
                                                                                        "Data Privacy Policy",
                                                                                        style: GoogleFonts.readexPro(
                                                                                          fontSize: 20.0,
                                                                                          textStyle: const TextStyle(
                                                                                            color: Color.fromARGB(255, 0, 0, 0),
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                                                                    child: SizedBox(
                                                                                      width: MediaQuery.of(context).size.width - 20,
                                                                                      child: Center(
                                                                                        child: Container(
                                                                                          child: Text(
                                                                                            'By checking this, I agree to use all the information I provided for the system purposes that will help me in any way that the system may offer. Also, all information that I will provide will be protected by the Data Privacy Act of 2012 and will only be served for the benefit of the intended purpose of the researchers. Furthermore, all the data I present is true and nothing but the truth. If in any case I provide wrong information, the system and the researchers will not be held liable for any miscalculation of the system because of ignorance.',
                                                                                            style: GoogleFonts.readexPro(
                                                                                              fontSize: MediaQuery.of(context).textScaler.scale(14),
                                                                                            ),
                                                                                            textAlign: TextAlign.justify,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });
                                                                    });
                                                              },
                                                              child: Text(
                                                                "I agree to the Data Privacy Policy.",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize: 13,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 1.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 0.0, 0.0, 16.0),
                                    child: smooth_page_indicator
                                        .SmoothPageIndicator(
                                      controller: _pageController,
                                      count: 5,
                                      axisDirection: Axis.horizontal,
                                      onDotClicked: (i) async {
                                        null;
                                        /* 
                                        _pageController.animateToPage(
                                          i,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease,
                                        ); */
                                      },
                                      effect: smooth_page_indicator
                                          .ExpandingDotsEffect(
                                        expansionFactor: 3.0,
                                        spacing: 8.0,
                                        radius: 16.0,
                                        dotWidth: 30.0,
                                        dotHeight: 10.0,
                                        dotColor:
                                            Color.fromARGB(40, 75, 57, 239),
                                        activeDotColor: Color(0xff4b39ef),
                                        paintStyle: PaintingStyle.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 10.0, 24.0, 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    TextButton(
                                      onPressed: _previousPage,
                                      child: Text("Back"),
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.2),
                                        foregroundColor: Color(0xff4b39ef),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _nextPage,
                                child: Text(nextText),
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xff4b39ef),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              /*ElevatedButton(
                                onPressed: () async {
                                  // Assuming you have variables email, password, and username
                                  await signUp(username!,password!);
                                },
                              child: Text(nextText),
    
                              style: TextButton.styleFrom(
                                backgroundColor: 
                                      Color(0xff4b39ef),
                                foregroundColor: Colors.white,
                              ),
                            ),*/
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: visible,
                    child: Positioned(
                      top: 10,
                      right: 15,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              IconlyBroken.login,
                              color: Color(0xff4b39ef),
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Log In',
                              style: GoogleFonts.readexPro(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                textStyle: TextStyle(
                                  color: Color(0xff4b39ef),
                                ),
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PageViewPage extends StatelessWidget {
  final List<Widget> children;

  PageViewPage({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}

class CheckboxGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implementation of Checkbox group widget
    return Container();
  }
}

class PincodeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 4,
      onChanged: (value) {},
      onCompleted: (value) {},
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.white,
      ),
    );
  }
}
