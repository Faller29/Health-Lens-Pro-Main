import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    IconlyBold.user_2,
                    size: 120,
                    color: Colors.black,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Welcome to HealthLens Pro',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.switch_account,
                        color: Color(0xff4b39ef), size: 30),
                    label: Text(
                      'Change Account',
                      style: GoogleFonts.readexPro(
                        fontSize: 16.0,
                        textStyle: TextStyle(
                          color: Color(0xff4b39ef),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 70.0, 0.0, 0.0),
                      child: PinCodeTextField(
                        autoDisposeControllers: false,
                        appContext: context,
                        length: 6,
                        textStyle: GoogleFonts.readexPro(
                          fontSize: 18.0,
                        ),
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        enableActiveFill: false,
                        autoFocus: false,
                        enablePinAutofill: false,
                        errorTextSpace: 16.0,
                        showCursor: true,
                        cursorColor: Color(0xff4b39ef),
                        obscureText: false,
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
                          activeColor: Colors.black,
                          inactiveColor: Colors.grey,
                          selectedColor: Color(0xff4b39ef),
                          activeFillColor: Colors.black,
                          inactiveFillColor: Colors.grey,
                          selectedFillColor: Color(0xff4b39ef),
                        ),
                        onChanged: (_) {},
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle login button press
                      Navigator.pushReplacementNamed(context, '/entry_point');
                    },
                    child: Text('Log In'),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Handle forgot PIN button press
                      // Add your logic here
                    },
                    child: Text('Forgot PIN?'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
