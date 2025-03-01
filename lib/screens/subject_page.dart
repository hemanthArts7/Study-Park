import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_park/ads/ad_banner.dart';
import 'unit_page.dart';

class SubjectPage extends StatelessWidget {
  final String courseId;
  final String semesterId;

  const SubjectPage(
      {super.key, required this.courseId, required this.semesterId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Subjects",
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
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .doc(courseId)
                    .collection('semesters')
                    .doc(semesterId)
                    .collection('subjects')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var subjects = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      var subject = subjects[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UnitPage(
                                courseId: courseId,
                                semesterId: semesterId,
                                subjectId: subject.id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey, // Book cover color
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(3),
                              bottomRight: Radius.circular(3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(4, 4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 5,
                                top: 10,
                                bottom: 10,
                                child: Container(
                                  width: 15,
                                  decoration: BoxDecoration(
                                    color: Colors.white54,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Text(
                                    subject['name'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          AdBanner(), // Ad displayed at the bottom
        ],
      ),
    );
  }
}
