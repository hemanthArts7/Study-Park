import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:study_park/ads/ad_banner.dart';
import 'package:study_park/presentation/developer.dart';
import 'package:study_park/presentation/widgets/bottom_nav_bar.dart';
import 'package:study_park/presentation/widgets/dynamic_carousel_slider.dart';
import 'package:study_park/presentation/widgets/navbar/feedback_screen.dart';
import 'package:study_park/presentation/widgets/search_bar_widget.dart';
import 'package:study_park/screens/courses_page.dart';
import 'package:study_park/screens/subject_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePageContent(),
    FeedbackScreen(),
    DeveloperPage(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display selected page
      bottomNavigationBar: BottomNavBar(onTabSelected: _onTabSelected),
    );
  }
}

class HomePageContent extends StatelessWidget {
  void _onSubjectSelected(BuildContext context, String courseId,
      String semesterId, String subjectId) {
    FocusScope.of(context).unfocus(); // Hide keyboard before navigation
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SubjectPage(courseId: courseId, semesterId: semesterId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white54,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context)
                .unfocus(); // Hide keyboard when tapping anywhere
          },
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  child: Lottie.asset(
                      'assets/animations/birds.json'), // Lottie animation
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Study Park',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SearchBarWidget(
                          onSubjectSelected: (courseId, semesterId, subjectId) {
                        _onSubjectSelected(
                            context, courseId, semesterId, subjectId);
                      }),
                    ),
                    const SizedBox(height: 10),
                    DynamicCarouselSlider(), // Carousel slider
                    SizedBox(height: 10),
                    // **Wrap with a Container to change background color**
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey,
                            blurRadius: 15,
                            spreadRadius: 7,
                            offset: Offset(0, 5),
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      padding: EdgeInsets.only(top: 15, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              'Departments',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            height: 400, // Set a fixed height
                            child: CoursesPage(), // Display Courses Page
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: AdBanner(), // Display the banner ad at the bottom
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
