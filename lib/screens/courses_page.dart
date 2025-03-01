import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'semester_page.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildCoursesGrid(context);
  }
}

Widget _buildCoursesGrid(BuildContext context) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('courses').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }

      var courses = snapshot.data!.docs;

      return GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          var course = courses[index];
          return GestureDetector(
            onTap: () {
              FocusScope.of(context)
                  .unfocus(); // Hide keyboard before navigation
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SemesterPage(courseId: course.id),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(_getCourseIcon(course['name']),
                        size: 35, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      course['name'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

IconData _getCourseIcon(String courseName) {
  switch (courseName.toLowerCase()) {
    case "cse": // Computer Science
      return FontAwesomeIcons.laptopCode;
    case "csd": // Computer Science & Data Structures
      return FontAwesomeIcons.database;
    case "csm": // Computer Science & Machine Learning
      return FontAwesomeIcons.robot;
    case "civil": // Civil Engineering
      return FontAwesomeIcons.bridge;
    case "ece": // Electronics & Communication
      return FontAwesomeIcons.satelliteDish;
    case "eee": // Electrical & Electronics
      return FontAwesomeIcons.bolt;
    case "mech": // Mechanical Engineering
      return FontAwesomeIcons.cogs;
    default: // Default case if course name is unknown
      return FontAwesomeIcons.graduationCap;
  }
}
