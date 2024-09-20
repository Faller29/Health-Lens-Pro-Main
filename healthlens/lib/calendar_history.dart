import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/food_data_history.dart';
import 'package:healthlens/history_page.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'graph_data.dart';

void main() {
  runApp(CalendarHistory());
}

class CalendarHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  Color protein = Color(0xffff5963);
  Color fats = Color(0xff249689);
  Color carbs = Color(0xff4b39ef);
  final List<Item> _data = generateItems(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'History',
            style: GoogleFonts.outfit(
              fontSize: 25.0,
            ),
          ),
          foregroundColor: Colors.white,
          backgroundColor: Color(0xff4b39ef)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.all(2),
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
              height: 270,
              child: SfCalendar(
                view: CalendarView.month,
                headerHeight: 35,
                showNavigationArrow: true,
                todayHighlightColor: Color(0xff4b39ef),
                todayTextStyle: TextStyle(fontWeight: FontWeight.bold),
                showDatePickerButton: true,
                monthViewSettings: MonthViewSettings(
                  monthCellStyle: MonthCellStyle(
                    todayBackgroundColor: Color(0xff4b39ef),
                  ),
                  showTrailingAndLeadingDates: false,
                ),
                headerStyle: CalendarHeaderStyle(
                  textAlign: TextAlign.center,
                  textStyle: GoogleFonts.outfit(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                viewHeaderStyle: ViewHeaderStyle(
                  dayTextStyle: GoogleFonts.readexPro(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: Color.fromARGB(255, 236, 236, 236),
                ),
                initialSelectedDate: DateTime.now(),
                onTap: (CalendarTapDetails details) {
                  if (details.targetElement == CalendarElement.calendarCell &&
                      details.date != null) {
                    String formattedDate =
                        DateFormat('yy-MM-dd').format(details.date!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HistoryPage(formattedDate: formattedDate),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14),
            child: Container(
              padding: EdgeInsets.all(14),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 30),
                    child: Text(
                      'May 30, 2024',
                      style: GoogleFonts.readexPro(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            child: Column(
                          mainAxisSize: MainAxisSize.max,
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
                                  percent: 0.7,
                                  center: new Text(
                                    "70.0%",
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  header: const Padding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            10.0), // Adjust bottom padding as needed
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: const Color(0xff4b39ef),
                                ),
                              ],
                            ),
                            Text(
                              "89/110g",
                              style: GoogleFonts.readexPro(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                textStyle: const TextStyle(
                                  color: Color(0xff4b39ef),
                                ),
                              ),
                            ),
                          ],
                        )),
                        Container(
                          child: Column(
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
                                percent: 0.5,
                                center: new Text(
                                  "50.0%",
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
                                "50/100g",
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
                        ),
                        Container(
                          child: Column(
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
                                percent: 0.3,
                                center: new Text(
                                  "30.0%",
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
                                "30/100g",
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
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 50, 8, 10),
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            'Analytics',
                            style: GoogleFonts.outfit(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          _buildStackedColumnChart(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 14, 8, 10),
                    child: Container(
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
                                    "Activity",
                                    style: GoogleFonts.readexPro(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ExpansionPanelList(
                                  expansionCallback:
                                      (int index, bool isExpanded) {
                                    setState(() {
                                      _data[index].isExpanded = isExpanded;
                                    });
                                  },
                                  children:
                                      _data.map<ExpansionPanel>((Item item) {
                                    return ExpansionPanel(
                                      headerBuilder: (BuildContext context,
                                          bool isExpanded) {
                                        return ListTile(
                                          title: Text(
                                            item.headerValue,
                                            style: GoogleFonts.readexPro(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              textStyle: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
            ),
          )
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
}
