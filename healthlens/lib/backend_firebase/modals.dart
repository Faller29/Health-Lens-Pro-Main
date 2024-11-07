import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/setup.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;

void mealPlanGeneratorSelector(BuildContext context) async {
  showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Center(
            child: Card(
              color: Colors.white,
              elevation: 5,
              shadowColor: Color(0xff4b39ef),
              margin: const EdgeInsets.fromLTRB(10, 150, 10, 150),
              child: Container(
                height: 250,
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Create Meal Plan",
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
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        child: Center(
                          child: Text(
                            'Choose a Meal Plan Generator.\n\n'
                            'Auto Generate Meal Plan using the System or Manually Create One',
                            style: GoogleFonts.readexPro(
                              fontSize:
                                  MediaQuery.of(context).textScaler.scale(14),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff4b39ef)),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                                Navigator.pushNamed(context, '/mealCreator');
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.book,
                                    color: Color(0xffffffff),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    'Manual',
                                    style: GoogleFonts.readexPro(
                                      textStyle: const TextStyle(
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff4b39ef)),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog

                                Navigator.pushNamed(context, '/mealPlan');
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.auto_mode,
                                    color: Color(0xffffffff),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    'Auto',
                                    style: GoogleFonts.readexPro(
                                      textStyle: const TextStyle(
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
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
}

// Function to change the PIN
Future<String> changePin(BuildContext context, String email, String currentPin,
    String newPin) async {
  String message = '';
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Re-authenticate the user with email and current password (PIN)
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: currentPin);
      UserCredential userCredential =
          await user.reauthenticateWithCredential(credential);

      // Check if the re-authenticated user UID matches the current user UID
      if (userCredential.user?.uid == user.uid) {
        // If UIDs match, update the password (PIN)
        await user.updatePassword(newPin);
        message = "PIN updated successfully";
      } else {
        // If UIDs don't match, show an error message

        message = "Error: User mismatch. Please try again.";
      }
    }
  } catch (e) {
    message = 'Error during PIN update: ${e.toString()}';
  }
  return message;
}

// Function to display the PIN code modal
void showPinCodeModal(BuildContext context) {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();

  showCupertinoModalPopup(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: Card(
          color: Colors.white,
          shadowColor: Colors.black,
          elevation: 3,
          margin: const EdgeInsets.fromLTRB(10, 160, 10, 160),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Text(
                      'Update Pin Code',
                      style: GoogleFonts.readexPro(
                        fontSize: 20.0,
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Current Email',
                        style: GoogleFonts.readexPro(
                          fontSize: 14.0,
                          textStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Email Input Field
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      controller: _emailController,
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
                        labelText: 'Enter Current Email',
                        labelStyle: GoogleFonts.readexPro(fontSize: 14),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 15, 0, 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Current Pincode',
                        style: GoogleFonts.readexPro(
                          fontSize: 14.0,
                          textStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ), // Current PIN Input Field
                  PinCodeTextField(
                    blinkWhenObscuring: true,
                    textInputAction: TextInputAction.next,
                    controller: _currentPinController,
                    autoDisposeControllers: false,
                    appContext: context,
                    length: 6,
                    textStyle: GoogleFonts.readexPro(
                      fontSize: 14.0,
                    ),
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'New Pincode',
                        style: GoogleFonts.readexPro(
                          fontSize: 14.0,
                          textStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ), // New PIN Input Field
                  PinCodeTextField(
                    blinkWhenObscuring: true,
                    controller: _newPinController,
                    autoDisposeControllers: false,
                    appContext: context,
                    length: 6,
                    textStyle: GoogleFonts.readexPro(
                      fontSize: 14.0,
                    ),
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white30),
                          backgroundColor: MaterialStatePropertyAll<Color>(
                            Colors.redAccent,
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
                          ), /* 
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                          ), */
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.readexPro(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white30),
                          backgroundColor: MaterialStatePropertyAll<Color>(
                            Colors.greenAccent,
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
                          ), /* 
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                          ), */
                        ),
                        onPressed: () async {
                          // Get user inputs
                          String email = _emailController.text;
                          String currentPin = _currentPinController.text;
                          String newPin = _newPinController.text;
                          String result = '';
                          // Validate inputs
                          if (email.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Email cannot be empty.")),
                            );
                          } else if (currentPin.length != 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("Current PIN must be 6 digits.")),
                            );
                          } else if (newPin.length != 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("New PIN must be 6 digits.")),
                            );
                          } else {
                            // Call the function to change the PIN
                            final snackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              elevation: 3,
                              content: Row(
                                children: [
                                  CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(child: Text('Processing....')),
                                ],
                              ),
                              duration: Duration(
                                  minutes:
                                      1), // Keep it visible until dismissed
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);

                            result = await changePin(
                                context, email, currentPin, newPin);
                          }
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          if (result != '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  elevation: 5,
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                  content: Text(result)),
                            );

                            Navigator.pop(context);
                          }
                          // Close the modal
                        },
                        child: Text(
                          'Change Pin',
                          style: GoogleFonts.readexPro(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget buildMacronutrientCard(
    String title, double current, int limit, Color color, double percent) {
  /* if (current >= limit) {
    String thislimitation = limit.toString();
    current = double.tryParse(thislimitation)!;
    //limitCurrent = current;
  } /* else {
    String thislimitation = limit.toString();
    limitCurrent = double.tryParse(thislimitation)!;
  } */ */

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
        child: Text(
          title,
          style: GoogleFonts.readexPro(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
      CircularPercentIndicator(
        radius: 40.0,
        lineWidth: 14.0,
        animation: true,
        percent: percent,
        center: Text(
          '${(current / limit * 100).toStringAsFixed(0)}%',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: color,
      ),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.readexPro(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            textStyle: const TextStyle(),
          ),
          children: [
            WidgetSpan(
              child: SizedBox(
                width: 20,
              ),
            ),
            TextSpan(
                text: '${(current.toStringAsFixed(0))}/${limit} ',
                style: GoogleFonts.readexPro(
                  color: color,
                )),
            WidgetSpan(
              child: Transform.translate(
                offset: const Offset(0.0, -5.0),
                child: Text(
                  '+${(limit! * 0.20).toStringAsFixed(0)}',
                  style: GoogleFonts.readexPro(
                      fontSize: 11, color: Color(0xFF009C51)),
                ),
              ),
            )
          ],
        ),
      ),

      /* Text(
        '${current.toStringAsFixed(0)}/${limit}',
        style: GoogleFonts.readexPro(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ), */
    ],
  );
}

Future<void> appTutorial(BuildContext context) {
  int _currentPageIndex = 0;

  return showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          PageController _pageController = PageController(initialPage: 0);
          String nextText = "Next";
          setState(() {
            if (_currentPageIndex == 4) {
              nextText = "Finish";
            }
          });
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

          void _nextPage() {
            if (_currentPageIndex < 4) {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            }
            print(_currentPageIndex);
            print((_currentPageIndex >= 4));
            if (_currentPageIndex >= 4) {
              Navigator.of(context).pop(); // Close the modal on "Finish"
            }
          }

          void _previousPage() {
            _pageController.previousPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          }

          return Center(
            child: Card(
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(10, 70, 10, 70),
              child: Theme(
                data: ThemeData(
                  textTheme: GoogleFonts.readexProTextTheme(),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'How To use',
                        style: GoogleFonts.readexPro(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          PageView(
                            controller: _pageController,
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            onPageChanged: _handlePageChange,
                            children: [
                              PageViewPage(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Understanding Dashboard',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          RichText(
                                              textAlign: TextAlign.justify,
                                              text: TextSpan(
                                                  style: GoogleFonts.readexPro(
                                                      color: Colors.black),
                                                  children: [
                                                    TextSpan(
                                                      text: "Dashboard ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            "contains utilities that will help user in their daily management of macronutrients intake. It consists of Macronutrients section which shows the user's current Macronutrients Count and Calories. "),
                                                  ])),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Card(
                                            color: Colors.white,
                                            shadowColor: Colors.black,
                                            elevation: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  RichText(
                                                    textAlign:
                                                        TextAlign.justify,
                                                    text: TextSpan(
                                                      style:
                                                          GoogleFonts.readexPro(
                                                              color:
                                                                  Colors.black),
                                                      children: [
                                                        TextSpan(text: "The "),
                                                        TextSpan(
                                                          text: "Dashboard ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        TextSpan(
                                                            text:
                                                                "consists of Macronutrients section which shows the User's current Macronutrients Count and Calories.")
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        // Show full image in CupertinoModalPopup when thumbnail is clicked
                                                        showCupertinoDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return FullImageModal(
                                                                imagePath:
                                                                    'assets/images/sum.jpg');
                                                          },
                                                        );
                                                      },
                                                      child: Image.asset(
                                                        'assets/images/sum.jpg',
                                                        height: 200,
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                    context)
                                                                .width,
                                                        fit: BoxFit.cover,
                                                      )),
                                                  Text(
                                                    'Click image to full view',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black54),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "1. Shows the Macronutrients count in percentage and your current macronutrients count as well as the maximum macronutrients that you must fill.\n\n2. Represents the additional 20% from your maximum macronutrients giving you a total of 120% of macronutrients that you can fill daily. Once the system detects that the user will exceed the120% of macronutrients consumption, it will not let the user to add more as the system warns the user that it will be harmful for their health.",
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            height: 20,
                                          ),
                                          //HealthInfo
                                          Card(
                                            elevation: 3,
                                            color: Colors.white,
                                            shadowColor: Colors.black,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        // Show full image in CupertinoModalPopup when thumbnail is clicked
                                                        showCupertinoDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return FullImageModal(
                                                                imagePath:
                                                                    'assets/images/2.jpg');
                                                          },
                                                        );
                                                      },
                                                      child: Card(
                                                        elevation: 3,
                                                        child: Image.asset(
                                                          'assets/images/2.jpg',
                                                          height: 200,
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                      context)
                                                                  .width,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )),
                                                  Text(
                                                    'Click image to full view',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black54),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  RichText(
                                                    textAlign:
                                                        TextAlign.justify,
                                                    text: TextSpan(
                                                      style:
                                                          GoogleFonts.readexPro(
                                                              color:
                                                                  Colors.black),
                                                      children: [
                                                        TextSpan(text: "The"),
                                                        TextSpan(
                                                          text:
                                                              " Health Information ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        TextSpan(
                                                            text:
                                                                "button contains information about the User's Health and Weight Prediction. It depicts the predicted estimation of weight in Days, Weeks, and Months as well as the user’s summary of health details. This also contains the harmful food that the user should avoid or be aware. ")
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              PageViewPage(
                                children: [
                                  Expanded(
                                      child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Understanding Dashboard',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        RichText(
                                            textAlign: TextAlign.justify,
                                            text: TextSpan(
                                                style: GoogleFonts.readexPro(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "HealthLens Pro also provides user to help in creating their  ",
                                                  ),
                                                  TextSpan(
                                                    text: "Meal Plan ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "by clicking the Meal Plan button and selecting between creating on your own or letting the application create Meal Plan options that you can select.",
                                                  ),
                                                ])),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              // Show full image in CupertinoModalPopup when thumbnail is clicked
                                              showCupertinoDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return FullImageModal(
                                                      imagePath:
                                                          'assets/images/3.jpg');
                                                },
                                              );
                                            },
                                            child: Image.asset(
                                              'assets/images/3.jpg',
                                              height: 200,
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              fit: BoxFit.cover,
                                            )),
                                        Text(
                                          'Click image to full view',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black54),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Card(
                                          color: Colors.white,
                                          shadowColor: Colors.black,
                                          elevation: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                RichText(
                                                    textAlign:
                                                        TextAlign.justify,
                                                    text: TextSpan(
                                                        style: GoogleFonts
                                                            .readexPro(
                                                                color: Colors
                                                                    .black),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                "1. Manual Button  ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                "will let the user create their own meal plan that they see fit for their diet. The user can choose to the variety of food present in the application.",
                                                          ),
                                                        ])),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      // Show full image in CupertinoModalPopup when thumbnail is clicked
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return FullImageModal(
                                                              imagePath:
                                                                  'assets/images/4.jpg');
                                                        },
                                                      );
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/4.jpg',
                                                      height: 200,
                                                      width: MediaQuery.sizeOf(
                                                              context)
                                                          .width,
                                                      fit: BoxFit.cover,
                                                    )),
                                                Text(
                                                  'Click image to full view',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black54),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                RichText(
                                                    textAlign:
                                                        TextAlign.justify,
                                                    text: TextSpan(
                                                        style: GoogleFonts
                                                            .readexPro(
                                                                color: Colors
                                                                    .black),
                                                        children: [
                                                          TextSpan(
                                                            text: " 1.1  ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                "Once the user clicked on a certain food, there are instance where the user will see a ",
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                "Warning Icon. ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                "This indicates that the specific food is harmful to the user and advised to not include it in their Meal Plan.",
                                                          ),
                                                        ])),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      // Show full image in CupertinoModalPopup when thumbnail is clicked
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return FullImageModal(
                                                              imagePath:
                                                                  'assets/images/5.jpg');
                                                        },
                                                      );
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/5.jpg',
                                                      height: 200,
                                                      width: MediaQuery.sizeOf(
                                                              context)
                                                          .width,
                                                      fit: BoxFit.cover,
                                                    )),
                                                Text(
                                                  'Click image to full view',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black54),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          height: 20,
                                        ),
                                        //HealthInfo
                                        Card(
                                          elevation: 3,
                                          color: Colors.white,
                                          shadowColor: Colors.black,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                RichText(
                                                  textAlign: TextAlign.justify,
                                                  text: TextSpan(
                                                    style:
                                                        GoogleFonts.readexPro(
                                                            color:
                                                                Colors.black),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            "Auto Generate Button ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              "offers a range of predetermined list of meal plan for the user. The system will create an automatic meal plan for the user considering their health which means that the system will not provide a food that will be harmful to the user.")
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      // Show full image in CupertinoModalPopup when thumbnail is clicked
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return FullImageModal(
                                                              imagePath:
                                                                  'assets/images/6.jpg');
                                                        },
                                                      );
                                                    },
                                                    child: Card(
                                                      elevation: 3,
                                                      child: Image.asset(
                                                        'assets/images/6.jpg',
                                                        height: 200,
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                    context)
                                                                .width,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )),
                                                Text(
                                                  'Click image to full view',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black54),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                              PageViewPage(
                                children: [
                                  Expanded(
                                      child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Understanding Camera Page',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        RichText(
                                            textAlign: TextAlign.justify,
                                            text: TextSpan(
                                                style: GoogleFonts.readexPro(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                    text: "Camera Page ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        " uses object detection for you to scan Food that you are about to eat.",
                                                  ),
                                                ])),
                                        SizedBox(
                                          height: 10,
                                        ),

                                        Card(
                                          color: Colors.white,
                                          shadowColor: Colors.black,
                                          elevation: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                RichText(
                                                    textAlign:
                                                        TextAlign.justify,
                                                    text: TextSpan(
                                                        style: GoogleFonts
                                                            .readexPro(
                                                                color: Colors
                                                                    .black),
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                                  "Once you click"),
                                                          TextSpan(
                                                            text:
                                                                " Start Detection ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                "It will start scanning for food for 10 seconds. If the Application does not detect any food within 10 seconds, it will prompt the user to rescan again.",
                                                          ),
                                                        ])),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      // Show full image in CupertinoModalPopup when thumbnail is clicked
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return FullImageModal(
                                                              imagePath:
                                                                  'assets/images/8.jpg');
                                                        },
                                                      );
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/8.jpg',
                                                      height: 200,
                                                      width: MediaQuery.sizeOf(
                                                              context)
                                                          .width,
                                                      fit: BoxFit.cover,
                                                    )),
                                                Text(
                                                  'Click image to full view',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black54),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          height: 20,
                                        ),
                                        //HealthInfo
                                        Card(
                                          elevation: 3,
                                          color: Colors.white,
                                          shadowColor: Colors.black,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                RichText(
                                                    textAlign:
                                                        TextAlign.justify,
                                                    text: TextSpan(
                                                        style: GoogleFonts
                                                            .readexPro(
                                                                color: Colors
                                                                    .black),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                "If the application Detected a Food, it will List the scan Food in the ",
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                "Foods Detected Section.",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ])),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      // Show full image in CupertinoModalPopup when thumbnail is clicked
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return FullImageModal(
                                                              imagePath:
                                                                  'assets/images/9.jpg');
                                                        },
                                                      );
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/9.jpg',
                                                      height: 200,
                                                      width: MediaQuery.sizeOf(
                                                              context)
                                                          .width,
                                                      fit: BoxFit.cover,
                                                    )),
                                                Text(
                                                  'Click image to full view',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black54),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                RichText(
                                                  textAlign: TextAlign.justify,
                                                  text: TextSpan(
                                                    style:
                                                        GoogleFonts.readexPro(
                                                            color:
                                                                Colors.black),
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                              "If you are satisfied in the results/foods detected, click the "),
                                                      TextSpan(
                                                        text:
                                                            "Eat Food Button ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              "to continue to the next page where you are to confirm the details.")
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          height: 20,
                                        ),
                                        Card(
                                          elevation: 3,
                                          color: Colors.white,
                                          shadowColor: Colors.black,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                RichText(
                                                    textAlign:
                                                        TextAlign.justify,
                                                    text: TextSpan(
                                                        style: GoogleFonts
                                                            .readexPro(
                                                                color: Colors
                                                                    .black),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                "This is the ",
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                "Food Serving Page",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                " where you will be reviewing the details or serving and quantity of the food detected by the application. If there are any Missing foods, you can Click the ",
                                                          ),
                                                          TextSpan(
                                                            text: "Add button ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                "to add a food that is not detected by the Application.\n",
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                "The user has also the power to edit the food such as adding quantity by clicking the plus (+) and minus (-) button as well as delete the food by clicking the delete button if in any case the food detected is wrong.",
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                "Once done and completed, the user can click ",
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                "Confirm button ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                "to add this in your data and to update your Macronutrients.",
                                                          ),
                                                        ])),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      // Show full image in CupertinoModalPopup when thumbnail is clicked
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return FullImageModal(
                                                              imagePath:
                                                                  'assets/images/10.jpg');
                                                        },
                                                      );
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/10.jpg',
                                                      height: 200,
                                                      width: MediaQuery.sizeOf(
                                                              context)
                                                          .width,
                                                      fit: BoxFit.cover,
                                                    )),
                                                Text(
                                                  'Click image to full view',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black54),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      // Show full image in CupertinoModalPopup when thumbnail is clicked
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return FullImageModal(
                                                              imagePath:
                                                                  'assets/images/11.jpg');
                                                        },
                                                      );
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/11.jpg',
                                                      width: MediaQuery.sizeOf(
                                                              context)
                                                          .width,
                                                      fit: BoxFit.fill,
                                                    )),
                                                Text(
                                                  'Click image to full view',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black54),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                      style:
                                                          GoogleFonts.readexPro(
                                                              color:
                                                                  Colors.black),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              "In order to determine the right serving size, users are advised to use measuring cups. However, if there are no present measuring cups, be advised that you can use your fist or hand to determine the level of serving size.\n\nTake note that",
                                                        ),
                                                        TextSpan(
                                                          text: " A CUP ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        TextSpan(
                                                            text:
                                                                "of food (e.g. cup of rice) is equivalent to a"),
                                                        TextSpan(
                                                          text:
                                                              " CLOSED ADULT FIST",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        TextSpan(
                                                            text:
                                                                ". By establishing this technique, you can estimate the measurement of a cup."),
                                                      ]),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      // Show full image in CupertinoModalPopup when thumbnail is clicked
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return FullImageModal(
                                                              imagePath:
                                                                  'assets/images/serving.jpg');
                                                        },
                                                      );
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/serving.jpg',
                                                      width: MediaQuery.sizeOf(
                                                              context)
                                                          .width,
                                                      fit: BoxFit.fill,
                                                    )),
                                                Text(
                                                  'Click image to full view',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black54),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                              PageViewPage(
                                children: [
                                  Expanded(
                                      child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Understanding Analytics Page',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        RichText(
                                            textAlign: TextAlign.justify,
                                            text: TextSpan(
                                                style: GoogleFonts.readexPro(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "This page will show the users progress in terms of consumption of the Macronutrients. The user can view their progress for the last 24 hours, 7 Days, and 30 Days by just swiping left or right the arrow. The user can also view individual Macronutrients by just clicking the Fats, Protein, and Carbohydrates. Lastly in the Analytics Page, the user can view their history by just clicking the ",
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "Check History Button.",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ])),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              // Show full image in CupertinoModalPopup when thumbnail is clicked
                                              showCupertinoDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return FullImageModal(
                                                      imagePath:
                                                          'assets/images/12.jpg');
                                                },
                                              );
                                            },
                                            child: Image.asset(
                                              'assets/images/12.jpg',
                                              height: 200,
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              fit: BoxFit.cover,
                                            )),
                                        Text(
                                          'Click image to full view',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black54),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              // Show full image in CupertinoModalPopup when thumbnail is clicked
                                              showCupertinoDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return FullImageModal(
                                                      imagePath:
                                                          'assets/images/13.jpg');
                                                },
                                              );
                                            },
                                            child: Image.asset(
                                              'assets/images/13.jpg',
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              fit: BoxFit.fill,
                                            )),
                                        Text(
                                          'Click image to full view',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black54),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                              PageViewPage(
                                children: [
                                  Expanded(
                                      child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Understanding Profile Page',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        RichText(
                                            textAlign: TextAlign.justify,
                                            text: TextSpan(
                                                style: GoogleFonts.readexPro(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "Users can edit different information by just clicking the buttons such as ",
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "Edit User Profile and Edit Health Profile.",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "The user can also change their pin code in this page. Lastly, the user can view general information such as Frequently Asked Questions by clicking the ",
                                                  ),
                                                  TextSpan(
                                                    text: "FAQs ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "and get to know the amazing team behind the HealthLens Pro by just clicking the ",
                                                  ),
                                                  TextSpan(
                                                    text: "About Us.",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ])),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              // Show full image in CupertinoModalPopup when thumbnail is clicked
                                              showCupertinoDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return FullImageModal(
                                                      imagePath:
                                                          'assets/images/14.jpg');
                                                },
                                              );
                                            },
                                            child: Image.asset(
                                              'assets/images/14.jpg',
                                              height: 200,
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              fit: BoxFit.cover,
                                            )),
                                        Text(
                                          'Click image to full view',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black54),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ))
                                ],
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
                        child: smooth_page_indicator.SmoothPageIndicator(
                          controller: _pageController,
                          count: 5,
                          axisDirection: Axis.horizontal,
                          effect: smooth_page_indicator.ExpandingDotsEffect(
                            expansionFactor: 3.0,
                            spacing: 8.0,
                            radius: 16.0,
                            dotWidth: 30.0,
                            dotHeight: 10.0,
                            dotColor: Color.fromARGB(40, 75, 57, 239),
                            activeDotColor: Color(0xff4b39ef),
                            paintStyle: PaintingStyle.fill,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _previousPage,
                            child: Text('Back'),
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xff4b39ef),
                              foregroundColor: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 50,
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
            ),
          );
        },
      );
    },
  );
}

class FullImageModal extends StatelessWidget {
  final String imagePath;

  FullImageModal({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close the modal when tapped
        Navigator.pop(context);
      },
      child: Container(
        /*  margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
        height: (MediaQuery.sizeOf(context).height - 100),
        width: (MediaQuery.sizeOf(context).width -
            (MediaQuery.sizeOf(context).width * 0.1)), */
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain, // Make sure the image fits within the screen
            height: (MediaQuery.sizeOf(context).height -
                (MediaQuery.sizeOf(context).height * 0.2)),
            width: (MediaQuery.sizeOf(context).width -
                (MediaQuery.sizeOf(context).width * 0.2)),
          ),
        ),
      ),
    );
  }
}
