import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/main.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HistoryPage extends StatefulWidget {
  final String formattedDate;

  const HistoryPage({Key? key, required this.formattedDate}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late String formattedDate;
  List<Map<String, dynamic>> foodHistory = [];
  List<Map<String, dynamic>> ExerciseHistory = [];
  bool isLoading = true; // Loading state flag
  double historyCarbs = 0;
  double historyFats = 0;
  double historyProtein = 0;
  double historyCalories = 0;

  double totalCaloriesBurned = 0;
  double historyExerciseCalories = 0;
  final ScrollController _scrollController = ScrollController();

  // Add keys for sections
  final GlobalKey _foodHistoryKey = GlobalKey();
  final GlobalKey _exerciseHistoryKey = GlobalKey();

  void goToFoodHistory() {
    Scrollable.ensureVisible(
      _foodHistoryKey.currentContext!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void goToExerciseHistory() {
    Scrollable.ensureVisible(
      _exerciseHistoryKey.currentContext!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    formattedDate = widget.formattedDate;
    fetchData(); // Combine fetch operations into one
  }

// A function to fetch both food and exercise history, then perform calorie deduction
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    // Fetch both food and exercise history in parallel
    await Future.wait([fetchFoodHistory(), fetchExerciseHistory()]);

    // Deduct the exercise calories from the total food calories
    setState(() {
      historyCalories -= totalCaloriesBurned;
      print('Final total after exercise deduction: $historyCalories');
      isLoading = false; // Both data fetching are completed
    });
  }

// Fetch food history and accumulate carbs, proteins, fats, and calories
  Future<void> fetchFoodHistory() async {
    try {
      String uid = thisUser!.uid; // Use the actual UID
      CollectionReference dateRef = FirebaseFirestore.instance
          .collection('food_history')
          .doc(uid)
          .collection(formattedDate);

      print('Fetching food history for $formattedDate');

      // Get all documents under the formattedDate collection (representing time subcollections)
      QuerySnapshot timeSnapshots = await dateRef.get();

      List<Map<String, dynamic>> fetchedHistory = [];

      // Reset macronutrient accumulations for food history
      historyCarbs = 0;
      historyProtein = 0;
      historyFats = 0;
      historyCalories = 0; // Reset historyCalories for food

      // Iterate through each time subcollection (document)
      for (var timeDoc in timeSnapshots.docs) {
        // Fetch items from each time document
        List<dynamic> items = timeDoc.get('items');

        for (var item in items) {
          fetchedHistory.add({
            'item': item['item'],
            'part': item['part'],
            'carbs': item['carbs'],
            'fats': item['fats'],
            'proteins': item['proteins'],
            'quantity': item['quantity'],
            'timestamp': timeDoc.id, // Use the time as the timestamp
          });

          // Accumulate daily macronutrients for food
          historyCarbs += (item['carbs'] * item['quantity']);
          historyProtein += (item['proteins'] * item['quantity']);
          historyFats += (item['fats'] * item['quantity']);
        }
      }

      // Calculate the total food calories: 4 calories per gram of carbs and proteins, 9 per gram of fats
      historyCalories =
          (historyCarbs * 4) + (historyProtein * 4) + (historyFats * 9);
      print('Food calories: $historyCalories');

      setState(() {
        foodHistory = fetchedHistory;
      });
    } catch (e) {
      print('Error fetching food history: $e');
    }
  }

// Fetch exercise history and accumulate calories burned from exercise
  Future<void> fetchExerciseHistory() async {
    try {
      String uid = thisUser!.uid; // Get the user's UID
      CollectionReference dateRef = FirebaseFirestore.instance
          .collection('user_activity')
          .doc(uid)
          .collection(formattedDate); // Access collection for the specific date

      print('Fetching exercise history for $formattedDate');

      // Fetch all documents for the specified date (each document represents an exercise session at a specific time)
      QuerySnapshot timeSnapshots = await dateRef.get();

      // Initialize an empty list to store the fetched exercise history
      List<Map<String, dynamic>> fetchedExerciseHistory = [];
      totalCaloriesBurned = 0; // Reset the total calories burned

      // Iterate through each exercise session document
      for (var timeDoc in timeSnapshots.docs) {
        Map<String, dynamic> exerciseData =
            timeDoc.data() as Map<String, dynamic>;

        // Collect exercise data from each document
        fetchedExerciseHistory.add({
          'exercise': exerciseData['exercise'], // Exercise name
          'calories': exerciseData['calories'], // Calories burned
          'timestamp': timeDoc.id, // Use document ID as the timestamp
        });

        // Accumulate total calories burned for the day
        totalCaloriesBurned += (exerciseData['calories']?.toDouble() ?? 0);

        print(
            'Exercise: ${exerciseData['exercise']}, Calories: ${exerciseData['calories']}, Timestamp: ${timeDoc.id}');
      }

      print('Total exercise calories burned: $totalCaloriesBurned');

      setState(() {
        ExerciseHistory = fetchedExerciseHistory;
      });
    } catch (e) {
      print('Error fetching exercise history: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          formattedDate,
          style: GoogleFonts.outfit(fontSize: 25.0),
        ),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff4b39ef),
      ),
      body: SingleChildScrollView(
        controller: _scrollController, // Attach the controller
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(14.0, 10.0, 14.0, 0.0),
              child: Container(
                width: 350.0,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  boxShadow: [
                    const BoxShadow(
                      blurRadius: 4.0,
                      color: Color(0x33000000),
                      offset: Offset(0.0, 2.0),
                    ),
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
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildMacronutrientCard(
                          'Carbohydrates',
                          historyCarbs,
                          historyCarbs,
                          (gramCarbs ?? 0),
                          const Color(0xff4b39ef),
                          ((historyCarbs >= gramCarbs!)
                              ? (gramCarbs! / gramCarbs!)
                              : (historyCarbs / (gramCarbs ?? 1))),
                        ),
                        buildMacronutrientCard(
                          'Protein',
                          historyProtein,
                          historyProtein,
                          (gramProtein ?? 0),
                          const Color(0xffff5963),
                          ((historyProtein >= gramProtein!)
                              ? (gramProtein! / gramProtein!)
                              : (historyProtein / (gramProtein ?? 1))),
                        ),
                        buildMacronutrientCard(
                          'Fats',
                          historyFats,
                          historyFats,
                          (gramFats ?? 0),
                          const Color(0xff249689),
                          ((historyFats >= gramFats!)
                              ? (gramFats! / gramFats!)
                              : (historyFats / (gramFats ?? 1))),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    //calories
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
                                endValue: ((historyCalories / TER!) * 100),
                                color: Colors.green),
                          ],
                          markerPointers: [
                            LinearShapePointer(
                                elevation: 3,
                                value: ((historyCalories / TER!) * 100)),
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
                              "${historyCalories.toString()}/${TER}",
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: goToFoodHistory,
                            child: Text(
                              'Food History',
                              style: GoogleFonts.readexPro(
                                fontSize: 14.0,
                                textStyle: const TextStyle(
                                    color: Color(0xff4b39ef),
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        TextButton(
                            onPressed: goToExerciseHistory,
                            child: Text(
                              'Exercise History',
                              style: GoogleFonts.readexPro(
                                fontSize: 14.0,
                                textStyle: const TextStyle(
                                    color: Color(0xff4b39ef),
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Food History section with a GlobalKey
            Padding(
              key: _foodHistoryKey, // Set the key for this section
              padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Food History',
                  style: GoogleFonts.readexPro(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    textStyle:
                        const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : foodHistory.isEmpty
                      ? Center(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Text(
                                'No food history for ${widget.formattedDate}',
                                style: const TextStyle(fontSize: 18)),
                          ),
                        )
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: foodHistory.length,
                          itemBuilder: (context, index) {
                            var item = foodHistory[index];
                            return Card(
                              color: Colors.white,
                              elevation: 3,
                              margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                tileColor: Colors.white,
                                title: Text("${item['item']} (${item['part']})",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    "Carbs: ${item['carbs']}, Fats: ${item['fats']}, Proteins: ${item['proteins']}, Quantity: ${item['quantity']}"),
                                trailing: Text(item['timestamp']),
                              ),
                            );
                          },
                        ),
            ),
            // Exercise History section with a GlobalKey
            Padding(
              key: _exerciseHistoryKey, // Set the key for this section
              padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Exercise History',
                  style: GoogleFonts.readexPro(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    textStyle:
                        const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ),
            ),
            // Add your exercise history ListView or other content here
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ExerciseHistory.isEmpty
                      ? Center(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Text(
                                'No food history for ${widget.formattedDate}',
                                style: const TextStyle(fontSize: 18)),
                          ),
                        )
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: ExerciseHistory.length,
                          itemBuilder: (context, index) {
                            var item = ExerciseHistory[index];
                            return Card(
                              color: Colors.white,
                              elevation: 3,
                              margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                tileColor: Colors.white,
                                title: Text("${item['exercise']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text("Calories: ${item['calories']}"),
                                trailing: Text(item['timestamp']),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildMacronutrientCard(String title, double limitCurrent, double current,
    int limit, Color color, double percent) {
  if (current >= limit) {
    String thislimitation = limit.toString();
    current = double.tryParse(thislimitation)!;
    //limitCurrent = current;
  } /* else {
    String thislimitation = limit.toString();
    limitCurrent = double.tryParse(thislimitation)!;
  } */

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
      Text(
        '${limitCurrent.toStringAsFixed(0)}/${limit}',
        style: GoogleFonts.readexPro(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ],
  );
}
