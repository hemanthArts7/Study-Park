import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Lottie.asset(
              'assets/animations/splashscreen.json',
              controller: _controller,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..forward();
                Future.delayed(composition.duration, _navigateToHome);
              },
            ),
          ),
          Positioned(
              bottom: 100,
              child: Lottie.asset('assets/animations/loading.json', width: 90)),
          Positioned(
            bottom: 50,
            child: Text(
              "Study Park",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
