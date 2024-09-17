import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/exerciseData.dart';

class ExercisePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  // Example list of exercises

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise', style: GoogleFonts.readexPro(fontSize: 18)),
        backgroundColor: Color(0xff4b39ef),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return Card(
            color: Colors.white,
            elevation: 3,
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exercise Image
                Image.asset(exercise['image'],
                    height: 150, width: double.infinity, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Exercise Name
                      Text(exercise['name'],
                          style: GoogleFonts.readexPro(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),

                      // Exercise Instructions
                      Text('Instructions: ${exercise['instructions']}',
                          style: GoogleFonts.readexPro(fontSize: 14)),
                      SizedBox(height: 5),

                      // Calories Burned
                      Text('Calories Burned: ${exercise['calories']} cal',
                          style: GoogleFonts.readexPro(fontSize: 14)),
                      SizedBox(height: 10),

                      // Macronutrients Burned
                      Text('Macronutrients Burned:',
                          style: GoogleFonts.readexPro(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                              'Carbs: ${exercise['macronutrients']['carbs']} g',
                              style: GoogleFonts.readexPro(fontSize: 14)),
                          Text('Fats: ${exercise['macronutrients']['fats']} g',
                              style: GoogleFonts.readexPro(fontSize: 14)),
                          Text(
                              'Proteins: ${exercise['macronutrients']['proteins']} g',
                              style: GoogleFonts.readexPro(fontSize: 14)),
                        ],
                      ),
                      SizedBox(height: 10),

                      // Start Exercise Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle exercise start logic here
                          },
                          child: Text('Start ${exercise['name']}',
                              style: GoogleFonts.readexPro()),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff4b39ef),
                              foregroundColor: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
