import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter_popup/flutter_popup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/backend_firebase/foodExchange.dart';
import 'package:healthlens/backend_firebase/modals.dart';
import 'package:healthlens/food_data_history.dart';
//import 'package:healthlens/graph_data.dart';
//import 'package:healthlens/models/category_model.dart';
//import 'package:healthlens/widgets/hero_carousel_card.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'main.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'weightPredition.dart';
import 'package:intl/intl.dart';

const double contWidth = 100;
const double contHeight = 140;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
List<WeightData>? weeklyWeight;
List<WeightData>? monthlyWeight;

class _HomePage extends State<HomePage> {
  var _firstPress = true;

  final List<Item> _data = generateItems(1);
  bool isVisible = false, inverseVisible = true;
  bool dataNeedsRefresh = false;
  late Timer _timer;
  String _currentDay = '';
  String _currentTime = '';
  String _todayDate = '';

  // Function to get the current day name
  String _getCurrentDay() {
    DateTime now = DateTime.now();
    switch (now.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // Function to get the current time in hh:mm format
  String _getCurrentTime() {
    DateTime now = DateTime.now();
    String hour =
        now.hour.toString().padLeft(2, '0'); // Ensures 2 digits for hours
    String minute =
        now.minute.toString().padLeft(2, '0'); // Ensures 2 digits for minutes
    return '$hour:$minute';
  }

  String _getTodayDate() {
    DateTime now = DateTime.now();
    return DateFormat('EEEE, MMMM d, y')
        .format(now); // Formats to "Monday, October 24, 2024"
  }

  @override
  void initState() {
    super.initState();
    fetchImageUrl();
    print(thisUser!.uid);
    _currentDay = _getCurrentDay();
    _currentTime = _getCurrentTime();
    _todayDate = _getTodayDate();
    // Update the time every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
      if (mounted) {
        setState(() {
          _currentDay = _getCurrentDay();
          _currentTime = _getCurrentTime();
          _todayDate = _getTodayDate();
        });
      }
    });
  }

  @override
  void dispose() {
    // Check if the lists are not null before checking their contents
    if ((dailyWeight != null && dailyWeight!.isNotEmpty) ||
        (weeklyWeight != null && weeklyWeight!.isNotEmpty) ||
        (monthlyWeight != null && monthlyWeight!.isNotEmpty)) {
      dailyWeight?.clear();
      weeklyWeight?.clear();
      monthlyWeight?.clear();
    }

    super.dispose(); // Call the superclass's dispose method
  }

  Future<Map<String, dynamic>> getSavedMacronutrientData() async {
    String uid = thisUser!.uid;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('userFoodBookMark')
        .doc(uid)
        .get();

    if (snapshot.exists) {
      // Retrieve data as a Map
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      // Check if selectedFoods exists and is a list
      if (data['selectedFoods'] != null && data['selectedFoods'] is List) {
        // Iterate over each meal in the data
        for (var meal in data['selectedFoods']) {
          List<dynamic>? foods = meal['foods'];

          // Check if foods exist and are a list before proceeding
          if (foods != null && foods is List) {
            // Create a map to track duplicate foods by (foodName, servingSize) key
            Map<String, Map<String, dynamic>> combinedFoods = {};

            for (var food in foods) {
              String foodName = food['foodName'];
              String servingSize = food['servingSize'];

              String key =
                  '$foodName-$servingSize'; // Unique key for each food + serving size

              // Initialize the quantity to 1 if it's null
              int currentQuantity = (food['quantity'] ?? 1);

              if (combinedFoods.containsKey(key)) {
                // If the food is already present, increase its quantity
                combinedFoods[key]!['quantity'] += currentQuantity;
              } else {
                // Add the food to the map and set the quantity
                combinedFoods[key] = Map<String, dynamic>.from(food);
                combinedFoods[key]!['quantity'] =
                    currentQuantity; // Ensure quantity is set
              }
            }

            // Update the meal's food list with the combined food entries
            meal['foods'] = combinedFoods.values.toList();
          } else {
            print('Foods list is null or not a list for meal: $meal');
          }
        }
      } else {
        print('selectedFoods is null or not a list.');
      }

      // Return the modified data
      return data;
    } else {
      print('No data found for the user.');
      return {}; // Return an empty map if no data exists
    }
  }

// Inside your fetch function, you can initialize it
  bool _isDataFetched = false;

