import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfViewerScreen extends StatefulWidget {
  final String courseId;
  final String semesterId;
  final String subjectId;
  final String unitNumber;
  final String pdfUrl;

  const PdfViewerScreen({
    Key? key,
    required this.courseId,
    required this.semesterId,
    required this.subjectId,
    required this.unitNumber,
    required this.pdfUrl,
  }) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  //Load Interstitial Ad
  void _loadAd() {
    InterstitialAd.load(
      adUnitId: **************
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint("Interstitial Ad failed to load: $error");
          _interstitialAd = null;
        },
      ),
    );
  }

  //Show Interstitial Ad before downloading PDF
  void _showAdAndOpenBrowser() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _openInBrowser();
          _loadAd(); // Load next ad
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _openInBrowser();
        },
      );
      _interstitialAd!.show();
    } else {
      _openInBrowser();
    }
  }

  //Download PDF
  void _openInBrowser() async {
    Uri url = Uri.parse(widget.pdfUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not Download PDF")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.unitNumber),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed:
                _showAdAndOpenBrowser,
          ),
        ],
      ),
      body: SfPdfViewer.network(widget.pdfUrl),
    );
  }
}
