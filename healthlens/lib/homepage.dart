import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/backend_firebase/foodExchange.dart';
import 'package:healthlens/food_data_history.dart';
import 'package:healthlens/graph_data.dart';
import 'package:healthlens/models/category_model.dart';
import 'package:healthlens/widgets/hero_carousel_card.dart';
import 'package:iconly/iconly.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'main.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'weightPredition.dart';
import 'package:intl/intl.dart';

const double contWidth = 100;
const double contHeight = 140;

class ScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 3}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}

class SubScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 1}) {
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

List<WeightData>? dailyWeight;

class _HomePage extends State<HomePage> {
  final List<Item> _data = generateItems(1);
  bool isVisible = false, inverseVisible = true;
  bool dataNeedsRefresh = false;

  @override
  void initState() {
    super.initState();
    fetchImageUrl();
    print(thisUser!.uid);
    _fetchWeightData();
  }

  Future<Map<String, dynamic>> getSavedMacronutrientData() async {
    String uid = thisUser!.uid;
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('userFoodBookMark')
        .doc(uid)
        .get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    } else {
      return {}; // Return an empty map if no data exists
    }
  }

// Inside your fetch function, you can initialize it
  Future<void> _fetchWeightData() async {
    try {
      final weightDataMap = await predictWeightChange();
      setState(() {
        dailyWeight = (weightDataMap['daily'] ?? [])
            .cast<WeightData>(); // Ensure default is a non-null list
      });
    } catch (e) {
      print("Error fetching weight data: $e");
    }
  }

