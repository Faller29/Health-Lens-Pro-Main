import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/food_data_history.dart';
import 'package:healthlens/graph_data.dart';
import 'package:iconly/iconly.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  final List<Item> _data = generateItems(1);

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
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 14.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Food History",
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
              StackedLineSeries<ChartData, String>(
                  color: fats,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    margin: EdgeInsets.all(3),
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                    useSeriesColor: true,
                  ),
                  name: 'Fats',
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y1,
                  pointColorMapper: (ChartData data, _) => Color(0xff249689)),
              StackedLineSeries<ChartData, String>(
                  color: protein,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    margin: EdgeInsets.all(3),
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                    useSeriesColor: true,
                  ),
                  name: 'Protein',
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y2,
                  pointColorMapper: (ChartData data, _) => Color(0xffff5963)),
              StackedLineSeries<ChartData, String>(
                  color: carbs,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    margin: EdgeInsets.all(3),
                    labelPosition: ChartDataLabelPosition.inside,
                    useSeriesColor: true,
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
                    isVisible: false,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  groupName: 'Fats',
                  name: 'Fats',
                  dataSource: chartData1,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y1,
                  pointColorMapper: (ChartData data, _) => Color(0xff249689)),
              StackedColumnSeries<ChartData, String>(
                  color: protein,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: false,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  groupName: 'Protein',
                  name: 'Protein',
                  dataSource: chartData1,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y2,
                  pointColorMapper: (ChartData data, _) => Color(0xffff5963)),
              StackedColumnSeries<ChartData, String>(
                  color: carbs,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: false,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  groupName: 'Carbohydrates',
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
