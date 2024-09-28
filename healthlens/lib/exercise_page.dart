import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlens/exerciseData.dart';
import 'package:healthlens/main.dart';
import 'backend_firebase/exerciseSaving.dart';

class ExercisePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final ExerciseService exerciseService = ExerciseService();
  final String userId = thisUser!.uid;

  // Loading state
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise', style: GoogleFonts.readexPro(fontSize: 18)),
        backgroundColor: Color(0xff4b39ef),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // List of exercises
          ListView.builder(
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
                          Text(
                            'Instructions: ${exercise['instructions']}',
                            style: GoogleFonts.readexPro(fontSize: 14),
                          ),
                          SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Calories Burned:',
                                style: GoogleFonts.readexPro(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${exercise['calories']} cal',
                                style: GoogleFonts.readexPro(
                                    fontSize: 14,
                                    color: Color(0xFF940A00),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                          // Start Exercise Button
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true; // Set loading to true
                                });

                                try {
                                  await exerciseService.saveExerciseActivity(
                                      userId, exercise);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        elevation: 3,
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: Colors.green,
                                        content:
                                            Text('Exercise activity saved!')),
                                  );
                                  Navigator.pop(context, true);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        elevation: 3,
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: Colors.red,
                                        content:
                                            Text('Failed to save activity.')),
                                  );
                                } finally {
                                  setState(() {
                                    isLoading =
                                        false; // Set loading to false after operation
                                  });
                                }
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

          // Loading Indicator (shown when isLoading is true)
          if (isLoading)
            Material(
              color: Color.fromARGB(92, 37, 37, 37),
              child: Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
