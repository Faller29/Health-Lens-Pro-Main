import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'calendar_history.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  int _selectedDayIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  Color protein = Color(0xffff5963);
  Color fats = Color(0xff249689);
  Color carbs = Color(0xff4b39ef);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
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
                        padding: EdgeInsets.fromLTRB(0, 14, 0, 8),
                        child: Text(
                          'Macronutrients',
                          style: GoogleFonts.outfit(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_left,
                                  size: 35,
                                ),
                                onPressed: () {
                                  if (_selectedDayIndex > 0) {
                                    _selectedDayIndex--;
                                    _pageController.previousPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    );
                                  }
                                },
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                _selectedDayIndex == 0
                                    ? "Today"
                                    : _selectedDayIndex == 1
                                        ? "Last 7 days"
                                        : "Last 30 days",
                                style: GoogleFonts.outfit(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_right,
                                  size: 35,
                                ),
                                onPressed: () {
                                  if (_selectedDayIndex < 2) {
                                    _selectedDayIndex++;
                                    _pageController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                        child: SizedBox(
                          height: 300,
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _selectedDayIndex = index;
                              });
                            },
                            children: [
                              // Today content
                              _buildStackedColumnChart(),
                              // Last 7 days content
                              _buildStackedColumnChart1(),
                              // Last 30 days content
                              _buildStackedColumnChart2(),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              label: Text(
                                'Check History',
                                style: GoogleFonts.readexPro(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  textStyle: TextStyle(
                                    color: Color(0xff4b39ef),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/calendar');
                              },
                              icon: Icon(
                                IconlyBroken.calendar,
                                color: Color(0xff4b39ef),
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(14),
                child: Container(
                  height: 200,
                  width: MediaQuery.sizeOf(context).width,
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
                        padding: EdgeInsets.all(14),
                        child: Text(
                          'Food History',
                          style: GoogleFonts.readexPro(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStackedColumnChart() {
    return Column(
      children: [
        Container(
          height: 220,
          width: MediaQuery.sizeOf(context).width,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            legend: Legend(
              isVisible: true,
            ),
            series: <CartesianSeries>[
              StackedColumnSeries<ChartData, String>(
                  color: fats,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  name: 'Fats',
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y1,
                  pointColorMapper: (ChartData data, _) => Color(0xff249689)),
              StackedColumnSeries<ChartData, String>(
                  color: protein,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  name: 'Protein',
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y2,
                  pointColorMapper: (ChartData data, _) => Color(0xffff5963)),
              StackedColumnSeries<ChartData, String>(
                  color: carbs,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  name: 'Carbohydrates',
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y3,
                  pointColorMapper: (ChartData data, _) => Color(0xff4b39ef)),
            ],
          ),
        ),
        Container(
            width: MediaQuery.sizeOf(context).width,
            height: 80,
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries>[
                  StackedBarSeries<AverageData, String>(
                      color: fats,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.inside,
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                        labelAlignment: ChartDataLabelAlignment.middle,
                        alignment: ChartAlignment.center,
                      ),
                      dataSource: barChart,
                      name: 'Fats',
                      xValueMapper: (AverageData data, _) => data.x,
                      yValueMapper: (AverageData data, _) => data.y,
                      pointColorMapper: (AverageData data, _) =>
                          Color(0xff249689)),
                  StackedBarSeries<AverageData, String>(
                      color: protein,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.inside,
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                        labelAlignment: ChartDataLabelAlignment.middle,
                        alignment: ChartAlignment.center,
                      ),
                      dataSource: barChart,
                      name: 'Protein',
                      xValueMapper: (AverageData data, _) => data.x,
                      yValueMapper: (AverageData data, _) => data.y2,
                      pointColorMapper: (AverageData data, _) =>
                          Color(0xffff5963)),
                  StackedBarSeries<AverageData, String>(
                    color: carbs,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.inside,
                      textStyle:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      labelAlignment: ChartDataLabelAlignment.middle,
                      alignment: ChartAlignment.center,
                    ),
                    dataSource: barChart,
                    name: 'Carbohydrates',
                    xValueMapper: (AverageData data, _) => data.x,
                    yValueMapper: (AverageData data, _) => data.y3,
                    pointColorMapper: (AverageData data, _) =>
                        Color(0xff4b39ef),
                  )
                ]))
      ],
    );
  }

  Widget _buildStackedColumnChart1() {
    return Column(
      children: [
        Container(
          height: 220,
          width: MediaQuery.sizeOf(context).width,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            legend: Legend(isVisible: true),
            series: <CartesianSeries>[
              StackedColumnSeries<ChartData, String>(
                  color: fats,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  name: 'Fats',
                  dataSource: chartData1,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y1,
                  pointColorMapper: (ChartData data, _) => Color(0xff249689)),
              StackedColumnSeries<ChartData, String>(
                  color: protein,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  name: 'Protein',
                  dataSource: chartData1,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y2,
                  pointColorMapper: (ChartData data, _) => Color(0xffff5963)),
              StackedColumnSeries<ChartData, String>(
                  color: carbs,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  name: 'Carbohydrates',
                  dataSource: chartData1,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y3,
                  pointColorMapper: (ChartData data, _) => Color(0xff4b39ef)),
            ],
          ),
        ),
        Container(
            width: MediaQuery.sizeOf(context).width,
            height: 80,
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries>[
                  StackedBarSeries<AverageData, String>(
                      color: fats,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.inside,
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                        labelAlignment: ChartDataLabelAlignment.middle,
                        alignment: ChartAlignment.center,
                      ),
                      dataSource: barChart1,
                      name: 'Fats',
                      xValueMapper: (AverageData data, _) => data.x,
                      yValueMapper: (AverageData data, _) => data.y,
                      pointColorMapper: (AverageData data, _) =>
                          Color(0xff249689)),
                  StackedBarSeries<AverageData, String>(
                      color: protein,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.inside,
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                        labelAlignment: ChartDataLabelAlignment.middle,
                        alignment: ChartAlignment.center,
                      ),
                      dataSource: barChart1,
                      name: 'Protein',
                      xValueMapper: (AverageData data, _) => data.x,
                      yValueMapper: (AverageData data, _) => data.y2,
                      pointColorMapper: (AverageData data, _) =>
                          Color(0xffff5963)),
                  StackedBarSeries<AverageData, String>(
                    color: carbs,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.inside,
                      textStyle:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      labelAlignment: ChartDataLabelAlignment.middle,
                      alignment: ChartAlignment.center,
                    ),
                    dataSource: barChart1,
                    name: 'Carbohydrates',
                    xValueMapper: (AverageData data, _) => data.x,
                    yValueMapper: (AverageData data, _) => data.y3,
                    pointColorMapper: (AverageData data, _) =>
                        Color(0xff4b39ef),
                  )
                ]))
      ],
    );
  }

  Widget _buildStackedColumnChart2() {
    return Column(
      children: [
        Container(
          height: 220,
          width: MediaQuery.sizeOf(context).width,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            legend: Legend(isVisible: true),
            series: <CartesianSeries>[
              StackedColumnSeries<ChartData, String>(
                  color: fats,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  name: 'Fats',
                  dataSource: chartData2,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y1,
                  pointColorMapper: (ChartData data, _) => Color(0xff249689)),
              StackedColumnSeries<ChartData, String>(
                  color: protein,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  name: 'Protein',
                  dataSource: chartData2,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y2,
                  pointColorMapper: (ChartData data, _) => Color(0xffff5963)),
              StackedColumnSeries<ChartData, String>(
                  color: carbs,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  name: 'Carbohydrates',
                  dataSource: chartData2,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y3,
                  pointColorMapper: (ChartData data, _) => Color(0xff4b39ef)),
            ],
          ),
        ),
        Container(
            width: MediaQuery.sizeOf(context).width,
            height: 80,
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries>[
                  StackedBarSeries<AverageData, String>(
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.inside,
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                        labelAlignment: ChartDataLabelAlignment.middle,
                        alignment: ChartAlignment.center,
                      ),
                      dataSource: barChart2,
                      name: 'Fats',
                      xValueMapper: (AverageData data, _) => data.x,
                      yValueMapper: (AverageData data, _) => data.y,
                      pointColorMapper: (AverageData data, _) =>
                          Color(0xff249689)),
                  StackedBarSeries<AverageData, String>(
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.inside,
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                        labelAlignment: ChartDataLabelAlignment.middle,
                        alignment: ChartAlignment.center,
                      ),
                      dataSource: barChart2,
                      name: 'Protein',
                      xValueMapper: (AverageData data, _) => data.x,
                      yValueMapper: (AverageData data, _) => data.y2,
                      pointColorMapper: (AverageData data, _) =>
                          Color(0xffff5963)),
                  StackedBarSeries<AverageData, String>(
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.inside,
                      textStyle:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      labelAlignment: ChartDataLabelAlignment.middle,
                      alignment: ChartAlignment.center,
                    ),
                    dataSource: barChart2,
                    name: 'Carbohydrates',
                    xValueMapper: (AverageData data, _) => data.x,
                    yValueMapper: (AverageData data, _) => data.y3,
                    pointColorMapper: (AverageData data, _) =>
                        Color(0xff4b39ef),
                  )
                ]))
      ],
    );
  }
}

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
