import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:study_park/routers/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Force Firestore to fetch fresh data
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: false);
  FirebaseFirestore.instance.enableNetwork();

  // Debugging Firestore connection
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firestore
      .collection('courses')
      .get()
      .then((snapshot) {})
      .catchError((error) {});
  MobileAds.instance.initialize();
  runApp(const StudyParkApp());
}

class StudyParkApp extends StatelessWidget {
  const StudyParkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Park',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
