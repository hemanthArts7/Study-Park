import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({super.key});

  // Function to launch URLs
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Developer Info',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Default Profile Icon Instead of Image
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent,
                child: const FaIcon(
                  FontAwesomeIcons.user,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),

              // Name
              const Text(
                'Hemanth Etigowni',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),

              // About the App
              const Text(
                'Study Park is designed to help students easily access study materials like PDFs and related videos. '
                'It is a simple and well-structured app for better learning.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 20),

              // Social Links
              const Text(
                'Connect with me:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Social Media Buttons
              Wrap(
                spacing: 15,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.linkedin,
                        color: Colors.blue, size: 30),
                    onPressed: () => _launchURL(
                        'https://www.linkedin.com/in/hemanth-etigowni-1b6715251'),
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.github,
                        color: Colors.black, size: 30),
                    onPressed: () =>
                        _launchURL('https://github.com/hemanthArts7'),
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.instagram,
                        color: Colors.pink, size: 30),
                    onPressed: () =>
                        _launchURL('https://www.instagram.com/hemanth_arts7'),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Contact
              const Text(
                'For queries, email me at:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () => _launchURL('mailto:hemanthetigowni@gmail.com'),
                child: const Text(
                  'hemanthetigowni@gmail.com',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
