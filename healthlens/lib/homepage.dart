import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/models/category_model.dart';
import 'package:healthlens/widgets/hero_carousel_card.dart';
import 'package:iconly/iconly.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';

const double contWidth = 100;
const double contHeight = 140;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: SafeArea(
        child: ListView(
          addAutomaticKeepAlives: true,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
              child: Container(
                width: 411.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                ),
                child: // Generated code for this Row Widget...
                    Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(14.0, 0.0, 14.0, 0.0),
                      child: Container(
                        width: 80.0,
                        height: 80.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          'https://picsum.photos/seed/529/600',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 14.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Peter Faller',
                            style: GoogleFonts.readexPro(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '17 Years Old',
                            style: GoogleFonts.readexPro(
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            'Weight: 75KG',
                            style: GoogleFonts.readexPro(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(14.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 122.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Color(0xff4b39ef),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(0.0),
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(0.0),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'DAY 01',
                                    style: GoogleFonts.readexPro(
                                      fontSize: 22.0,
                                      textStyle: TextStyle(
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Time: 11:30',
                                    style: GoogleFonts.readexPro(
                                      fontSize: 12.0,
                                      textStyle: TextStyle(
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'BMI: Normal',
                                style: GoogleFonts.readexPro(
                                  fontSize: 16.0,
                                  textStyle: TextStyle(
                                    color: Color(0xffffffff),
                                  ),
                                ),
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
            Container(
              width: 50.0,
              height: 210.0,
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4.0,
                    color: Color(0x33000000),
                    offset: Offset(
                      0.0,
                      2.0,
                    ),
                  )
                ],
                borderRadius: BorderRadius.circular(8.0),
                shape: BoxShape.rectangle,
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 14.0),
                    child: Text(
                      "Macronutrients",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // First division or column
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 8.0),
                                child: Text(
                                  'Carbohydrates',
                                  style: GoogleFonts.readexPro(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    textStyle: TextStyle(
                                      color: Color(0xff4b39ef),
                                    ),
                                  ),
                                ),
                              ),
                              CircularPercentIndicator(
                                radius: 40.0,
                                lineWidth: 14.0,
                                animation: true,
                                percent: 0.7,
                                center: new Text(
                                  "70.0%",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                header: Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          10.0), // Adjust bottom padding as needed
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Colors.amberAccent,
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Second division or column
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 8.0),
                                child: Text(
                                  'Protein',
                                  style: GoogleFonts.readexPro(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    textStyle: TextStyle(
                                      color: Color(0xffff5963),
                                    ),
                                  ),
                                ),
                              ),
                              CircularPercentIndicator(
                                radius: 40.0,
                                lineWidth: 14.0,
                                animation: true,
                                percent: 0.5,
                                center: new Text(
                                  "50.0%",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                header: Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          10.0), // Adjust bottom padding as needed
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Color(0xffff5963),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Third division or column
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 8.0),
                                child: Text(
                                  'Fats',
                                  style: GoogleFonts.readexPro(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    textStyle: TextStyle(
                                      color: Color(0xff249689),
                                    ),
                                  ),
                                ),
                              ),
                              CircularPercentIndicator(
                                radius: 40.0,
                                lineWidth: 14.0,
                                animation: true,
                                percent: 0.3,
                                center: new Text(
                                  "30.0%",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                header: Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          10.0), // Adjust bottom padding as needed
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Color(0xff249689),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              height: 110,
              child: GestureDetector(
                onTap: () {
                  // Show modal on tap
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 150,
                        color: Colors.white,
                        child: Center(
                          child: Text("All  Suggested Food"),
                        ),
                      );
                    },
                  );
                },
                child: Material(
                  //elevation: 4,
                  //shadowColor: Colors.grey.withOpacity(0.5),
                  //borderRadius: BorderRadius.circular(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          child: CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 4.5,
                          viewportFraction: 0.8,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          initialPage: 2,
                          autoPlay: true,
                        ),
                        items: Category.categories
                            .map((category) =>
                                HeroCarouselCard(category: category))
                            .toList(),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
