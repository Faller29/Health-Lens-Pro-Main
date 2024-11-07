import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/food_data_history.dart';
import 'package:healthlens/graph_data.dart';
import 'package:healthlens/history_page.dart';
import 'package:healthlens/main.dart';
import 'package:iconly/iconly.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _AnalyticsPageState extends State<AnalyticsPage> {
  int _selectedDayIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  Color protein = const Color(0xffff5963);
  Color fats = const Color(0xff249689);
  Color carbs = const Color(0xff4b39ef);
  final List<Item> _data = generateItems(1);
  bool _isDataLoaded = false; // For managing loading state
  String _todayDate = '';

  String _getTodayDate() {
    DateTime now = DateTime.now();
    return DateFormat('EEEE, MMMM d, y')
        .format(now); // Formats to "Monday, October 24, 2024"
  }

  @override
  void initState() {
    super.initState();
    _fetchAndLoadData();
    _todayDate = _getTodayDate();
  }

  Future<void> _fetchAndLoadData() async {
    // Assuming `thisUser` is your global user object containing the userId
    await fetchMacrosData();
    setState(() {
      _isDataLoaded = true; // Mark the data as loaded
    });
    /*  _analyticsTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      if (mounted) {
        await fetchMacrosData();
        setState(() {
          _isDataLoaded = true; // Mark the data as loaded
        });
      }
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Overview',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              /* SizedBox(
                                height: 5,
                              ), */
                              Text(
                                "Analytics",
                                style: GoogleFonts.outfit(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 0.5,
                                ),
                              ),
                              SizedBox(height: 15),
                              SizedBox(
                                height: 25,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: EdgeInsets.fromLTRB(5, 1, 5, 1)),
                                  child: Row(
                                    children: [
                                      Icon(
                                        IconlyBroken.calendar,
                                        color: Color(0xff4b39ef),
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Check History',
                                        style: GoogleFonts.readexPro(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          textStyle: const TextStyle(
                                            color: Color(0xff4b39ef),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return Card(
                                              color: Colors.white,
                                              elevation: 0,
                                              margin: const EdgeInsets.fromLTRB(
                                                  10, 200, 10, 200),
                                              child: SfCalendar(
                                                view: CalendarView.month,
                                                showTodayButton: true,
                                                headerHeight: 50,
                                                showNavigationArrow: true,
                                                viewNavigationMode:
                                                    ViewNavigationMode.snap,
                                                todayHighlightColor:
                                                    Color(0xff4b39ef),
                                                todayTextStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                showDatePickerButton: true,
                                                monthViewSettings:
                                                    MonthViewSettings(
                                                  monthCellStyle:
                                                      MonthCellStyle(
                                                    todayBackgroundColor:
                                                        Color(0xff4b39ef),
                                                  ),
                                                  showTrailingAndLeadingDates:
                                                      false,
                                                ),
                                                headerStyle:
                                                    CalendarHeaderStyle(
                                                  textAlign: TextAlign.center,
                                                  textStyle: GoogleFonts.outfit(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                  backgroundColor:
                                                      Color(0xff4b39ef),
                                                ),
                                                viewHeaderStyle:
                                                    ViewHeaderStyle(
                                                  dayTextStyle:
                                                      GoogleFonts.readexPro(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 236, 236, 236),
                                                ),
                                                initialSelectedDate:
                                                    DateTime.now(),
                                                maxDate: DateTime.now(),
                                                onTap: (CalendarTapDetails
                                                    details) {
                                                  if (details.targetElement ==
                                                          CalendarElement
                                                              .calendarCell &&
                                                      details.date != null) {
                                                    String formattedDate =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(
                                                                details.date!);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            HistoryPage(
                                                                formattedDate:
                                                                    formattedDate),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
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
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
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
                  width: MediaQuery.of(context).size.width,
                  /* decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    boxShadow: [
                      const BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                      )
                    ],
                    borderRadius: BorderRadius.circular(8.0),
                    shape: BoxShape.rectangle,
                  ), */
                  child: Column(
                    children: [
                      Stack(
                        /* crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end, */
                        children: [
                          Center(
                            child: Padding(
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
                          ),
                          Positioned(
                            right: 5,
                            top: 5,
                            child: Tooltip(
                              child: Icon(
                                Icons.info,
                                size: 20,
                                color: Colors.black87,
                              ),
                              triggerMode: TooltipTriggerMode.tap,
                              message:
                                  "Swipe or pan left and right to explore more data, or pinch in and out to zoom in and out of the chart for a better view.\nYou can remove a Bar or Line by tapping the Legends icon on top of the graph",
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
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
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
                          height: MediaQuery.sizeOf(context).height / 1.35,
                          child: PageView(
                            physics: NeverScrollableScrollPhysics(),
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
                    ],
                  ),
                ),
              ),
              /* Padding(
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
              ) */
            ],
          ),
        ],
      ),
    );
  }

  /* Widget _buildStackedColumnChart() {
    return Column(
      children: [
        Container(
          height: 150,
          width: MediaQuery.sizeOf(context).width,
          child: SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              zoomMode: ZoomMode.x,
              enablePanning: true,
            ),
            primaryXAxis: CategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.hide,
            ),
            primaryYAxis: CategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.hide,
              rangePadding: ChartRangePadding.none,
            ),
            legend: Legend(
              isVisible: true,
            ),
            series: <CartesianSeries>[
              StackedLineSeries<ChartData, String>(
                  color: fats,
                  dataLabelSettings: DataLabelSettings(
                    labelIntersectAction: LabelIntersectAction.hide,
                    showZeroValue: true,
                    showCumulativeValues: true,
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
            ],
          ),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: 150,
          child: SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              zoomMode: ZoomMode.x,
              enablePanning: true,
            ),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: CategoryAxis(
              rangePadding: ChartRangePadding.none,
            ),
            legend: Legend(
              isVisible: true,
            ),
            series: <CartesianSeries>[
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
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: 150,
          child: SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              zoomMode: ZoomMode.x,
              enablePanning: true,
            ),
            primaryXAxis: CategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.hide,
            ),
            primaryYAxis: CategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.hide,
              rangePadding: ChartRangePadding.none,
            ),
            legend: Legend(
              isVisible: true,
            ),
            series: <CartesianSeries>[
              StackedLineSeries<ChartData, String>(
                  color: carbs,
                  dataLabelSettings: DataLabelSettings(
                    showZeroValue: true,
                    showCumulativeValues: true,
                    isVisible: true,
                    margin: EdgeInsets.all(3),
                    labelIntersectAction: LabelIntersectAction.hide,
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
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Macronutrients',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Fats',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff249689),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Proteins',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xffff5963),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Carbs',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff4b39ef),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Avg.',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${avrgFat.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff249689),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${avrgProteins.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xffff5963),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${avrgCarbs.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff4b39ef),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Goal',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${gramFats.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff249689),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${gramProtein.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xffff5963),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${gramCarbs.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff4b39ef),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  } */

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
              initialVisibleMaximum: 5,
              minimum: 0,
            ),
            primaryYAxis: const NumericAxis(
                rangePadding: ChartRangePadding.none,
                minimum: 0,
                anchorRangeToVisiblePoints: false),
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
                  textStyle: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 22, 104, 94)),
                  labelAlignment: ChartDataLabelAlignment.top,
                  alignment: ChartAlignment.center,
                  useSeriesColor: false,
                ),
                groupName: 'Fats',
                name: 'Fats',
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y1,
                pointColorMapper: (ChartData data, _) =>
                    const Color(0xff249689),
                markerSettings: MarkerSettings(isVisible: true),
              ),
              StackedLineSeries<ChartData, String>(
                color: protein,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  margin: EdgeInsets.all(3),
                  labelPosition: ChartDataLabelPosition.inside,
                  textStyle: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 136, 21, 28)),
                  labelAlignment: ChartDataLabelAlignment.top,
                  alignment: ChartAlignment.center,
                  useSeriesColor: false,
                ),
                groupName: 'Protein',
                name: 'Protein',
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y2,
                pointColorMapper: (ChartData data, _) =>
                    const Color(0xffff5963),
                markerSettings: MarkerSettings(isVisible: true),
              ),
              StackedLineSeries<ChartData, String>(
                color: carbs,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  margin: EdgeInsets.all(3),
                  labelPosition: ChartDataLabelPosition.inside,
                  textStyle: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 36, 26, 121)),
                  labelAlignment: ChartDataLabelAlignment.top,
                  alignment: ChartAlignment.center,
                  useSeriesColor: false,
                ),
                groupName: 'Carbohydrates',
                name: 'Carbohydrates',
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y3,
                pointColorMapper: (ChartData data, _) =>
                    const Color(0xff4b39ef),
                markerSettings: MarkerSettings(isVisible: true),
              ),
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
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  dataSource: barChart,
                  name: 'Fats',
                  xValueMapper: (AverageData data, _) => data.x,
                  yValueMapper: (AverageData data, _) => data.y.toInt(),
                  pointColorMapper: (AverageData data, _) =>
                      const Color(0xff249689)),
              StackedBarSeries<AverageData, String>(
                  color: protein,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  dataSource: barChart,
                  name: 'Protein',
                  xValueMapper: (AverageData data, _) => data.x,
                  yValueMapper: (AverageData data, _) => data.y2.toInt(),
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
                yValueMapper: (AverageData data, _) => data.y3.toInt(),
                pointColorMapper: (AverageData data, _) =>
                    const Color(0xff4b39ef),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Macronutrients',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Fats',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff249689),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Proteins',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xffff5963),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Carbs',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff4b39ef),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Avg.',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${dailyFats.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff249689),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${dailyProtein.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xffff5963),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${dailyCarbs.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff4b39ef),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Goal',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${gramFats.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff249689),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${gramProtein.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xffff5963),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${gramCarbs.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff4b39ef),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
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
            primaryXAxis: const CategoryAxis(
                labelIntersectAction: AxisLabelIntersectAction.multipleRows),
            primaryYAxis: const CategoryAxis(
              rangePadding: ChartRangePadding.none,
              minimum: 0,
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
                dataSource: chartData1,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y1,
                pointColorMapper: (ChartData data, _) =>
                    const Color(0xff249689),
              ),
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
                  dataSource: chartData1,
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
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  dataSource: barChart1,
                  name: 'Fats',
                  xValueMapper: (AverageData data, _) => data.x,
                  yValueMapper: (AverageData data, _) => data.y.toInt(),
                  pointColorMapper: (AverageData data, _) =>
                      const Color(0xff249689)),
              StackedBarSeries<AverageData, String>(
                  color: protein,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  dataSource: barChart1,
                  name: 'Protein',
                  xValueMapper: (AverageData data, _) => data.x,
                  yValueMapper: (AverageData data, _) => data.y2.toInt(),
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
                yValueMapper: (AverageData data, _) => data.y3.toInt(),
                pointColorMapper: (AverageData data, _) =>
                    const Color(0xff4b39ef),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Macronutrients',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Fats',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff249689),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Proteins',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xffff5963),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Carbs',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff4b39ef),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Avg.',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${avrg7Fat.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff249689),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${avrg7Proteins.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xffff5963),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${avrg7Carbs.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff4b39ef),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Goal',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${gramFats.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff249689),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${gramProtein.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xffff5963),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${gramCarbs.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff4b39ef),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
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
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              zoomMode: ZoomMode.x,
              enablePanning: true,
            ),
            primaryXAxis: const CategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.multipleRows,
              initialVisibleMaximum: 8,
            ),
            primaryYAxis: const NumericAxis(
              anchorRangeToVisiblePoints: true,
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
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.center,
                  ),
                  dataSource: barChart2,
                  name: 'Fats',
                  xValueMapper: (AverageData data, _) => data.x,
                  yValueMapper: (AverageData data, _) => data.y.toInt(),
                  pointColorMapper: (AverageData data, _) =>
                      const Color(0xff249689)),
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
                  name: 'Protein',
                  xValueMapper: (AverageData data, _) => data.x,
                  yValueMapper: (AverageData data, _) => data.y2.toInt(),
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
                yValueMapper: (AverageData data, _) => data.y3.toInt(),
                pointColorMapper: (AverageData data, _) =>
                    const Color(0xff4b39ef),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Macronutrients',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Fats',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff249689),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Proteins',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xffff5963),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Carbs',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff4b39ef),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Avg.',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${avrg30Fat.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff249689),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${avrg30Proteins.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xffff5963),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${avrg30Carbs.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff4b39ef),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Goal',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${gramFats.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff249689),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${gramProtein.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xffff5963),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${gramCarbs.toString()}g',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      textStyle: const TextStyle(
                        color: Color(0xff4b39ef),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
