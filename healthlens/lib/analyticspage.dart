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
  Color protein = const Color(0xffff5963);
  Color fats = const Color(0xff249689);
  Color carbs = const Color(0xff4b39ef);
  final List<Item> _data = generateItems(1);
  bool _isDataLoaded = false; // For managing loading state

  @override
  void initState() {
    super.initState();
    _fetchAndLoadData();
  }

  Future<void> _fetchAndLoadData() async {
    // Assuming `thisUser` is your global user object containing the userId
    await fetchMacrosData();
    setState(() {
      _isDataLoaded = true; // Mark the data as loaded
    });
  }

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
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    boxShadow: [
                      const BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                      )
                    ],
                    borderRadius: BorderRadius.circular(8.0),
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 14, 0, 8),
                        child: Text(
                          'Macronutrients',
                          style: GoogleFonts.outfit(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_left,
                                  size: 35,
                                ),
                                onPressed: () {
                                  if (_selectedDayIndex > 0) {
                                    _selectedDayIndex--;
                                    _pageController.previousPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(
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
                                icon: const Icon(
                                  Icons.arrow_right,
                                  size: 35,
                                ),
                                onPressed: () {
                                  if (_selectedDayIndex < 2) {
                                    _selectedDayIndex++;
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
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
                        padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                        child: SizedBox(
                          height: 400,
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
                                  textStyle: const TextStyle(
                                    color: Color(0xff4b39ef),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/calendar');
                              },
                              icon: const Icon(
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
                padding: const EdgeInsets.all(14),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    boxShadow: [
                      const BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
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
                              padding: const EdgeInsets.all(10),
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
        SizedBox(
          height: 320,
          width: MediaQuery.sizeOf(context).width,
          child: SfCartesianChart(
            enableAxisAnimation: true,
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              zoomMode: ZoomMode.x,
              enablePanning: true,
            ),
            primaryXAxis: const CategoryAxis(
              minimum: 0,
            ),
            primaryYAxis: const CategoryAxis(
              rangePadding: ChartRangePadding.none,
              minimum: 0,
            ),
            legend: const Legend(
              isVisible: true,
            ),
            series: <CartesianSeries>[
              StackedLineSeries<ChartData, String>(
                  color: fats,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    margin: EdgeInsets.all(3),
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                    useSeriesColor: true,
                  ),
                  groupName: 'Fats',
                  name: 'Fats',
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y1,
                  pointColorMapper: (ChartData data, _) =>
                      const Color(0xff249689)),
              StackedLineSeries<ChartData, String>(
                  color: protein,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    margin: EdgeInsets.all(3),
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                    useSeriesColor: true,
                  ),
                  groupName: 'Protein',
                  name: 'Protein',
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y2,
                  pointColorMapper: (ChartData data, _) =>
                      const Color(0xffff5963)),
              StackedLineSeries<ChartData, String>(
                  color: carbs,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    margin: EdgeInsets.all(3),
                    labelPosition: ChartDataLabelPosition.inside,
                    useSeriesColor: true,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  groupName: 'Carbohydrates',
                  name: 'Carbohydrates',
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y3,
                  pointColorMapper: (ChartData data, _) =>
                      const Color(0xff4b39ef)),
            ],
          ),
        ),
        SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 80,
            child: SfCartesianChart(
                primaryXAxis: const CategoryAxis(
                  minimum: 0,
                ),
                series: <CartesianSeries>[
                  StackedBarSeries<AverageData, String>(
                      color: fats,
                      dataLabelSettings: const DataLabelSettings(
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
                          const Color(0xff249689)),
                  StackedBarSeries<AverageData, String>(
                      color: protein,
                      dataLabelSettings: const DataLabelSettings(
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
                          const Color(0xffff5963)),
                  StackedBarSeries<AverageData, String>(
                    color: carbs,
                    dataLabelSettings: const DataLabelSettings(
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
                        const Color(0xff4b39ef),
                  )
                ]))
      ],
    );
  }

  Widget _buildStackedColumnChart1() {
    return Column(
      children: [
        SizedBox(
          height: 320,
          width: MediaQuery.sizeOf(context).width,
          child: SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              zoomMode: ZoomMode.x,
              enablePanning: true,
            ),
            primaryXAxis: const CategoryAxis(),
            primaryYAxis: const CategoryAxis(
              rangePadding: ChartRangePadding.none,
              minimum: 0,
            ),
            legend: const Legend(isVisible: true),
            series: <CartesianSeries>[
              StackedColumnSeries<ChartData, String>(
                color: fats,
                dataLabelSettings: const DataLabelSettings(
                  showZeroValue: true,
                  showCumulativeValues: true,
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.inside,
                  textStyle:
                      TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  labelAlignment: ChartDataLabelAlignment.top,
                  alignment: ChartAlignment.center,
                ),
                name: 'Fats',
                dataSource: chartData1,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y1,
                pointColorMapper: (ChartData data, _) =>
                    const Color(0xff249689),
              ),
              StackedColumnSeries<ChartData, String>(
                  color: protein,
                  dataLabelSettings: const DataLabelSettings(
                    showZeroValue: true,
                    showCumulativeValues: true,
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
                  pointColorMapper: (ChartData data, _) =>
                      const Color(0xffff5963)),
              StackedColumnSeries<ChartData, String>(
                  color: carbs,
                  dataLabelSettings: const DataLabelSettings(
                    showZeroValue: true,
                    showCumulativeValues: true,
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
                  pointColorMapper: (ChartData data, _) =>
                      const Color(0xff4b39ef)),
            ],
          ),
        ),
        SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 80,
            child: SfCartesianChart(
                primaryXAxis: const CategoryAxis(
                  minimum: 0,
                ),
                series: <CartesianSeries>[
                  StackedBarSeries<AverageData, String>(
                      color: fats,
                      dataLabelSettings: const DataLabelSettings(
                        showZeroValue: true,
                        showCumulativeValues: true,
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
                          const Color(0xff249689)),
                  StackedBarSeries<AverageData, String>(
                      color: protein,
                      dataLabelSettings: const DataLabelSettings(
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
                          const Color(0xffff5963)),
                  StackedBarSeries<AverageData, String>(
                    color: carbs,
                    dataLabelSettings: const DataLabelSettings(
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
                        const Color(0xff4b39ef),
                  )
                ]))
      ],
    );
  }

  Widget _buildStackedColumnChart2() {
    return Column(
      children: [
        SizedBox(
          height: 320,
          width: MediaQuery.sizeOf(context).width,
          child: SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            primaryYAxis: const CategoryAxis(
              rangePadding: ChartRangePadding.none,
            ),
            legend: const Legend(isVisible: true),
            series: <CartesianSeries>[
              StackedColumnSeries<ChartData, String>(
                  color: fats,
                  dataLabelSettings: const DataLabelSettings(
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
                  pointColorMapper: (ChartData data, _) =>
                      const Color(0xff249689)),
              StackedColumnSeries<ChartData, String>(
                  color: protein,
                  dataLabelSettings: const DataLabelSettings(
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
                  pointColorMapper: (ChartData data, _) =>
                      const Color(0xffff5963)),
              StackedColumnSeries<ChartData, String>(
                  color: carbs,
                  dataLabelSettings: const DataLabelSettings(
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
                  pointColorMapper: (ChartData data, _) =>
                      const Color(0xff4b39ef)),
            ],
          ),
        ),
        SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 80,
            child: SfCartesianChart(
                primaryXAxis: const CategoryAxis(
                  minimum: 0,
                ),
                series: <CartesianSeries>[
                  StackedBarSeries<AverageData, String>(
                      dataLabelSettings: const DataLabelSettings(
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
                          const Color(0xff249689)),
                  StackedBarSeries<AverageData, String>(
                      dataLabelSettings: const DataLabelSettings(
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
                          const Color(0xffff5963)),
                  StackedBarSeries<AverageData, String>(
                    dataLabelSettings: const DataLabelSettings(
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
                        const Color(0xff4b39ef),
                  )
                ]))
      ],
    );
  }
}
