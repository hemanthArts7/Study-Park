import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class InterstitialAdHelper {
  InterstitialAd? _interstitialAd;

  // Load Interstitial Ad
  void loadAd() {
    InterstitialAd.load(
      adUnitId: *****************************
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

  // Show Interstitial Ad before opening YouTube
  void showAdAndOpenLink(String url) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _launchURL(url);
          loadAd(); // Load next test ad
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _launchURL(url);
        },
      );
      _interstitialAd!.show();
    } else {
      _launchURL(url);
    }
  }

  // Open YouTube Link
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }
}
