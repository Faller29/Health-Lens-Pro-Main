import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healthlens/models/category_model.dart';
import 'package:healthlens/widgets/hero_carousel_card.dart';
import 'package:iconly/iconly.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';

const double contWidth = 100;
const double contHeight = 140;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: SafeArea(
        child: ListView(
          addAutomaticKeepAlives: true,
          children: [
            Container(
              child: Material(
                elevation: 4,
                shadowColor: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Macronutrients",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // First division or column
                        SizedBox(
                          width: contWidth,
                          height: contHeight,
                          child: GestureDetector(
                            onTap: () {
                              // Show modal on tap
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 150,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                          "What is Carbohydrates, Effect and etc."),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              child: Material(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularPercentIndicator(
                                      radius: 40.0,
                                      lineWidth: 13.0,
                                      animation: true,
                                      percent: 0.3,
                                      center: new Text(
                                        "30.0%",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      header: Padding(
                                        padding: EdgeInsets.only(
                                            bottom:
                                                10.0), // Adjust bottom padding as needed
                                        child: new Text(
                                          "Carbohydrates",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: Colors.amberAccent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Second division or column
                        SizedBox(
                          width: contWidth,
                          height: contHeight,
                          child: GestureDetector(
                            onTap: () {
                              // Show modal on tap
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 150,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                          "What is Protein, effects and etc"),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              child: Material(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularPercentIndicator(
                                      radius: 40.0,
                                      lineWidth: 13.0,
                                      animation: true,
                                      percent: 0.5,
                                      center: new Text(
                                        "50.0%",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      header: Padding(
                                        padding: EdgeInsets.only(
                                            bottom:
                                                10.0), // Adjust bottom padding as needed
                                        child: new Text(
                                          "Protein",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: Colors.redAccent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Third division or column
                        SizedBox(
                          width: contWidth,
                          height: contHeight,
                          child: GestureDetector(
                            onTap: () {
                              // Show modal on tap
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 150,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                          "What is Carbohydrates, Effect and etc."),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              child: Material(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularPercentIndicator(
                                      radius: 40.0,
                                      lineWidth: 13.0,
                                      animation: true,
                                      percent: 0.7,
                                      center: new Text(
                                        "70.0%",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      header: Padding(
                                        padding: EdgeInsets.only(
                                            bottom:
                                                10.0), // Adjust bottom padding as needed
                                        child: new Text(
                                          "Fats",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: Colors.purple,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              height: 110,
              child: GestureDetector(
                onTap: () {
                  // Show modal on tap
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 150,
                        color: Colors.white,
                        child: Center(
                          child: Text("All  Suggested Food"),
                        ),
                      );
                    },
                  );
                },
                child: Material(
                  //elevation: 4,
                  //shadowColor: Colors.grey.withOpacity(0.5),
                  //borderRadius: BorderRadius.circular(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          child: CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 4.5,
                          viewportFraction: 0.8,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          initialPage: 2,
                          autoPlay: true,
                        ),
                        items: Category.categories
                            .map((category) =>
                                HeroCarouselCard(category: category))
                            .toList(),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
