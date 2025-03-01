import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_park/ads/ad_banner.dart';

class SemesterPage extends StatelessWidget {
  final String courseId;

  const SemesterPage({required this.courseId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Semester",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .doc(courseId)
                    .collection('semesters')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No semesters available"));
                  }

                  var semesters = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: semesters.length,
                    itemBuilder: (context, index) {
                      var semester = semesters[index];
                      String semesterName =
                          semester.get('name') ?? 'Unknown Semester';

                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        shadowColor: Colors.orangeAccent,
                        margin: const EdgeInsets.symmetric(vertical: 9),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          title: Text(
                            semesterName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          trailing: const Icon(Icons.arrow_forward,
                              color: Colors.blueAccent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          tileColor: Colors.white,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/subject',
                              arguments: {
                                'courseId': courseId,
                                'semesterId': semester.id,
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          AdBanner(), // Show AdBanner at the bottom
        ],
      ),
    );
  }
}
