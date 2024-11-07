import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/backend_firebase/faq_data.dart';
import 'package:healthlens/main.dart'; // Assuming you have a main.dart file

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final String userId = thisUser!.uid;

  // Loading state
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 50,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PROFILE',
              style: GoogleFonts.outfit(fontSize: 12),
            ),
            Text(
              'Frequently Asked Questions',
              style: GoogleFonts.readexPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 0.9),
            ),
          ],
        ),
        backgroundColor: Color(0xff4b39ef),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            //padding: EdgeInsets.only(left: 100),
            color: Color(0xff4b39ef),
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.fromLTRB(70, 0, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* Center(
                  child: Text(
                    'Frequently Asked Questions',
                    style: GoogleFonts.readexPro(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ), */
                Text(
                  "Need Help? Contact our developers:",
                  style: GoogleFonts.readexPro(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  "jpfaller@ccc.edu.ph or 09057206375",
                  style: GoogleFonts.readexPro(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: faqItems.length,
              itemBuilder: (context, index) {
                final faq = faqItems[index];
                return Card(
                  color: Colors.white,
                  elevation: 3,
                  shadowColor: Colors.black54,
                  margin: EdgeInsets.all(10),
                  child: Material(
                    elevation: 5,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(
                          faq['question']!,
                          style: GoogleFonts.readexPro(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                            child: Text(
                              faq['answer']!,
                              style: GoogleFonts.readexPro(
                                fontSize: 13,
                                color: Colors.black.withOpacity(.7),
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