  Future<void> _fetchWeightData() async {
    if (_isDataFetched) return; // Prevent multiple calls

    try {
      print("Fetching weight data...");

      final weightDataMap = await predictWeightChange();

      setState(() {
        // Reset the lists
        dailyWeight = [];
        weeklyWeight = [];
        monthlyWeight = [];
        // Assign fetched data
        dailyWeight = (weightDataMap['daily'] ?? []).cast<WeightData>();
        weeklyWeight = (weightDataMap['weekly'] ?? []).cast<WeightData>();
        monthlyWeight = (weightDataMap['monthly'] ?? []).cast<WeightData>();

        // Print monthly weight data
        int myNum = 1;
        print("Monthly Weight Data:");
        for (var weightData in monthlyWeight!) {
          print('Date: ${weightData.x}, Weight: ${weightData.y1}');
          print(myNum++);
        }
      });

      _isDataFetched = true; // Set flag to true after fetching
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

  List<Widget> _getFoodRestrictions() {
    List<String> messages = [];

    if (chronicDisease!.contains('Obesity')) {
      messages.add('You are not allowed to eat fatty food.');
      messages.add('Keep out of too much oily food');
      messages.add(
          "Don't eat Fatty Part of Pork as it is Bad for your health condition.");
    }
    if (chronicDisease!.contains('Hypertension')) {
      messages.add('You are not allowed to eat salty food.');
      messages.add('Keep out of too much oily food');
      messages.add(
          "Don't eat Fatty Part of Pork as it is Bad for your health condition.");
    }
    if (chronicDisease!.contains('Diabetes [Type 1 & 2]')) {
      messages.add('You are not allowed to eat sugary food.');
      messages.add('Keep out of too much oily food');
      messages.add(
          "Don't eat Fatty Part of Pork as it is Bad for your health condition.");
    }

    // If there are no restrictions, you can add a default message
    if (messages.isEmpty) {
      messages.add('No specific food restrictions.');
    }

    // Convert messages to Text widgets
    return messages
        .map((message) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "• $message",
                  style: GoogleFonts.readexPro(
                    color: const Color(0xFF57636C),
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        addAutomaticKeepAlives: true,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              //height: 100.0,
              decoration: const BoxDecoration(
                color: Color(0xff4b39ef),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                _todayDate.toUpperCase(),
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Dashboard",
                                style: GoogleFonts.outfit(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 0.6,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Weight: ${weight}kg",
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "BMI: $userBMI",
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Padding(
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
                                        Image.asset(
                                            'assets/images/profile.jpg'),
                                    fit: BoxFit.cover,
                                    width: 70,
                                    height: 70,
                                  )
                                : Image.asset(
                                    'assets/images/profile.jpg',
                                    fit: BoxFit.cover,
                                    width: 70,
                                    height: 70,
                                  ),
                          ),
                        ),
                      ),
                      /* Padding(
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
                                      Image.asset('assets/images/profile.jpg'),
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
                                )
                              : Image.asset(
                                  'assets/images/profile.jpg',
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
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
                              width: (0.35 * MediaQuery.sizeOf(context).width),
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
                                color: const Color(0xFF57636C),
                                fontSize:
                                    MediaQuery.of(context).textScaler.scale(14),
                              ),
                            ),
                            Text(
                              'BMI: ' + userBMI.toString(),
                              style: GoogleFonts.readexPro(
                                color: const Color(0xFF57636C),
                                fontSize:
                                    MediaQuery.of(context).textScaler.scale(12),
                              ),
                            ),
                          ],
                        ),
                      ), */
                    ],
                  ),
                  /* Padding(
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
                          Text(
                            _currentDay,
                            style: GoogleFonts.readexPro(
                              fontSize: 25.0,
                              textStyle: const TextStyle(
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                          Text(
                            'Time: $_currentTime',
                            style: GoogleFonts.readexPro(
                              fontSize: 14.0,
                              textStyle: const TextStyle(
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                          Text(
                            'Weight: ${weight?.toInt()}kg',
                            style: GoogleFonts.readexPro(
                              fontSize: 14.0,
                              textStyle: const TextStyle(
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ), */
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(14.0, 10.0, 14.0, 15.0),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                boxShadow: [
                  BoxShadow(
                    blurStyle: BlurStyle.outer,
                    blurRadius: 10.0,
                    color: Color(0xff4b39ef).withOpacity(0.8),
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
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 14.0),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            "Macronutrients",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message:
                                "You're advised to meet at least 75% of your daily macronutrient needs.\n\nYou can exceed your target by up to 120%, but going beyond that may be harmful to your health.",
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.all(20),
                            showDuration: Duration(seconds: 10),
                            decoration: BoxDecoration(
                              color: Color(0xff4b39ef).withOpacity(0.9),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            textStyle: TextStyle(color: Colors.white),
                            preferBelow: true,
                            verticalOffset: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(
                                  FontAwesomeIcons.solidCircleQuestion,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // First division or column
                      CircularPercentIndicator(
                        radius: 40.0,
                        lineWidth: 14.0,
                        animation: true,
                        percent: ((dailyProtein! >= gramProtein!)
                            ? (gramProtein! / gramProtein!)
                            : (dailyProtein! / (gramProtein ?? 1))),
                        center: Text(
                          '${((dailyProtein ?? 0) / (gramProtein ?? 0) * 100).toStringAsFixed(0)}%',
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                        header: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 10.0),
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
                        footer: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: GoogleFonts.readexPro(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                textStyle: const TextStyle(
                                  color: Color(0xffff5963),
                                ),
                              ),
                              children: [
                                WidgetSpan(
                                  child: SizedBox(
                                    width: 20,
                                  ),
                                ),
                                TextSpan(
                                  text: '${(dailyProtein ?? 0)}/${gramProtein}',
                                ),
                                WidgetSpan(
                                  child: Transform.translate(
                                    offset: const Offset(0.0, -5.0),
                                    child: Text(
                                      '+${(gramProtein! * 0.20).toStringAsFixed(0)}',
                                      style: GoogleFonts.readexPro(
                                          fontSize: 11,
                                          color: Color(0xFF009C51)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: const Color(0xffff5963),
                        /* linearGradient: LinearGradient(colors: [
                          Color(0xff4b39ef).withOpacity(0.8),
                          Color.fromARGB(255, 38, 29, 122)
                        ], transform: GradientRotation(50)), */
                      ),

                      // Second division or column
                      CircularPercentIndicator(
                        radius: 40.0,
                        lineWidth: 14.0,
                        animation: true,
                        percent: ((dailyCarbs! >= gramCarbs!)
                            ? (gramCarbs! / gramCarbs!)
                            : (dailyCarbs! / (gramCarbs ?? 1))),
                        center: Text(
                          '${((dailyCarbs ?? 0) / (gramCarbs ?? 0) * 100).toStringAsFixed(0)}%',
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                        header: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 10.0),
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
                        footer: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: GoogleFonts.readexPro(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                textStyle: const TextStyle(
                                  color: Color(0xff4b39ef),
                                ),
                              ),
                              children: [
                                WidgetSpan(
                                  child: SizedBox(
                                    width: 20,
                                  ),
                                ),
                                TextSpan(
                                  text: '${(dailyCarbs ?? 0)}/${gramCarbs} ',
                                ),
                                WidgetSpan(
                                  child: Transform.translate(
                                    offset: const Offset(0.0, -5.0),
                                    child: Text(
                                      '+${(gramCarbs! * 0.20).toStringAsFixed(0)}',
                                      style: GoogleFonts.readexPro(
                                          fontSize: 11,
                                          color: Color(0xFF009C51)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: const Color(0xff4b39ef),
                      ),

                      // Third division or column
                      CircularPercentIndicator(
                        radius: 40.0,
                        lineWidth: 14.0,
                        animation: true,
                        percent: ((dailyFats! >= gramFats!)
                            ? (gramFats! / gramFats!)
                            : (dailyFats! / (gramFats ?? 1))),
                        center: Text(
                          '${((dailyFats ?? 0) / (gramFats ?? 0) * 100).toStringAsFixed(0)}%',
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                        header: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 10.0),
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
                        footer: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: GoogleFonts.readexPro(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                textStyle: const TextStyle(
                                  color: Color(0xff249689),
                                ),
                              ),
                              children: [
                                WidgetSpan(
                                  child: SizedBox(
                                    width: 20,
                                  ),
                                ),
                                TextSpan(
                                  text: '${(dailyFats ?? 0)}/${gramFats}',
                                ),
                                WidgetSpan(
                                  child: Transform.translate(
                                    offset: const Offset(0.0, -5.0),
                                    child: Text(
                                      '+${(gramFats! * 0.20).toStringAsFixed(0)}',
                                      style: GoogleFonts.readexPro(
                                          fontSize: 11,
                                          color: Color(0xFF009C51)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: const Color(0xff249689),
                      ),
                    ],
                  ),
                  const SizedBox(
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
                        axisTrackStyle:
                            const LinearAxisTrackStyle(thickness: 1),
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
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: TextButton.icon(
                          label: Text(
                            'Health Info',
                            style: GoogleFonts.readexPro(
                              fontSize: 14.0,
                              textStyle: const TextStyle(
                                color: Color(0xff4b39ef),
                              ),
                            ),
                          ),
                          icon: const Icon(
                            Icons.book,
                            color: Color(0xff4b39ef),
                            size: 15,
                          ),
                          onPressed: () async {
                            if (_firstPress) {
                              _firstPress = false;
                              final snackBar = SnackBar(
                                behavior: SnackBarBehavior.floating,
                                elevation: 3,
                                content: Row(
                                  children: const [
                                    CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(child: Text('Collecting Data...')),
                                  ],
                                ),
                                duration: Duration(
                                    seconds:
                                        5), // Keep it visible until dismissed
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              await _fetchWeightData();
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              setState(() {
                                _firstPress = !_firstPress;
                              });
                              // Show modal on tap
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setState) {
                                    return Center(
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 0,
                                        margin: const EdgeInsets.fromLTRB(
                                            10, 150, 10, 150),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 10, 0, 10),
                                                  child: Text(
                                                    'Health Information',
                                                    style:
                                                        GoogleFonts.readexPro(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      textStyle:
                                                          const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 10, 5, 2),
                                                  child: Card(
                                                    elevation: 3,
                                                    color: Colors.white,
                                                    shadowColor: Colors.blue,
                                                    child: Material(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Column(
                                                          children: [
                                                            SfCartesianChart(
                                                              title: ChartTitle(
                                                                  text:
                                                                      'Predicted Weight',
                                                                  textStyle: GoogleFonts.readexPro(
                                                                      color: const Color(
                                                                          0xFF57636C),
                                                                      fontSize:
                                                                          12),
                                                                  alignment:
                                                                      ChartAlignment
                                                                          .near),
                                                              zoomPanBehavior:
                                                                  ZoomPanBehavior(
                                                                enablePinching:
                                                                    true,
                                                                zoomMode:
                                                                    ZoomMode.x,
                                                                enablePanning:
                                                                    true,
                                                              ),
                                                              primaryXAxis:
                                                                  const CategoryAxis(
                                                                labelRotation:
                                                                    90,
                                                                initialVisibleMaximum:
                                                                    7,
                                                                maximumLabels:
                                                                    DateTime
                                                                        .daysPerWeek,
                                                              ),
                                                              primaryYAxis: const NumericAxis(
                                                                  decimalPlaces:
                                                                      2,
                                                                  labelStyle:
                                                                      TextStyle(
                                                                          fontSize:
                                                                              10),
                                                                  anchorRangeToVisiblePoints:
                                                                      true),
                                                              legend: const Legend(
                                                                  itemPadding:
                                                                      0,
                                                                  isVisible:
                                                                      true,
                                                                  position:
                                                                      LegendPosition
                                                                          .top,
                                                                  alignment:
                                                                      ChartAlignment
                                                                          .far),
                                                              series: <CartesianSeries>[
                                                                ColumnSeries<
                                                                        WeightData,
                                                                        String>(
                                                                    color: const Color(
                                                                        0xff4b39ef),
                                                                    dataLabelSettings:
                                                                        const DataLabelSettings(
                                                                      isVisible:
                                                                          true,
                                                                      showZeroValue:
                                                                          true,
                                                                      labelPosition:
                                                                          ChartDataLabelPosition
                                                                              .inside,
                                                                      textStyle: TextStyle(
                                                                          fontSize:
                                                                              8,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      labelAlignment:
                                                                          ChartDataLabelAlignment
                                                                              .top,
                                                                      alignment:
                                                                          ChartAlignment
                                                                              .center,
                                                                    ),
                                                                    name:
                                                                        'Weight',
                                                                    dataSource:
                                                                        dailyWeight,
                                                                    xValueMapper:
                                                                        (WeightData data, _) =>
                                                                            data
                                                                                .x,
                                                                    yValueMapper: (WeightData
                                                                                data,
                                                                            _) =>
                                                                        data.y1,
                                                                    pointColorMapper: (WeightData
                                                                                data,
                                                                            _) =>
                                                                        const Color(
                                                                            0xff4b39ef)),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          10,
                                                                          10,
                                                                          10),
                                                              child: Text(
                                                                'Desired Body Weight: ${desiredBodyWeight?.toInt()}Kg',
                                                                style: GoogleFonts
                                                                    .readexPro(
                                                                  textStyle:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                            (dailyWeight!
                                                                            .length ==
                                                                        1 ||
                                                                    weeklyWeight!
                                                                            .length ==
                                                                        1 ||
                                                                    monthlyWeight!
                                                                            .length ==
                                                                        1)
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            20,
                                                                        vertical:
                                                                            20),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "Congratulations! You've reached your desired body weight, which is associated with a lower risk of health complications and a reduced mortality rate.",
                                                                        style: GoogleFonts
                                                                            .readexPro(
                                                                          color:
                                                                              Colors.green,
                                                                          fontSize:
                                                                              14.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            15.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .fromLTRB(
                                                                              5,
                                                                              10,
                                                                              5,
                                                                              10),
                                                                          child:
                                                                              Text(
                                                                            'Estimated Days, Weeks, and Months to achieve Desired Body Weight:',
                                                                            style:
                                                                                GoogleFonts.readexPro(
                                                                              fontSize: 12,
                                                                              textStyle: TextStyle(
                                                                                color: Colors.black,
                                                                              ),
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.justify,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  'Days: ',
                                                                                  style: GoogleFonts.readexPro(
                                                                                    textStyle: TextStyle(
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  'Weeks: ',
                                                                                  style: GoogleFonts.readexPro(
                                                                                    textStyle: TextStyle(
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  'Months: ',
                                                                                  style: GoogleFonts.readexPro(
                                                                                    textStyle: TextStyle(
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  '${dailyWeight!.length} days',
                                                                                  style: GoogleFonts.readexPro(
                                                                                    textStyle: TextStyle(
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  '${weeklyWeight!.length} Weeks',
                                                                                  style: GoogleFonts.readexPro(
                                                                                    textStyle: TextStyle(
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  '${monthlyWeight!.length} Months',
                                                                                  style: GoogleFonts.readexPro(
                                                                                    textStyle: TextStyle(
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                            if (desiredBodyWeight! <
                                                                weight!)
                                                              Text(
                                                                'Note: Assuming you are deficiting or burning atleast 250 calories a day',
                                                                style: GoogleFonts
                                                                    .readexPro(
                                                                  color: Colors
                                                                      .black38,
                                                                  fontSize: 12,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                              ),
                                                            if (desiredBodyWeight! >
                                                                weight!)
                                                              Text(
                                                                'Note: Assuming you are consuming at least 500 more calories than your required intake',
                                                                style: GoogleFonts
                                                                    .readexPro(
                                                                  color: Colors
                                                                      .black38,
                                                                  fontSize: 12,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                              ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () => {
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    '/editHealth')
                                                              },
                                                              style:
                                                                  ButtonStyle(
                                                                overlayColor: MaterialStateColor
                                                                    .resolveWith(
                                                                        (states) =>
                                                                            Colors.white30),
                                                                backgroundColor:
                                                                    const MaterialStatePropertyAll<
                                                                        Color>(
                                                                  Color(
                                                                      0xff4b39ef),
                                                                ),
                                                                side:
                                                                    const MaterialStatePropertyAll(
                                                                  BorderSide(
                                                                    color: Color(
                                                                        0xFFE0E3E7),
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        OutlinedBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50.0),
                                                                  ),
                                                                ),
                                                                padding:
                                                                    MaterialStateProperty
                                                                        .all<
                                                                            EdgeInsets>(
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      5,
                                                                      10,
                                                                      5),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                'Update Weight',
                                                                style: GoogleFonts
                                                                    .readexPro(
                                                                  fontSize:
                                                                      11.0,
                                                                  textStyle:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Card(
                                                  elevation: 3,
                                                  color: Colors.white,
                                                  shadowColor: Colors.blue,
                                                  child: Material(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Column(
                                                        children: [
                                                          Center(
                                                            child: Text(
                                                              'Health Details',
                                                              style: GoogleFonts
                                                                  .readexPro(
                                                                fontSize: 18.0,
                                                                textStyle:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 30,
                                                            width: 100,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        20,
                                                                        0,
                                                                        5,
                                                                        0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'DBW:',
                                                                      style: GoogleFonts
                                                                          .readexPro(
                                                                        color: const Color(
                                                                            0xFF57636C),
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                      semanticsLabel:
                                                                          "Desired Body Weight",
                                                                    ),
                                                                    Text(
                                                                      'Weight:',
                                                                      style: GoogleFonts
                                                                          .readexPro(
                                                                        color: const Color(
                                                                            0xFF57636C),
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'Height:',
                                                                      style: GoogleFonts
                                                                          .readexPro(
                                                                        color: const Color(
                                                                            0xFF57636C),
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'BMI:',
                                                                      style: GoogleFonts
                                                                          .readexPro(
                                                                        color: const Color(
                                                                            0xFF57636C),
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'Lifestyle:',
                                                                      style: GoogleFonts
                                                                          .readexPro(
                                                                        color: const Color(
                                                                            0xFF57636C),
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        20,
                                                                        0,
                                                                        5,
                                                                        0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "${desiredBodyWeight?.toInt()}Kg",
                                                                      style: GoogleFonts
                                                                          .readexPro(
                                                                        color: const Color(
                                                                            0xFF57636C),
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "${(weight?.toInt()).toString()}Kg",
                                                                      style: GoogleFonts
                                                                          .readexPro(
                                                                        color: const Color(
                                                                            0xFF57636C),
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "${(height?.toInt()).toString()}cm",
                                                                      style: GoogleFonts
                                                                          .readexPro(
                                                                        color: const Color(
                                                                            0xFF57636C),
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      userBMI!,
                                                                      style: GoogleFonts
                                                                          .readexPro(
                                                                        color: const Color(
                                                                            0xFF57636C),
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      lifestyle!,
                                                                      style: GoogleFonts
                                                                          .readexPro(
                                                                        color: const Color(
                                                                            0xFF57636C),
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    20,
                                                                    0,
                                                                    0,
                                                                    10),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                'Chronic Disease:',
                                                                style: GoogleFonts
                                                                    .readexPro(
                                                                  color: const Color(
                                                                      0xFF57636C),
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    20,
                                                                    0,
                                                                    0,
                                                                    30),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children:
                                                                    chronicDisease!
                                                                        .map((e) =>
                                                                            Text(
                                                                              e,
                                                                              style: GoogleFonts.readexPro(
                                                                                color: const Color(0xFF57636C),
                                                                                fontSize: 14.0,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                            ))
                                                                        .toList(),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                'Foods Not allowed',
                                                                style: GoogleFonts
                                                                    .readexPro(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ), // Optional spacing
                                                          ..._getFoodRestrictions(),
                                                          SizedBox(
                                                              height:
                                                                  20), // Optional spacing
                                                        ],
                                                      ),
                                                    ),
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
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 50,
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
                            FontAwesomeIcons.utensils,
                            color: Color(0xff4b39ef),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              //alignment: WrapAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                        blurStyle: BlurStyle.outer,
                        blurRadius: 5.0,
                        color: Color(0xff4b39ef).withOpacity(0.8),
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.circular(8.0),
                    shape: BoxShape.rectangle,
                  ),
                  child: Material(
                    //elevation: 5,
                    //borderRadius: BorderRadius.circular(10),
                    //clipBehavior: Clip.antiAliasWithSaveLayer,
                    //shadowColor: const Color(0xff4b39ef),
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
                                          color: const Color.fromARGB(
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
                                              child: Text(
                                                'Please eat food first before doing exercise. Currently you have less than 5% calories which is not enough to burn Calories',
                                                style: GoogleFonts.readexPro(
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
                                      );
                                    });
                                  });
                            },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Ink.image(
                            image:
                                const AssetImage('assets/images/exercise.png'),
                            height: 160,
                            width: MediaQuery.sizeOf(context).width * 0.44,
                            fit: BoxFit.fitWidth,
                          ),
                          Text(
                            'Exercise',
                            style: GoogleFonts.readexPro(
                              textStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            textScaler: TextScaler.linear(1.1),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                        blurStyle: BlurStyle.outer,
                        blurRadius: 5.0,
                        color: Color(0xff4b39ef).withOpacity(0.8),
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.circular(8.0),
                    shape: BoxShape.rectangle,
                  ),
                  child: Material(
                    /* elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shadowColor: const Color(0xff4b39ef), */
                    child: InkWell(
                      onTap: () {
                        mealPlanGeneratorSelector(context);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Ink.image(
                            image: const AssetImage('assets/images/food.png'),
                            height: 160,
                            width: MediaQuery.sizeOf(context).width * 0.44,
                            fit: BoxFit.fitWidth,
                          ),
                          Text(
                            'Meal Plan',
                            style: GoogleFonts.readexPro(
                              textStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            textScaler: TextScaler.linear(1.1),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
                  margin: const EdgeInsets.fromLTRB(20, 120, 20, 120),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      // Title
                      Align(
                        alignment: Alignment.bottomCenter,
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
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 25, 25, 10),
                            child: Column(
                              children: [
                                ...savedData.entries.map((entry) {
                                  String mealType = entry
                                      .key; // Get the meal type (e.g., Breakfast)
                                  var mealsData = entry
                                      .value; // This should be the list of meals

                                  // Ensure that mealsData is a List
                                  if (mealsData is List) {
                                    // Iterate through each meal in mealsData
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: mealsData.map<Widget>((meal) {
                                        String mealTitle =
                                            meal['meal']; // Get the meal title
                                        var selectedFoods = meal[
                                            'foods']; // Get the foods for this meal

                                        // Ensure that selectedFoods is a List
                                        if (selectedFoods is List) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Display meal type
                                                Text(
                                                  mealTitle,
                                                  style: GoogleFonts.readexPro(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    height:
                                                        8), // Space between meal type and foods
                                                ...selectedFoods.map<Widget>(
                                                    (selectedFood) {
                                                  String? foodName = selectedFood[
                                                      'foodName']; // Nullable type for foodName
                                                  String? servingSize =
                                                      selectedFood[
                                                          'servingSize']; // Use servingSize
                                                  int quantity = selectedFood[
                                                          'quantity'] ??
                                                      1; // Default to 1 if quantity is missing

                                                  // Check if foodName and servingSize are not null
                                                  if (foodName != null &&
                                                      servingSize != null &&
                                                      itemMacronutrients
                                                          .containsKey(
                                                              foodName) &&
                                                      itemMacronutrients[
                                                              foodName]!
                                                          .containsKey(
                                                              servingSize)) {
                                                    Map<String, dynamic>
                                                        macronutrients =
                                                        itemMacronutrients[
                                                                foodName]![
                                                            servingSize]!;

                                                    // Calculate macronutrients based on quantity
                                                    int totalCarbs =
                                                        macronutrients[
                                                                'carbs']! *
                                                            quantity;
                                                    int totalFats =
                                                        macronutrients[
                                                                'fats']! *
                                                            quantity;
                                                    int totalProteins =
                                                        macronutrients[
                                                                'proteins']! *
                                                            quantity;

                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 0,
                                                          8), // Use vertical padding to minimize left/right gap
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            foodName,
                                                            style: GoogleFonts
                                                                .readexPro(
                                                              fontSize: 14.0,
                                                              textStyle:
                                                                  const TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            "Serving: $servingSize",
                                                            style: GoogleFonts
                                                                .readexPro(
                                                              fontSize: 12.0,
                                                              textStyle:
                                                                  const TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        0,
                                                                        0),
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            'Quantity: x$quantity\n'
                                                            'Carbs: $totalCarbs g, '
                                                            'Fats: $totalFats g, '
                                                            'Proteins: $totalProteins g',
                                                            style: GoogleFonts
                                                                .readexPro(
                                                              fontSize: 12.0,
                                                              textStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    // Log if no matching food found
                                                    print(
                                                        'No macronutrients found for food: $foodName, serving size: $servingSize');
                                                    return const SizedBox(); // Return empty widget if no match found or foodName is null
                                                  }
                                                }).toList(),
                                              ],
                                            ),
                                          );
                                        } else {
                                          // Log if selectedFoods is not a List
                                          print(
                                              'Expected selectedFoods to be a List for meal type: $mealTitle');
                                          return const SizedBox(); // Return empty widget if selectedFoods is not a List
                                        }
                                      }).toList(),
                                    );
                                  } else {
                                    // Log if mealsData is not a List
                                    print(
                                        'Expected mealsData to be a List for meal type: $mealType');
                                    return const SizedBox(); // Return empty widget if mealsData is not a List
                                  }
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Show total macronutrients
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Color(0xff4b39ef),
                        ),
                        padding: const EdgeInsets.fromLTRB(30, 0, 5, 0),
                        width: MediaQuery.sizeOf(context).width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const Divider(),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Total Macronutrients",
                              style: GoogleFonts.readexPro(
                                fontSize: 16.0,
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Carbs:",
                                      style: GoogleFonts.readexPro(
                                        fontSize: 14.0,
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Fats:",
                                      style: GoogleFonts.readexPro(
                                        fontSize: 14.0,
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Proteins:",
                                      style: GoogleFonts.readexPro(
                                        fontSize: 14.0,
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${calculateTotalMacronutrients(savedData)['carbs']} g",
                                      style: GoogleFonts.readexPro(
                                        fontSize: 14.0,
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${calculateTotalMacronutrients(savedData)['fats']} g",
                                      style: GoogleFonts.readexPro(
                                        fontSize: 14.0,
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${calculateTotalMacronutrients(savedData)['proteins']} g",
                                      style: GoogleFonts.readexPro(
                                        fontSize: 14.0,
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        overlayColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.white30),
                                        backgroundColor:
                                            const MaterialStatePropertyAll<
                                                Color>(
                                          Colors.redAccent,
                                        ),
                                        side: const MaterialStatePropertyAll(
                                          BorderSide(
                                            color: Color(0xFFE0E3E7),
                                            width: 1.0,
                                          ),
                                        ),
                                        shape: MaterialStateProperty.all<
                                            OutlinedBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                        ),
                                        padding: MaterialStateProperty.all<
                                            EdgeInsets>(
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        ),
                                      ),
                                      onPressed: () {
                                        // Show confirmation dialog before clearing
                                        _showClearConfirmationDialog(context);
                                      },
                                      child: Text(
                                        'Clear',
                                        style: GoogleFonts.readexPro(
                                          fontSize: 11.0,
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Center(
                child: Card(
                  color: const Color.fromARGB(234, 255, 255, 255),
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
          backgroundColor: Colors.white,
          title: Text(
            "Clear Food Items",
            style: GoogleFonts.readexPro(
              fontSize: 20.0,
              textStyle: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          content: Text(
            "Are you sure you want to clear all food items?",
            style: GoogleFonts.readexPro(
              fontSize: 14.0,
              textStyle: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                clearFoodItems(context); // Pass context to show Snackbar
              },
              child: Text(
                "Confirm",
                style: GoogleFonts.readexPro(
                  fontSize: 15.0,
                  textStyle: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(
                "No",
                style: GoogleFonts.readexPro(
                  fontSize: 15.0,
                  textStyle: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
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
          .set({}); // Clear the selectedFoods

      // Show confirmation Snackbar if the widget is still mounted

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("All food items have been cleared."),
            behavior: SnackBarBehavior.floating,
            elevation: 3,
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.of(context).pop(); // Close dialog
        Navigator.of(context).pop(); // Close dialog
      }
    } catch (e) {
      // Show error Snackbar if the widget is still mounted
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to clear food items. Please try again."),
            behavior: SnackBarBehavior.floating,
            elevation: 3,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Map<String, int> calculateTotalMacronutrients(
      Map<String, dynamic> savedData) {
    int totalCarbs = 0;
    int totalFats = 0;
    int totalProteins = 0;

    // Use a Map to accumulate quantities of the same food and serving size
    Map<String, Map<String, int>> foodQuantityMap = {};

    // Check if 'selectedFoods' exists and is a List
    if (savedData.containsKey('selectedFoods') &&
        savedData['selectedFoods'] is List) {
      // Iterate through each meal entry
      for (var mealEntry in savedData['selectedFoods']) {
        // Ensure that mealEntry is a Map and contains 'foods'
        if (mealEntry is Map<String, dynamic> &&
            mealEntry.containsKey('foods')) {
          List<dynamic> foods = mealEntry['foods'];

          // Iterate through each food in the foods list
          for (var selectedFood in foods) {
            String foodName = selectedFood['foodName'] ?? '';
            String servingSize = selectedFood['servingSize'] ?? '';
            int quantity =
                selectedFood['quantity'] ?? 1; // Get quantity, default to 1

            // If the same food and serving size exists, increase the quantity
            if (foodQuantityMap.containsKey(foodName)) {
              if (foodQuantityMap[foodName]!.containsKey(servingSize)) {
                foodQuantityMap[foodName]![servingSize] =
                    foodQuantityMap[foodName]![servingSize]! + quantity;
              } else {
                foodQuantityMap[foodName]![servingSize] = quantity;
              }
            } else {
              foodQuantityMap[foodName] = {servingSize: quantity};
            }
          }
        } else {
          // Log a message if mealEntry is not valid (for debugging)
          print('Expected mealEntry to be a Map with a "foods" key');
        }
      }

      // Now iterate through the foodQuantityMap to calculate macronutrients
      foodQuantityMap.forEach((foodName, servingMap) {
        servingMap.forEach((servingSize, quantity) {
          // Check if the item exists in itemMacronutrients
          if (itemMacronutrients.containsKey(foodName) &&
              itemMacronutrients[foodName]!.containsKey(servingSize)) {
            Map<String, dynamic> macronutrients =
                itemMacronutrients[foodName]![servingSize]!;

            // Sum up the macronutrients considering the accumulated quantity
            totalCarbs += (macronutrients['carbs'] as int) * quantity;
            totalFats += (macronutrients['fats'] as int) * quantity;
            totalProteins += (macronutrients['proteins'] as int) * quantity;
          } else {
            // Log a message for foods not found in itemMacronutrients (for debugging)
            print(
                'No macronutrients found for food: $foodName, serving size: $servingSize');
          }
        });
      });
    } else {
      // Log a message if 'selectedFoods' is not found or not a List (for debugging)
      print('No selectedFoods found or it is not a List in savedData');
    }

    // Return the total macronutrient sums
    return {
      'carbs': totalCarbs,
      'fats': totalFats,
      'proteins': totalProteins,
    };
  }
}
