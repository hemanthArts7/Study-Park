import 'package:flutter/material.dart';
import 'package:study_park/screens/home_page.dart';
import 'package:study_park/screens/splash_screen.dart';
import 'package:study_park/screens/semester_page.dart';
import 'package:study_park/screens/subject_page.dart';
import 'package:study_park/screens/unit_page.dart';
import 'package:study_park/screens/pdf_viewer.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/semester':
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
              builder: (_) => SemesterPage(courseId: args['courseId'] ?? ''));
        }
        return _errorRoute(settings.name);
      case '/subject':
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
              builder: (_) => SubjectPage(
                    courseId: args['courseId'] ?? '',
                    semesterId: args['semesterId'] ?? '',
                  ));
        }
        return _errorRoute(settings.name);
      case '/units':
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
              builder: (_) => UnitPage(
                    courseId: args['courseId'] ?? '',
                    semesterId: args['semesterId'] ?? '',
                    subjectId: args['subjectId'] ?? '',
                  ));
        }
        return _errorRoute(settings.name);
      case '/pdf':
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;

          String unitNumber = args['unitNumber'].toString();

          return MaterialPageRoute(
            builder: (_) => PdfViewerScreen(
              courseId: args['courseId'] ?? '',
              semesterId: args['semesterId'] ?? '',
              subjectId: args['subjectId'] ?? '',
              unitNumber: unitNumber,
              pdfUrl: args['pdfUrl'] ?? '',
            ),
          );
        }
        return _errorRoute(settings.name);

      default:
        return _errorRoute(settings.name);
    }
  }

  static MaterialPageRoute _errorRoute(String? routeName) {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              body: Center(
                child: Text('No route defined for $routeName'),
              ),
            ));
  }
}
