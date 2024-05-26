import 'package:crea_radio_button/crea_radio_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:healthlens/login_page.dart';
import 'package:iconly/iconly.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

List<Map> categories = [
  {"name": "Diabetes [Type 1 & 2]", "isChecked": false},
  {"name": "Hypertension", "isChecked": false},
  {"name": "Obesity", "isChecked": false},
];

class _SetupPageState extends State<SetupPage> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;
  String label = "";
  List<RadioOption> options = [
    RadioOption("MALE", "Male"),
    RadioOption("FEMALE", "Female")
  ];
  String nextText = "Next";

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

  void _previousPage() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        _currentPageIndex--;
      });
      if (_currentPageIndex == 0) {
        setState(() {
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

  void _nextPage() {
    if (_currentPageIndex < 4) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        _currentPageIndex++;
        if (_currentPageIndex == 4) {
          nextText = "Finish";
        }
      });
      print(_currentPageIndex);
    } else if (_currentPageIndex == 4) {
      // Navigate to EntryPoint page
      Navigator.pushReplacementNamed(context, '/entry_point');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (currentFocus.hasFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.935,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: 10,
                    child: TextButton.icon(
                      label: Text(
                        'Log In',
                        style: GoogleFonts.readexPro(
                          fontSize: 14.0,
                          textStyle: TextStyle(
                            color: Color(0xff4b39ef),
                          ),
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      icon: Icon(
                        IconlyBroken.login,
                        color: Color(0xff4b39ef),
                        size: 20,
                      ),
                    ),
                  ),
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
                                    children: [
                                      PageViewPage(
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Text(
                                              'Welcome To HealthLens Pro!',
                                              style: GoogleFonts.outfit(
                                                fontSize: 40.0,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: AlignmentDirectional(
                                                -1.0, -1.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 4.0, 0.0, 15.0),
                                              child: Text(
                                                'HealthLens Pro is an Application to Help Manage Macronutrients intake.........',
                                                style: GoogleFonts.readexPro(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                'https://images.unsplash.com/photo-1494390248081-4e521a5940db?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxOHx8aGVhbHRofGVufDB8fHx8MTcxMzk1NDY2MXww&ixlib=rb-4.0.3&q=80&w=1080',
                                                width: 300.0,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.3,
                                                fit: BoxFit.cover,
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
                                                      'Please enter your name and sex to continue',
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
                                                                  decoration:
                                                                      InputDecoration(
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
                                                                        14.0,
                                                                  ),
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
                                                                  decoration:
                                                                      InputDecoration(
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
                                                                        14.0,
                                                                  ),
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
                                                                  decoration:
                                                                      InputDecoration(
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
                                                                        14.0,
                                                                  ),
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
                                                                          buttonHeight:
                                                                              30,
                                                                          buttonWidth:
                                                                              102,
                                                                          circular:
                                                                              true,
                                                                          mainColor: Colors
                                                                              .grey,
                                                                          selectedColor: Color(
                                                                              0xff4b39ef),
                                                                          selectedBorderSide: BorderSide(
                                                                              width:
                                                                                  1,
                                                                              color: Color(
                                                                                  0xff4b39ef)),
                                                                          preSelectedIdx:
                                                                              0,
                                                                          options:
                                                                              options,
                                                                          callback:
                                                                              (RadioOption val) {
                                                                            setState(() {
                                                                              label = val.label;
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
                                                          'STEP 2/4',
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
                                                      'Please enter your Age, Heigh, and Weight.',
                                                      style:
                                                          GoogleFonts.readexPro(
                                                        fontSize: 14.0,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Expanded(
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
                                                                keyboardType: TextInputType
                                                                    .numberWithOptions(
                                                                        decimal:
                                                                            false),
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .allow(RegExp(
                                                                          '[0-9]')),
                                                                ],
                                                                //onChanged: (value) => doubleVar = double.parse(value),

                                                                decoration:
                                                                    InputDecoration(
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
                                                                      14.0,
                                                                ),
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
                                                                          8.0,
                                                                          30.0,
                                                                          8.0,
                                                                          0.0),
                                                              child:
                                                                  TextFormField(
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
                                                                      14.0,
                                                                ),
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
                                                                          8.0,
                                                                          30.0,
                                                                          8.0,
                                                                          0.0),
                                                              child:
                                                                  TextFormField(
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
                                                                      14.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
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
                                                            elevation: 4,
                                                            shadowColor: Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
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
                                                                          10),
                                                                  child: Text(
                                                                    'Physical Lifestyle: ',
                                                                    style: GoogleFonts.readexPro(
                                                                        fontSize:
                                                                            18.0,
                                                                        fontWeight:
                                                                            FontWeight.bold),
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
                                                                          textStyle: TextStyle(fontSize: 14, color: Colors.white),
                                                                          mainColor: Colors.grey,
                                                                          selectedColor: Color(0xff4b39ef),
                                                                          selectedBorderSide: BorderSide(width: 1, color: Color(0xff4b39ef)),
                                                                          preSelectedIdx: 0,
                                                                          options: [
                                                                            RadioOption("INACTIVE ",
                                                                                "Inactive "),
                                                                            RadioOption("SEDENTARY",
                                                                                "Sedentary"),
                                                                            RadioOption("ACTIVE",
                                                                                "Active"),
                                                                          ],
                                                                          callback: (RadioOption val) {
                                                                            setState(() {
                                                                              label = val.label;
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
                                                        Text(
                                                          'Chronic Disease:',
                                                          style: GoogleFonts
                                                              .readexPro(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 0, 10),
                                                          child: Material(
                                                            elevation: 4,
                                                            shadowColor: Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          20.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children:
                                                                    categories.map(
                                                                        (disease) {
                                                                  return CheckboxListTile(
                                                                    title: Text(
                                                                        disease[
                                                                            'name']),
                                                                    checkboxShape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6),
                                                                    ),
                                                                    value: disease[
                                                                        'isChecked'],
                                                                    onChanged:
                                                                        (val) {
                                                                      setState(
                                                                          () {
                                                                        disease['isChecked'] =
                                                                            val;
                                                                      });
                                                                    },
                                                                  );
                                                                }).toList(),
                                                              ),
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
                                                          Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width /
                                                                1.5,
                                                            child:
                                                                TextFormField(
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Username',
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
                                                                fontSize: 14.0,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width /
                                                                1.5,
                                                            child: Container(
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            MediaQuery.sizeOf(context).width /
                                                                                2,
                                                                        child:
                                                                            TextFormField(
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                'Phone Number',
                                                                            labelStyle:
                                                                                GoogleFonts.outfit(
                                                                              fontSize: 15.0,
                                                                            ),
                                                                            enabledBorder:
                                                                                UnderlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Color(0xffe0e3e7),
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                            ),
                                                                            focusedBorder:
                                                                                UnderlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Color(0xff4b39ef),
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                            ),
                                                                            errorBorder:
                                                                                UnderlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Colors.black,
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                            ),
                                                                            focusedErrorBorder:
                                                                                UnderlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Colors.black,
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                            ),
                                                                          ),
                                                                          style:
                                                                              GoogleFonts.outfit(
                                                                            fontSize:
                                                                                14.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            6,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            IconButton(
                                                                          onPressed:
                                                                              (null),
                                                                          icon:
                                                                              Icon(
                                                                            Icons.send,
                                                                            color:
                                                                                Color(0xff4b39ef),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Container(
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                MediaQuery.sizeOf(context).width / 3,
                                                                            child:
                                                                                TextFormField(
                                                                              keyboardType: TextInputType.number,
                                                                              decoration: InputDecoration(
                                                                                labelText: 'Enter Code',
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
                                                                                    color: Colors.black,
                                                                                    width: 2.0,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                                ),
                                                                                focusedErrorBorder: UnderlineInputBorder(
                                                                                  borderSide: BorderSide(
                                                                                    color: Colors.black,
                                                                                    width: 2.0,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                                ),
                                                                              ),
                                                                              style: GoogleFonts.outfit(
                                                                                fontSize: 14.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          TextButton(
                                                                            child:
                                                                                Text(
                                                                              'verify',
                                                                              style: GoogleFonts.readexPro(
                                                                                fontSize: 14.0,
                                                                                fontWeight: FontWeight.bold,
                                                                                textStyle: TextStyle(
                                                                                  color: Color(0xff4b39ef),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            onPressed:
                                                                                (null),
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
                                                      SizedBox(
                                                        height: 30,
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
                                                            autoDisposeControllers:
                                                                false,
                                                            appContext: context,
                                                            length: 6,
                                                            textStyle:
                                                                GoogleFonts
                                                                    .readexPro(
                                                              fontSize: 18.0,
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
                                                            obscureText: false,
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
                                                              activeColor:
                                                                  Colors.black,
                                                              inactiveColor:
                                                                  Colors.grey,
                                                              selectedColor:
                                                                  Color(
                                                                      0xff4b39ef),
                                                              activeFillColor:
                                                                  Colors.black,
                                                              inactiveFillColor:
                                                                  Colors.grey,
                                                              selectedFillColor:
                                                                  Color(
                                                                      0xff4b39ef),
                                                            ),
                                                            onChanged: (_) {},
                                                            autovalidateMode:
                                                                AutovalidateMode
                                                                    .onUserInteraction,
                                                          ),
                                                        ),
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
                                                      SizedBox(
                                                        height: 50,
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
                                        _pageController.animateToPage(
                                          i,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease,
                                        );
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
                                        backgroundColor: Colors.grey[300],
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
                            ],
                          ),
                        ),
                      ],
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
