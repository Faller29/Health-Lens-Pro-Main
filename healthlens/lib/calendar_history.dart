import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
                  if (details.targetElement == CalendarElement.calendarCell) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text('Selected Date'),
                          content: Container(
                            height: 100,
                            width: 100,
                            color: Colors.white,
                            child: Center(
                              child: Text(details.date.toString()),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
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
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Selected Date',
                      style: GoogleFonts.readexPro(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(8.0),
                            shape: BoxShape.rectangle,
                          ),
                          child: Text(
                            'Protein',
                            style: GoogleFonts.outfit(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(8.0),
                            shape: BoxShape.rectangle,
                          ),
                          child: Text(
                            'Carbohydrates',
                            style: GoogleFonts.outfit(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(8.0),
                            shape: BoxShape.rectangle,
                          ),
                          child: Text(
                            'Fats',
                            style: GoogleFonts.outfit(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 14, 8, 10),
                    child: Container(
                      height: 200,
                      child: Column(
                        children: [
                          Text(
                            'Analytics',
                            style: GoogleFonts.outfit(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 14, 8, 10),
                    child: Container(
                      height: 200,
                      child: Column(
                        children: [
                          Text(
                            'Food History',
                            style: GoogleFonts.outfit(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
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
}
