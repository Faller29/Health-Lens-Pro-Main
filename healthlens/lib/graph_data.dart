class ChartData {
  ChartData(this.x, this.y1, this.y2, this.y3);
  final String x;
  final double y1;
  final double y2;
  final double y3;
}

class AverageData {
  final String x;
  final num y;
  final num y2;
  final num y3;
  AverageData(this.x, this.y, this.y2, this.y3);
}

final List<ChartData> chartData = [
  ChartData('7am', 12, 10, 14),
  ChartData('8am', 14, 11, 18),
  ChartData('9am', 14, 10, 15),
  ChartData('10am', 14, 16, 18),
  ChartData('11am', 13, 13, 18),
  ChartData('12am', 16, 10, 14),
];

final List<ChartData> chartData1 = [
  ChartData('Mon', 16, 13, 14),
  ChartData('Tue', 14, 14, 16),
  ChartData('Wed', 16, 11, 12),
  ChartData('Thu', 19, 21, 11),
  ChartData('Fri', 14, 12, 18),
  ChartData('Sat', 17, 22, 23),
  ChartData('Sun', 17, 16, 21),
];

final List<ChartData> chartData2 = [
  ChartData('1', 16, 16, 14),
  ChartData('2', 14, 12, 18),
  ChartData('3', 16, 23, 15),
  ChartData('4', 13, 16, 13),
  ChartData('5', 21, 23, 18),
  ChartData('6', 16, 11, 15),
  ChartData('7', 16, 11, 25),
  ChartData('8', 14, 23, 12),
  ChartData('9', 11, 21, 23),
];

List<AverageData> barChart = [
  AverageData('Ave. Today', 14, 13, 18),
];
List<AverageData> barChart1 = [
  AverageData('Ave. 7 days', 16, 19, 18),
];
List<AverageData> barChart2 = [
  AverageData('Ave. 30 days', 24, 22, 19),
];

final List<ChartData> weight = [
  ChartData('1', 76, 16, 14),
  ChartData('2', 76, 12, 18),
  ChartData('3', 76, 23, 15),
  ChartData('4', 75.5, 16, 13),
  ChartData('5', 75.1, 23, 18),
  ChartData('6', 75.4, 11, 15),
  ChartData('7', 75.8, 11, 25),
  // ChartData('8', 76, 23, 12),
  // ChartData('9', 76, 21, 23),
  // ChartData('10', 76, 16, 14),
  // ChartData('11', 76, 12, 18),
  // ChartData('12', 76, 12, 18),
  // ChartData('13', 76, 23, 15),
  // ChartData('14', 75.5, 16, 13),
  // ChartData('15', 75.1, 23, 18),
  // ChartData('16', 75.4, 11, 15),
  // ChartData('17', 75.8, 11, 25),
  // ChartData('18', 76, 23, 12),
  // ChartData('19', 76, 21, 23),
  // ChartData('20', 76, 12, 18),
  // ChartData('21', 76, 16, 14),
  // ChartData('22', 76, 12, 18),
  // ChartData('23', 76, 23, 15),
  // ChartData('24', 75.5, 16, 13),
  // ChartData('25', 75.1, 23, 18),
  // ChartData('26', 75.4, 11, 15),
  // ChartData('27', 75.8, 11, 25),
  // ChartData('28', 76, 23, 12),
  // ChartData('29', 76, 21, 23),
];
