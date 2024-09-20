import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'main.dart'; // Assuming this contains `thisUser?.uid`

class WeightData {
  WeightData(this.x, this.y1);
  final String x; // Day as string (e.g., 'Mon', 'Tue')
  final double y1; // Weight
}

List<WeightData> dailyWeight = [];
List<WeightData> weeklyWeight = [];
List<WeightData> monthlyWeight = [];
Future<Map<String, List<WeightData>>> predictWeightChange() async {
  final firestore = FirebaseFirestore.instance;
  final String? _userId = thisUser?.uid;
  print('predict weight of: ');
  print(_userId);
  if (_userId == null) {
    throw Exception("User ID is null");
  }

  // Fetch idealBodyWeight and currentWeight from Firestore
  double idealBodyWeight = await _fetchIdealBodyWeight(firestore, _userId);
  double currentWeight = await _fetchCurrentWeight(firestore, _userId);

  if (idealBodyWeight == 0 || currentWeight == 0) {
    throw Exception("Ideal body weight or current weight is unavailable");
  }

  // Define the weight gain/loss rates
  double weightGainRate = 0.2; // Example: 0.2 kg gained per day
  double weightLossRate = 0.1; // Example: 0.1 kg lost per day

  // Helper function to round to the nearest tenth
  double formatWeight(double value) {
    return double.parse(value.toStringAsFixed(1));
  }

  // Start from today
  DateTime currentDate = DateTime.now();
  DateFormat dateFormat = DateFormat('dd/MM'); // Format day/month

  // Determine if the user is gaining or losing weight
  if (currentWeight < idealBodyWeight) {
    // Weight gain scenario
    while (currentWeight < idealBodyWeight) {
      dailyWeight.add(WeightData(
          dateFormat.format(currentDate), formatWeight(currentWeight)));

      // Add weekly weight (once every 7 days)
      if (currentDate.difference(DateTime.now()).inDays % 7 == 0) {
        weeklyWeight.add(WeightData(
            dateFormat.format(currentDate), formatWeight(currentWeight)));
      }

      // Add monthly weight (once every 30 days)
      if (currentDate.difference(DateTime.now()).inDays % 30 == 0) {
        monthlyWeight.add(WeightData(
            dateFormat.format(currentDate), formatWeight(currentWeight)));
      }

      currentWeight += weightGainRate; // Apply weight gain rate
      currentDate = currentDate.add(Duration(days: 1)); // Move to the next day
    }
  } else {
    // Weight loss scenario
    while (currentWeight > idealBodyWeight) {
      dailyWeight.add(WeightData(
          dateFormat.format(currentDate), formatWeight(currentWeight)));

      // Add weekly weight (once every 7 days)
      if (currentDate.difference(DateTime.now()).inDays % 7 == 0) {
        weeklyWeight.add(WeightData(
            dateFormat.format(currentDate), formatWeight(currentWeight)));
      }

      // Add monthly weight (once every 30 days)
      if (currentDate.difference(DateTime.now()).inDays % 30 == 0) {
        monthlyWeight.add(WeightData(
            dateFormat.format(currentDate), formatWeight(currentWeight)));
      }

      currentWeight -= weightLossRate; // Apply weight loss rate
      currentDate = currentDate.add(Duration(days: 1)); // Move to the next day
    }
  }

  // Add the final ideal body weight
  dailyWeight.add(WeightData(
      dateFormat.format(currentDate), formatWeight(idealBodyWeight)));
  weeklyWeight.add(WeightData(
      dateFormat.format(currentDate), formatWeight(idealBodyWeight)));
  monthlyWeight.add(WeightData(
      dateFormat.format(currentDate), formatWeight(idealBodyWeight)));

  return {
    'daily': dailyWeight,
    'weekly': weeklyWeight,
    'monthly': monthlyWeight,
  };
}

// Helper function to fetch ideal body weight from Firestore with null handling
Future<double> _fetchIdealBodyWeight(
    FirebaseFirestore firestore, String userId) async {
  DocumentSnapshot<Map<String, dynamic>> doc =
      await firestore.collection('user').doc(userId).get();

  // Return 0 if idealBodyWeight is not available or if doc is null
  return (doc.data()?['desiredBodyWeight'] ?? 0).toDouble();
}

// Helper function to fetch current weight from Firestore with null handling
Future<double> _fetchCurrentWeight(
    FirebaseFirestore firestore, String userId) async {
  DocumentSnapshot<Map<String, dynamic>> doc =
      await firestore.collection('user').doc(userId).get();

  // Return 0 if currentWeight is not available or if doc is null
  return (doc.data()?['weight'] ?? 0).toDouble();
}
