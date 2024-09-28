import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'main.dart';

class WeightData {
  WeightData(this.x, this.y1);
  final String x;
  final double y1;
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

  double idealBodyWeight = await _fetchIdealBodyWeight(firestore, _userId);
  double currentWeight = await _fetchCurrentWeight(firestore, _userId);

  if (idealBodyWeight == 0 || currentWeight == 0) {
    throw Exception("Ideal body weight or current weight is unavailable");
  }

  double weightGainRate =
      0.06; //Assuming you are consuming at least 500 more calories than your required intake.
  double weightLossRate =
      0.03; //Assuming you are doing at least 30 minutes of moderate exercise per day.

  double formatWeight(double value) {
    return double.parse(value.toStringAsFixed(1));
  }

  DateTime currentDate = DateTime.now();
  DateFormat dateFormat = DateFormat('dd/MM/yy');

  if (currentWeight < idealBodyWeight) {
    while (currentWeight < idealBodyWeight) {
      dailyWeight.add(WeightData(
          dateFormat.format(currentDate), formatWeight(currentWeight)));

      if (currentDate.difference(DateTime.now()).inDays % 7 == 0) {
        weeklyWeight.add(WeightData(
            dateFormat.format(currentDate), formatWeight(currentWeight)));
      }

      if (currentDate.difference(DateTime.now()).inDays % 30 == 0) {
        monthlyWeight.add(WeightData(
            dateFormat.format(currentDate), formatWeight(currentWeight)));
      }

      currentWeight += weightGainRate;
      currentDate = currentDate.add(Duration(days: 1));
    }
  } else {
    while (currentWeight > idealBodyWeight) {
      dailyWeight.add(WeightData(
          dateFormat.format(currentDate), formatWeight(currentWeight)));

      if (currentDate.difference(DateTime.now()).inDays % 7 == 0) {
        weeklyWeight.add(WeightData(
            dateFormat.format(currentDate), formatWeight(currentWeight)));
      }

      if (currentDate.difference(DateTime.now()).inDays % 30 == 0) {
        monthlyWeight.add(WeightData(
            dateFormat.format(currentDate), formatWeight(currentWeight)));
      }

      currentWeight -= weightLossRate;
      currentDate = currentDate.add(Duration(days: 1));
    }
  }

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

Future<double> _fetchIdealBodyWeight(
    FirebaseFirestore firestore, String userId) async {
  DocumentSnapshot<Map<String, dynamic>> doc =
      await firestore.collection('user').doc(userId).get();

  return (doc.data()?['desiredBodyWeight'] ?? 0).toDouble();
}

Future<double> _fetchCurrentWeight(
    FirebaseFirestore firestore, String userId) async {
  DocumentSnapshot<Map<String, dynamic>> doc =
      await firestore.collection('user').doc(userId).get();

  return (doc.data()?['weight'] ?? 0).toDouble();
}
