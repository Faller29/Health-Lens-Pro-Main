import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/food_data_history.dart';
import 'package:healthlens/graph_data.dart';
import 'package:healthlens/models/category_model.dart';
import 'package:healthlens/widgets/hero_carousel_card.dart';
import 'package:iconly/iconly.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

const double contWidth = 100;
const double contHeight = 140;

class ScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 4}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}

class SubScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final List<Item> _data = generateItems(1);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        addAutomaticKeepAlives: true,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: 100.0,
              decoration: const BoxDecoration(
                color: Color(0xffffffff),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              14.0, 0.0, 14.0, 0.0),
                          child: Container(
                            width: 70.0,
                            height: 70.0,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              'https://picsum.photos/seed/529/600',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 14.0, 0.0, 14.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'John Peter Faller',
                                style: GoogleFonts.readexPro(
                                    fontWeight: FontWeight.bold),
                                textScaler: TextScaler.linear(
                                    ScaleSize.textScaleFactor(context)),
                              ),
                              Text(
                                '17 Years Old',
                                style: GoogleFonts.readexPro(),
                                textScaler: TextScaler.linear(
                                    SubScaleSize.textScaleFactor(context)),
                              ),
                              Text(
                                'BMI: Normal',
                                style: GoogleFonts.readexPro(),
                                textScaler: TextScaler.linear(
                                    SubScaleSize.textScaleFactor(context)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Show modal on tap
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 150,
                            color: Colors.white,
                            child: const Center(
                              child: Text("User Profile Overview"),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  GestureDetector(
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            14.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 122.0,
                          height: 100.0,
                          decoration: const BoxDecoration(
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
                                      fontSize: 20.0,
                                      textStyle: const TextStyle(
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Time: 11:30',
                                    style: GoogleFonts.readexPro(
                                      fontSize: 11.0,
                                      textStyle: const TextStyle(
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Weight: 71kg',
                                style: GoogleFonts.readexPro(
                                  fontSize: 15.0,
                                  textStyle: const TextStyle(
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      // Show modal on tap
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 500,
                            color: Colors.white,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      child: Text(
                                        'Health Assesment',
                                        style: GoogleFonts.readexPro(
                                          fontSize: 20.0,
                                          textStyle: const TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 200,
                                      child: SfCartesianChart(
                                        zoomPanBehavior: ZoomPanBehavior(
                                          enablePinching: true,
                                          zoomMode: ZoomMode.y,
                                          enablePanning: true,
                                        ),
                                        primaryXAxis: CategoryAxis(
                                          edgeLabelPlacement:
                                              EdgeLabelPlacement.shift,
                                          interval: 1,
                                        ),
                                        primaryYAxis: CategoryAxis(
                                          maximum: 100,
                                          minimum: 0,
                                        ),
                                        legend: Legend(isVisible: true),
                                        series: <CartesianSeries>[
                                          StackedColumnSeries<ChartData,
                                                  String>(
                                              color: Color(0xff4b39ef),
                                              dataLabelSettings:
                                                  DataLabelSettings(
                                                isVisible: true,
                                                showZeroValue: true,
                                                labelPosition:
                                                    ChartDataLabelPosition
                                                        .inside,
                                                textStyle: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                labelAlignment:
                                                    ChartDataLabelAlignment
                                                        .middle,
                                                alignment:
                                                    ChartAlignment.center,
                                              ),
                                              name: 'Weight',
                                              dataSource: weight,
                                              xValueMapper:
                                                  (ChartData data, _) => data.x,
                                              yValueMapper:
                                                  (ChartData data, _) =>
                                                      data.y1,
                                              pointColorMapper:
                                                  (ChartData data, _) =>
                                                      Color(0xff4b39ef)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Update Weight: ',
                                        style: GoogleFonts.readexPro(
                                          fontSize: 18.0,
                                          textStyle: const TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 10),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Enter Weight [kg]',
                                          labelStyle: GoogleFonts.outfit(
                                            fontSize: 15.0,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xffe0e3e7),
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xff4b39ef),
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          focusedErrorBorder:
                                              UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        style: GoogleFonts.outfit(
                                          fontSize: 14.0,
                                        ),
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
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(14.0, 0.0, 14.0, 0.0),
            child: Container(
              width: 350.0,
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                boxShadow: [
                  const BoxShadow(
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
                  const Padding(
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 8.0),
                                child: Text(
                                  'Carbohydrates',
                                  style: GoogleFonts.readexPro(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    textStyle: const TextStyle(
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
                                header: const Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          10.0), // Adjust bottom padding as needed
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: const Color(0xff4b39ef),
                              ),
                            ],
                          ),
                          Text(
                            "89/110g",
                            style: GoogleFonts.readexPro(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              textStyle: const TextStyle(
                                color: Color(0xff4b39ef),
                              ),
                            ),
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 8.0),
                                child: Text(
                                  'Protein',
                                  style: GoogleFonts.readexPro(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    textStyle: const TextStyle(
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
                                header: const Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          10.0), // Adjust bottom padding as needed
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: const Color(0xffff5963),
                              ),
                              Text(
                                "50/100g",
                                style: GoogleFonts.readexPro(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  textStyle: const TextStyle(
                                    color: Color(0xffff5963),
                                  ),
                                ),
                              )
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 8.0),
                                child: Text(
                                  'Fats',
                                  style: GoogleFonts.readexPro(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    textStyle: const TextStyle(
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
                                header: const Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          10.0), // Adjust bottom padding as needed
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: const Color(0xff249689),
                              ),
                              Text(
                                "30/100g",
                                style: GoogleFonts.readexPro(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  textStyle: const TextStyle(
                                    color: Color(0xff249689),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton.icon(
                      label: Text(
                        'Exercise',
                        style: GoogleFonts.readexPro(
                          fontSize: 14.0,
                          textStyle: const TextStyle(
                            color: Color(0xff4b39ef),
                          ),
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 300,
                              width: 500,
                              child: const Center(
                                child: Text("Exercises"),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.fitness_center,
                        color: Color(0xff4b39ef),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
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
                      child: const Center(
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
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              14.0,
              0.0,
              14.0,
              0.0,
            ),
            child: Container(
              width: 350.0,
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                boxShadow: [
                  const BoxShadow(
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
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 14.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Activity",
                            style: GoogleFonts.readexPro(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _data[index].isExpanded = isExpanded;
                            });
                          },
                          children: _data.map<ExpansionPanel>((Item item) {
                            return ExpansionPanel(
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(
                                    item.headerValue,
                                    style: GoogleFonts.readexPro(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      textStyle: const TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              body: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: item.expandedContent,
                              ),
                              isExpanded: item.isExpanded,
                            );
                          }).toList(),
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
    );
  }
}
