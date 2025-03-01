import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:study_park/ads/ad_banner.dart';
import 'package:study_park/ads/interstitial_ad_helper.dart';
import 'package:study_park/screens/pdf_viewer.dart';

class UnitPage extends StatelessWidget {
  final String courseId;
  final String semesterId;
  final String subjectId;
  final InterstitialAdHelper adHelper = InterstitialAdHelper();

  UnitPage({
    super.key,
    required this.courseId,
    required this.semesterId,
    required this.subjectId,
  }) {
    adHelper.loadAd(); // Load Interstitial Ad
  }

  // Function to get YouTube thumbnail URL
  String getYouTubeThumbnail(String url) {
    final Uri uri = Uri.parse(url);
    if (uri.host.contains('youtube.com') || uri.host.contains('youtu.be')) {
      String? videoId;
      if (uri.host.contains('youtu.be')) {
        videoId = uri.pathSegments.first;
      } else {
        videoId = uri.queryParameters['v'];
      }
      return 'https://img.youtube.com/vi/$videoId/0.jpg';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Units", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 📚 Fetch & Display List of Units with PDFs
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('courses')
                        .doc(courseId)
                        .collection('semesters')
                        .doc(semesterId)
                        .collection('subjects')
                        .doc(subjectId)
                        .collection('units')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      var units = snapshot.data!.docs;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: units.length,
                        itemBuilder: (context, index) {
                          var unit = units[index];
                          var unitData = unit.data() as Map<String, dynamic>?;
                          var unitName = unitData?['name'] ?? 'Unknown Unit';
                          var pdfUrl = unitData?['pdfUrl'];

                          return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              title: Text(
                                unitName,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              leading: const FaIcon(FontAwesomeIcons.book,
                                  color: Colors.blueAccent),
                              trailing: pdfUrl != null
                                  ? const FaIcon(FontAwesomeIcons.filePdf,
                                      color: Colors.red)
                                  : const Icon(Icons.error,
                                      color: Colors.orange),
                              onTap: () {
                                if (pdfUrl != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PdfViewerScreen(
                                        courseId: courseId,
                                        semesterId: semesterId,
                                        subjectId: subjectId,
                                        unitNumber: unitName,
                                        pdfUrl: pdfUrl,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "No PDF available for this unit."),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 20, thickness: 2),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Related Topic Videos",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        FaIcon(FontAwesomeIcons.youtube, color: Colors.red),
                      ],
                    ),
                  ),

                  // Fetch & Display Videos in Grid Layout
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('courses')
                        .doc(courseId)
                        .collection('semesters')
                        .doc(semesterId)
                        .collection('subjects')
                        .doc(subjectId)
                        .collection('videos')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      var videos = snapshot.data!.docs;

                      return videos.isNotEmpty
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: screenWidth > 600 ? 3 : 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                mainAxisExtent: 180,
                              ),
                              itemCount: videos.length,
                              itemBuilder: (context, index) {
                                var videoDoc = videos[index];
                                String videoUrl = videoDoc['videos'];
                                String thumbnailUrl =
                                    getYouTubeThumbnail(videoUrl);

                                return GestureDetector(
                                  onTap: () =>
                                      adHelper.showAdAndOpenLink(videoUrl),
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(15)),
                                          child: Image.network(
                                            thumbnailUrl,
                                            width: double.infinity,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          "Watch Video",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(child: Text("No videos available"));
                    },
                  ),
                ],
              ),
            ),
          ),
          AdBanner(),
        ],
      ),
    );
  }
}
