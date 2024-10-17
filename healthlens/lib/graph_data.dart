import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:intl/intl.dart';

class ChartData {
  ChartData(this.x, this.y1, this.y2, this.y3);
  final String x; // Day as string (e.g., 'Mon', 'Tue')
  final double y1; // Fats
  final double y2; // Proteins
  final double y3; // Carbs
}

class AverageData {
  final String x;
  final num y;
  final num y2;
  final num y3;
  AverageData(this.x, this.y, this.y2, this.y3);
}

List<ChartData> chartData = []; // Data for today
List<ChartData> chartData1 = []; // Last 7 days data
List<ChartData> chartData2 = []; // Last 30 days data

List<AverageData> barChart = [];
List<AverageData> barChart1 = [];
List<AverageData> barChart2 = [];

Future<void> fetchMacrosData() async {
  final firestore = FirebaseFirestore.instance;
  final DateTime now = DateTime.now();
  final DateTime sevenDaysAgo = now.subtract(Duration(days: 7));
  final DateTime thirtyDaysAgo = now.subtract(Duration(days: 30));
  final String todayDate = DateFormat('yyyy-MM-dd').format(now);

  // Fetch data for today
  QuerySnapshot<Map<String, dynamic>> todaySnapshot = await firestore
      .collection('food_history')
      .doc(thisUser?.uid)
      .collection(todayDate)
      .get();
  final Map<String, Map<String, double>> todayMap = {};
  for (var doc in todaySnapshot.docs) {
    final data = doc.data();
    final List<dynamic> items = data['items'] ?? [];
    final time = DateFormat('HH:mm').format(DateTime.parse(data['timestamp']));

    if (!todayMap.containsKey(time)) {
      todayMap[time] = {'fats': 0, 'proteins': 0, 'carbs': 0};
    }

    for (var item in items) {
      final quantity = item['quantity'] ?? 1;
      todayMap[time]!['fats'] =
          (todayMap[time]!['fats'] ?? 0) + (item['fats'] ?? 0) * quantity;
      todayMap[time]!['proteins'] = (todayMap[time]!['proteins'] ?? 0) +
          (item['proteins'] ?? 0) * quantity;
      todayMap[time]!['carbs'] =
          (todayMap[time]!['carbs'] ?? 0) + (item['carbs'] ?? 0) * quantity;
    }
  }

// Convert todayMap entries to a list and sort by time
  final sortedEntries = todayMap.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));

// Create chartData from sorted map entries
  chartData = sortedEntries.map((entry) {
    return ChartData(
      entry.key, // Time in hh:mm
      entry.value['fats']!.toDouble(),
      entry.value['proteins']!.toDouble(),
      entry.value['carbs']!.toDouble(),
    );
  }).toList();

  // Fetch data for last 7 days
  QuerySnapshot<Map<String, dynamic>> last7DaysSnapshot = await firestore
      .collection('userMacros')
      .doc(thisUser?.uid)
      .collection('MacrosIntakeHistory')
      .where(FieldPath.documentId,
          isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(sevenDaysAgo))
      .where(FieldPath.documentId,
          isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(now))
      .get();

  chartData1 = last7DaysSnapshot.docs.map((doc) {
    final data = doc.data();
    DateTime date = DateTime.parse(doc.id);
    String displayDate =
        getDayOfWeek(date.weekday); // Convert to 'Mon', 'Tue', etc.
    return ChartData(
      displayDate,
      (data['fats'] ?? 0).toDouble(),
      (data['proteins'] ?? 0).toDouble(),
      (data['carbs'] ?? 0).toDouble(),
    );
  }).toList();

  // Fetch data for last 30 days
  QuerySnapshot<Map<String, dynamic>> last30DaysSnapshot = await firestore
      .collection('userMacros')
      .doc(thisUser?.uid)
      .collection('MacrosIntakeHistory')
      .where(FieldPath.documentId,
          isGreaterThanOrEqualTo:
              DateFormat('yyyy-MM-dd').format(thirtyDaysAgo))
      .where(FieldPath.documentId,
          isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(now))
      .get();

  chartData2 = last30DaysSnapshot.docs.map((doc) {
    final data = doc.data();
    DateTime date = DateTime.parse(doc.id);
    String displayDate = date.day.toString(); // Convert to day number
    return ChartData(
      displayDate,
      (data['fats'] ?? 0).toDouble(),
      (data['proteins'] ?? 0).toDouble(),
      (data['carbs'] ?? 0).toDouble(),
    );
  }).toList();

  updateAverageData();

  // Iterate over each item in the barChart
  for (var data in barChart) {
    // Access the fields of each AverageData object
    avrgFat = data.y; // Assuming y represents fats
    avrgProteins = data.y2; // Assuming y2 represents proteins
    avrgCarbs = data.y3; // Assuming y3 represents carbs
  }
  for (var data in barChart1) {
    // Access the fields of each AverageData object
    avrg7Fat = data.y; // Assuming y represents fats
    avrg7Proteins = data.y2; // Assuming y2 represents proteins
    avrg7Carbs = data.y3; // Assuming y3 represents carbs
  }
  for (var data in barChart2) {
    // Access the fields of each AverageData object
    avrg30Fat = data.y; // Assuming y represents fats
    avrg30Proteins = data.y2; // Assuming y2 represents proteins
    avrg30Carbs = data.y3; // Assuming y3 represents carbs
  }
  // Optional: Calculate overall average for specific period or other metrics if needed
}

