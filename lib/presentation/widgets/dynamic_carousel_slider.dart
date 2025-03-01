import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class DynamicCarouselSlider extends StatefulWidget {
  @override
  _DynamicCarouselSliderState createState() => _DynamicCarouselSliderState();
}

class _DynamicCarouselSliderState extends State<DynamicCarouselSlider> {
  List<Map<String, dynamic>> carouselItems = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchCarouselItems();
  }

  void _fetchCarouselItems() {
    FirebaseFirestore.instance
        .collection('carousel_images')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          carouselItems = snapshot.docs.map((doc) {
            return {
              'image_url': doc['image_url'] as String,
              'link': doc.data().containsKey('links')
                  ? doc['links'] as String?
                  : null,
            };
          }).toList();
        });
      }
    });
  }

  void _openFullScreenImage(String imageUrl, String? link) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(imageUrl: imageUrl, link: link),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (carouselItems.isEmpty) {
      return const Center(
        child: Text(
          "No images available",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 250,
            autoPlay: true,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            viewportFraction: 0.85,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 600),
            autoPlayCurve: Curves.easeInOutCubic,
            scrollPhysics: BouncingScrollPhysics(),
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: carouselItems.map((item) {
            return GestureDetector(
              onTap: () =>
                  _openFullScreenImage(item['image_url'], item['link']),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: double.infinity,
                  height: 220,
                  color: Colors.grey[300],
                  child: Image.network(
                    item['image_url'],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.error),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 10),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: carouselItems.length,
          effect: SwapEffect(
            type: SwapType.yRotation,
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.blueAccent,
            dotColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final String? link;

  const FullScreenImage({Key? key, required this.imageUrl, this.link})
      : super(key: key);

  Future<void> _launchURL(BuildContext context) async {
    if (link != null && await canLaunch(link!)) {
      await launch(link!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
            ),
          ),
          if (link != null && link!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () => _launchURL(context),
                child: Text("Open Link"),
              ),
            ),
        ],
      ),
    );
  }
}
