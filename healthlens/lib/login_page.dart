import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/entry_point.dart';
import 'package:healthlens/homepage.dart';
import 'package:healthlens/setup.dart';
import 'package:iconly/iconly.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 670.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
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
                          fontSize: 48.0,
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
                      padding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 12.0, 16.0, 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              print('Button pressed ...');
                            },
                            label: Text(
                              'Change Account',
                              style: GoogleFonts.urbanist(
                                color: Colors.black,
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            icon: FaIcon(
                              FontAwesomeIcons.exchangeAlt,
                              color: Color(0xFF101213),
                              size: 11.0,
                            ),
                            style: ButtonStyle(
                              side: MaterialStatePropertyAll(
                                BorderSide(
                                  color: Color(0xFFE0E3E7),
                                  width: 1.0,
                                ),
                              ),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      50.0), // Set the desired border radius
                                ),
                              ),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.fromLTRB(15, 10, 15, 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'John Peter Faller',
                          style: GoogleFonts.urbanist(
                            color: Colors.black,
                            fontSize: 22.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
                                      style: GoogleFonts.readexPro(
                                        fontSize: 14.0,
                                        textStyle: const TextStyle(
                                          color: Color(0xff4b39ef),
                                        ),
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                    onPressed: () {
                                      print('Button pressed ...');
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EntryPoint(),
                          ),
                        );
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
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 24.0, 0.0, 64.0),
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
                              )
                            ],
                          ),
                        ))
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