void updateAverageData() {
  // Helper function to round a double to 2 decimal points
  double decimalValue(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  // Average for Today (barChart)
  final todayFats = chartData.map((data) => data.y1).toList();
  final todayProteins = chartData.map((data) => data.y2).toList();
  final todayCarbs = chartData.map((data) => data.y3).toList();

  barChart = [
    AverageData(
      'Avg. Today',
      todayFats.isNotEmpty
          ? decimalValue(todayFats.reduce((a, b) => a + b) / todayFats.length)
          : 0,
      todayProteins.isNotEmpty
          ? decimalValue(
              todayProteins.reduce((a, b) => a + b) / todayProteins.length)
          : 0,
      todayCarbs.isNotEmpty
          ? decimalValue(todayCarbs.reduce((a, b) => a + b) / todayCarbs.length)
          : 0,
    ),
  ];

  // Average for Last 7 Days (barChart1)
  final last7DaysFats = chartData1.map((data) => data.y1).toList();
  final last7DaysProteins = chartData1.map((data) => data.y2).toList();
  final last7DaysCarbs = chartData1.map((data) => data.y3).toList();

  barChart1 = [
    AverageData(
      'Avg. 7 days',
      last7DaysFats.isNotEmpty
          ? decimalValue(
              last7DaysFats.reduce((a, b) => a + b) / last7DaysFats.length)
          : 0,
      last7DaysProteins.isNotEmpty
          ? decimalValue(last7DaysProteins.reduce((a, b) => a + b) /
              last7DaysProteins.length)
          : 0,
      last7DaysCarbs.isNotEmpty
          ? decimalValue(
              last7DaysCarbs.reduce((a, b) => a + b) / last7DaysCarbs.length)
          : 0,
    ),
  ];

  // Average for Last 30 Days (barChart2)
  final last30DaysFats = chartData2.map((data) => data.y1).toList();
  final last30DaysProteins = chartData2.map((data) => data.y2).toList();
  final last30DaysCarbs = chartData2.map((data) => data.y3).toList();

  barChart2 = [
    AverageData(
      'Avg. 30 days',
      last30DaysFats.isNotEmpty
          ? decimalValue(
              last30DaysFats.reduce((a, b) => a + b) / last30DaysFats.length)
          : 0,
      last30DaysProteins.isNotEmpty
          ? decimalValue(last30DaysProteins.reduce((a, b) => a + b) /
              last30DaysProteins.length)
          : 0,
      last30DaysCarbs.isNotEmpty
          ? decimalValue(
              last30DaysCarbs.reduce((a, b) => a + b) / last30DaysCarbs.length)
          : 0,
    ),
  ];
}

String getDayOfWeek(int weekday) {
  switch (weekday) {
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
