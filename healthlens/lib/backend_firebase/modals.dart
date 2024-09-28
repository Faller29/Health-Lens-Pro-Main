import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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