  Future<void> fetchImageUrl() async {
    final thisUserUid = thisUser?.uid;

    try {
      final userRef = FirebaseStorage.instance
          .ref()
          .child('users/$thisUserUid/profile.jpg');
      String updatedUrl = await userRef.getDownloadURL();

      // Append a timestamp or random string to the URL to break the cache
      setState(() {
        url = '$updatedUrl?${DateTime.now().millisecondsSinceEpoch}';
      });
    } catch (e) {
      // Set a fallback if the image isn't available
      setState(() {
        url = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        addAutomaticKeepAlives: true,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 8.0),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3.0,
                    color: Color(0x33000000),
                    offset: Offset(
                      0.0,
                      1.0,
                    ),
                  )
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              14.0, 0.0, 14.0, 0.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: url != null
                                ? CachedNetworkImage(
                                    key: ValueKey(url),
                                    imageUrl: url,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.cover,
                                    width: 70,
                                    height: 70,
                                  )
                                : Icon(
                                    Icons.account_circle,
                                    size: 60,
                                    color: Colors.grey,
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
                              Container(
                                width:
                                    (0.35 * MediaQuery.sizeOf(context).width),
                                child: Text(
                                  userFullName.split(" ").first,

                                  style: GoogleFonts.readexPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context)
                                        .textScaler
                                        .scale(20),
                                  ),
                                  //textScaler: TextScaler.linear(1),
                                ),
                              ),
                              Text(
                                textAlign: TextAlign.left,
                                age.toString() + ' Years Old',
                                style: GoogleFonts.readexPro(
                                  color: Color(0xFF57636C),
                                  fontSize: MediaQuery.of(context)
                                      .textScaler
                                      .scale(14),
                                ),
                              ),
                              Text(
                                'BMI: ' + userBMI.toString(),
                                style: GoogleFonts.readexPro(
                                  color: Color(0xFF57636C),
                                  fontSize: MediaQuery.of(context)
                                      .textScaler
                                      .scale(12),
                                ),
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
                                'Weight: 75kg',
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
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Center(
                              child: Card(
                                color: Colors.white,
                                elevation: 0,
                                margin:
                                    const EdgeInsets.fromLTRB(10, 150, 10, 150),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 10),
                                          child: Text(
                                            'Health Information',
                                            style: GoogleFonts.readexPro(
                                              fontSize: 20.0,
                                              textStyle: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 10, 8, 2),
                                          child: SizedBox(
                                            height: 300,
                                            child: SfCartesianChart(
                                              title: ChartTitle(
                                                  text: 'Predicted Weight',
                                                  textStyle:
                                                      GoogleFonts.readexPro(
                                                          color:
                                                              Color(0xFF57636C),
                                                          fontSize: 12),
                                                  alignment:
                                                      ChartAlignment.near),
                                              zoomPanBehavior: ZoomPanBehavior(
                                                enablePinching: true,
                                                zoomMode: ZoomMode.x,
                                                enablePanning: true,
                                              ),
                                              primaryXAxis: CategoryAxis(
                                                initialVisibleMaximum: 5,
                                              ),
                                              primaryYAxis: NumericAxis(
                                                  labelStyle:
                                                      TextStyle(fontSize: 10),
                                                  anchorRangeToVisiblePoints:
                                                      true),
                                              legend: Legend(
                                                  itemPadding: 0,
                                                  isVisible: true,
                                                  position: LegendPosition.top,
                                                  alignment:
                                                      ChartAlignment.far),
                                              series: <CartesianSeries>[
                                                ColumnSeries<WeightData,
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
                                                    dataSource: dailyWeight,
                                                    xValueMapper:
                                                        (WeightData data, _) =>
                                                            data.x,
                                                    yValueMapper:
                                                        (WeightData data, _) =>
                                                            data.y1,
                                                    pointColorMapper:
                                                        (WeightData data, _) =>
                                                            Color(0xff4b39ef)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: inverseVisible,
                                          child: TextButton(
                                            onPressed: () => {
                                              Navigator.pushNamed(
                                                  context, '/editHealth')
                                            },
                                            child: Text('Update Weight'),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Weight: ',
                                                style: GoogleFonts.readexPro(
                                                  color: Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              Column(children: [
                                                Text(
                                                  weight.toString(),
                                                  style: GoogleFonts.readexPro(
                                                    color: Color(0xFF57636C),
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ]),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Height: ',
                                                style: GoogleFonts.readexPro(
                                                  color: Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              Column(children: [
                                                Text(
                                                  height.toString(),
                                                  style: GoogleFonts.readexPro(
                                                    color: Color(0xFF57636C),
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ]),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                'BMI: ',
                                                style: GoogleFonts.readexPro(
                                                  color: Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              Column(children: [
                                                Text(
                                                  userBMI!,
                                                  style: GoogleFonts.readexPro(
                                                    color: Color(0xFF57636C),
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ]),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Chronic Disease: ',
                                                style: GoogleFonts.readexPro(
                                                  color: Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              Column(
                                                children: chronicDisease!
                                                    .map((e) => Text(
                                                          e,
                                                          style: GoogleFonts
                                                              .readexPro(
                                                            color: Color(
                                                                0xFF57636C),
                                                            fontSize: 14.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ))
                                                    .toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Lifestyle: ',
                                                style: GoogleFonts.readexPro(
                                                  color: Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              Column(children: [
                                                Text(
                                                  lifestyle!,
                                                  style: GoogleFonts.readexPro(
                                                    color: Color(0xFF57636C),
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ]),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
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
                                percent: (dailyCarbs ?? 0) / (gramCarbs ?? 0),
                                center: Text(
                                  '${((dailyCarbs ?? 0) / (gramCarbs ?? 0) * 100).toStringAsFixed(0)}%',
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                header: const Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: const Color(0xff4b39ef),
                              ),
                            ],
                          ),
                          Text(
                            '${(dailyCarbs ?? 0)}/${gramCarbs}',
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
                                percent:
                                    (dailyProtein ?? 0) / (gramProtein ?? 0),
                                center: Text(
                                  '${((dailyProtein ?? 0) / (gramProtein ?? 0) * 100).toStringAsFixed(0)}%',
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
                                '${(dailyProtein ?? 0)}/${gramProtein}',
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
                                percent: (dailyFats ?? 0) / (gramFats ?? 0),
                                center: Text(
                                  '${((dailyFats ?? 0) / (gramFats ?? 0) * 100).toStringAsFixed(0)}%',
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
                                '${(dailyFats ?? 0)}/${gramFats}',
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
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                    child: SizedBox(
                      child: SfLinearGauge(
                        showLabels: false,
                        minorTicksPerInterval: 4,
                        useRangeColorForAxis: true,
                        animateAxis: true,
                        axisTrackStyle: LinearAxisTrackStyle(thickness: 1),
                        ranges: <LinearGaugeRange>[
                          //First range
                          LinearGaugeRange(
                              startValue: 0,
                              endValue: ((dailyCalories! / TER!) * 100),
                              color: Colors.green),
                        ],
                        markerPointers: [
                          LinearShapePointer(
                              elevation: 3,
                              value: ((dailyCalories! / TER!) * 100)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            "Calories: ",
                            style: GoogleFonts.readexPro(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              textStyle: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            "${dailyCalories.toString()}/${TER}",
                            style: GoogleFonts.readexPro(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              textStyle: const TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton.icon(
                      label: Text(
                        'My Meal Plan',
                        style: GoogleFonts.readexPro(
                          fontSize: 14.0,
                          textStyle: const TextStyle(
                            color: Color(0xff4b39ef),
                          ),
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onPressed: () {
                        showMacronutrientModal(context);
                      },
                      icon: const Icon(
                        Icons.book,
                        color: Color(0xff4b39ef),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(10),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                      onTap: (((dailyCalories! / TER!) * 100) > 5)
                          ? () async {
                              final result = await Navigator.pushNamed(
                                  context, '/exercise');
                              if (result == true) {
                                setState(() {
                                  dataNeedsRefresh =
                                      true; // Trigger a refresh in the main page
                                });
                              }
                            }
                          : () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return Center(
                                        child: Card(
                                          color: Color.fromARGB(
                                              234, 255, 255, 255),
                                          elevation: 0,
                                          margin: const EdgeInsets.fromLTRB(
                                              10, 150, 10, 150),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  20,
                                              height: 100,
                                              child: Center(
                                                child: Flexible(
                                                  child: Text(
                                                    'Please eat food first before doing exercise. Currently you have less than 5% energy which is not enough to expend energy',
                                                    style:
                                                        GoogleFonts.readexPro(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                              .textScaler
                                                              .scale(14),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  });
                            },
                      child: Column(
                        children: [
                          Ink.image(
                            image: AssetImage('assets/images/exercise.png'),
                            height: 160,
                            width: 160,
                          ),
                          Text(
                            'Exercise',
                            style: GoogleFonts.readexPro(
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(10),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                      onTap: () {
                        mealPlanGeneratorSelector(context);
                      },
                      child: Column(
                        children: [
                          Ink.image(
                            image: AssetImage('assets/images/food.png'),
                            height: 160,
                            width: 160,
                          ),
                          Text(
                            'Meal Plan',
                            style: GoogleFonts.readexPro(
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          /* Container(
            padding: const EdgeInsets.all(10.0),
            height: 110,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/mealPlan');
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
          ), */
        ],
      ),
    );
  }

  void showMacronutrientModal(BuildContext context) async {
    Map<String, dynamic> savedData = await getSavedMacronutrientData();

    if (savedData.isNotEmpty) {
      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Center(
                  child: Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: const EdgeInsets.fromLTRB(10, 150, 10, 150),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Center(
                              child: Text(
                                "My Meal Plan",
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
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () {
                                  // Show confirmation dialog before clearing
                                  _showClearConfirmationDialog(context);
                                },
                                child: Text('Clear'),
                              ),
                            ),

                            // Loop through each item in the saved data
                            ...savedData.values.map((selectedFoods) {
                              if (selectedFoods is List) {
                                return Column(
                                  children:
                                      selectedFoods.map<Widget>((selectedFood) {
                                    String foodName = selectedFood['foodName'];
                                    String servingPart =
                                        selectedFood['servingPart'];
                                    int quantity = selectedFood[
                                        'quantity']; // Get quantity

                                    if (itemMacronutrients
                                            .containsKey(foodName) &&
                                        itemMacronutrients[foodName]!
                                            .containsKey(servingPart)) {
                                      Map<String, int> macronutrients =
                                          itemMacronutrients[foodName]![
                                              servingPart]!;

                                      // Calculate macronutrients based on quantity
                                      int totalCarbs =
                                          macronutrients['carbs']! * quantity;
                                      int totalFats =
                                          macronutrients['fats']! * quantity;
                                      int totalProteins =
                                          macronutrients['proteins']! *
                                              quantity;

                                      return Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              foodName,
                                              style: GoogleFonts.readexPro(
                                                fontSize: 14.0,
                                                textStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Serving: $servingPart",
                                              style: GoogleFonts.readexPro(
                                                fontSize: 12.0,
                                                textStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Quantity: x$quantity\n'
                                              'Carbs: $totalCarbs g, '
                                              'Fats: $totalFats g, '
                                              'Proteins: $totalProteins g',
                                              style: GoogleFonts.readexPro(
                                                fontSize: 12.0,
                                                textStyle: const TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return SizedBox(); // Empty widget if no match found
                                    }
                                  }).toList(),
                                );
                              } else {
                                return SizedBox(); // Empty widget if selectedFoods is not a List
                              }
                            }).toList(),

                            SizedBox(height: 20),
                            Divider(),
                            // Show total macronutrients
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Total Macronutrients",
                                style: GoogleFonts.readexPro(
                                  fontSize: 16.0,
                                  textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            // Calculate the total macronutrients from the saved data
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                "Carbs: ${calculateTotalMacronutrients(savedData)['carbs']} g\n"
                                "Fats: ${calculateTotalMacronutrients(savedData)['fats']} g\n"
                                "Proteins: ${calculateTotalMacronutrients(savedData)['proteins']} g\n",
                                style: GoogleFonts.readexPro(
                                  fontSize: 14.0,
                                  textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          });
    } else {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Center(
                child: Card(
                  color: Color.fromARGB(234, 255, 255, 255),
                  elevation: 0,
                  margin: const EdgeInsets.fromLTRB(10, 150, 10, 150),
                  child: Container(
                    height: 200,
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "My Meal Plan",
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
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 20,
                            height: 100,
                            child: Center(
                              child: Flexible(
                                child: Text(
                                  'You have no saved Meal Plan.\n'
                                  'Use Meal Plan Generator or Create your own Meal Plan.',
                                  style: GoogleFonts.readexPro(
                                    fontSize: MediaQuery.of(context)
                                        .textScaler
                                        .scale(14),
                                  ),
                                  textAlign: TextAlign.center,
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
    }
  }

  void _showClearConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Clear Food Items"),
          content: Text(
              "Are you sure you want to clear all food items? This will remove them from your meal plan and Firebase."),
          actions: [
            TextButton(
              onPressed: () {
                clearFoodItems(context); // Pass context to show Snackbar
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close modal
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  Future<void> clearFoodItems(BuildContext context) async {
    String uid = thisUser!.uid;

    // Clear the food items from Firestore
    try {
      await FirebaseFirestore.instance
          .collection('userFoodBookMark')
          .doc(uid)
          .set({}); // Update the selectedFoods field to an empty list

      // Show confirmation Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("All food items have been cleared."),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to clear food items. Please try again."),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Map<String, int> calculateTotalMacronutrients(
      Map<String, dynamic> savedData) {
    int totalCarbs = 0;
    int totalFats = 0;
    int totalProteins = 0;

    // Iterate through the savedData from Firebase
    savedData.forEach((_, selectedFoods) {
      if (selectedFoods is List) {
        for (var selectedFood in selectedFoods) {
          String foodName = selectedFood['foodName'];
          String servingPart = selectedFood['servingPart'];
          int quantity = selectedFood['quantity']; // Get the quantity

          // Check if the item exists in itemMacronutrients
          if (itemMacronutrients.containsKey(foodName) &&
              itemMacronutrients[foodName]!.containsKey(servingPart)) {
            Map<String, int> macronutrients =
                itemMacronutrients[foodName]![servingPart]!;

            // Sum up the macronutrients considering the quantity
            totalCarbs += macronutrients['carbs']! * quantity;
            totalFats += macronutrients['fats']! * quantity;
            totalProteins += macronutrients['proteins']! * quantity;
          }
        }
      }
    });

    // Return the total macronutrient sums
    return {
      'carbs': totalCarbs,
      'fats': totalFats,
      'proteins': totalProteins,
    };
  }

  void mealPlanGeneratorSelector(BuildContext context) async {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                color: Color.fromARGB(234, 255, 255, 255),
                elevation: 0,
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
                            child: Flexible(
                              child: Text(
                                'Choose a Meal Plan Generator.\n\n'
                                'Auto Generate Meal Plan using the System or Manually Create One',
                                style: GoogleFonts.readexPro(
                                  fontSize: MediaQuery.of(context)
                                      .textScaler
                                      .scale(14),
                                ),
                                textAlign: TextAlign.center,
                              ),
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
}
