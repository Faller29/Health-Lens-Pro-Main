import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/main.dart'; // Assuming you have a main.dart file

class AboutUs extends StatefulWidget {
  @override
  _AboutUs createState() => _AboutUs();
}

class _AboutUs extends State<AboutUs> {
  final String userId = thisUser!.uid;

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
              'About Us',
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/ccc.png',
                width: MediaQuery.sizeOf(context).width,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
              child: Text(
                'About HealthLens Pro',
                style: GoogleFonts.readexPro(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: GoogleFonts.readexPro(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(
                      text: '     HealthLens Pro ',
                      style: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          'is a mobile health application that will seek to help individuals with chronic illnesses such as ',
                    ),
                    TextSpan(
                      text:
                          'Diabetes (Type 1 and Type 2), Hypertension, and Obesity. ',
                      style: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          'This type of application uses camera phone to detect the food present whether it will harm or benefit a certain individual. It will also display corresponding Fats, Protein, and Carbohydrates that the food contains. ',
                    ),
                    TextSpan(
                      text: 'HealthLens Pro',
                      style: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' also contains different features such as meal planner, exercise recommendation, and a lot more.\n\n',
                    ),
                    TextSpan(
                      text: '     Here in HealthLens Pro',
                    ),
                    TextSpan(
                      text: ', ',
                    ),
                    TextSpan(
                      text:
                          'we value your HEALTH, PROmoting a brighter tomorrow through the digital LENS.',
                      style: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Text(
                    'Core Values',
                    style: GoogleFonts.readexPro(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    width: 100,
                    child: Divider(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Text(
                'Compassion',
                style: GoogleFonts.readexPro(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 20, 10),
              child: Text(
                'Our Team promote sympathy towards an individual health helping them to be better.',
                style: GoogleFonts.readexPro(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Text(
                'Quality',
                style: GoogleFonts.readexPro(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 20, 10),
              child: Text(
                'With great collaboration and feedback between professionals such as medical practitioners, we offer optimal outcomes serving the community.',
                style: GoogleFonts.readexPro(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Text(
                'Diversity and Integrity',
                style: GoogleFonts.readexPro(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 20, 30),
              child: Text(
                'Our Team advocates inclusivity and honesty following ethical codes.',
                style: GoogleFonts.readexPro(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: Column(
                  children: [
                    Text(
                      'Team Behind the Lens',
                      style: GoogleFonts.readexPro(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Material(
                color: Color(0xff4b39ef),
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/faller.jpg',
                      fit: BoxFit.cover,
                      width: 150,
                      height: 150,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'John Peter Faller',
                              style: GoogleFonts.readexPro(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.readexPro(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Designation: ',
                                  style: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                    text: 'Programmer (Front-End & Back-End)')
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.readexPro(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Email: ',
                                  style: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: 'jpfaller@ccc.edu.ph'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.readexPro(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    FontAwesomeIcons.linkedin,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(text: '/faller29')
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.readexPro(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              children: [
                                WidgetSpan(
                                    child: Icon(
                                  FontAwesomeIcons.github,
                                  size: 15,
                                  color: Colors.white,
                                )),
                                TextSpan(text: '/Faller29')
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Material(
                color: Color(0xff4b39ef),
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/renzy.jpg',
                      fit: BoxFit.cover,
                      width: 150,
                      height: 150,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Renzy Gutierrez',
                              style: GoogleFonts.readexPro(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.readexPro(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Designation: ',
                                  style: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                    text:
                                        'Documentation, Data Researcher & Programmer')
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.readexPro(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Email: ',
                                  style: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: 'rcgutierrez@ccc.edu.ph'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.readexPro(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              children: [
                                WidgetSpan(
                                    child: Icon(
                                  FontAwesomeIcons.github,
                                  size: 15,
                                  color: Colors.white,
                                )),
                                TextSpan(text: '/StarryTraveller')
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Material(
                color: Color(0xff4b39ef),
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/ocampo.jpg',
                      fit: BoxFit.cover,
                      width: 150,
                      height: 150,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Christian Nicholle Ocampo',
                              style: GoogleFonts.readexPro(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.readexPro(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Designation: ',
                                  style: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                    text: 'Data Researcher & Documentation')
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.readexPro(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Email: ',
                                  style: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: 'cvocampo@ccc.edu.ph'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Material(
                elevation: 3,
                color: Color(0xff4b39ef),
                borderRadius: BorderRadius.circular(10),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/garino.jpg',
                      fit: BoxFit.cover,
                      width: 150,
                      height: 150,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Dwight John Garino',
                              style: GoogleFonts.readexPro(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.readexPro(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Designation: ',
                                  style: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                    text: 'Data Researcher & Documentation')
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.readexPro(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Email: ',
                                  style: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: 'dvgarino@ccc.edu.ph'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
