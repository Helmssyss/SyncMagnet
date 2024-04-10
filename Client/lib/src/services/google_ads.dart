import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleADS {
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;
  bool isLoaded = false;

  void loadBannerAd({required VoidCallback adLoaded}) {
    bannerAd = BannerAd(
      adUnitId: ' TEST ID ',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('$ad loaded.');
          bannerAd = ad as BannerAd;
          isLoaded = true;
          adLoaded();
        },
        onAdFailedToLoad: (ad, err) {
          // debugPrint('BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  void interstitialAdLoad() {
    InterstitialAd.load(
      adUnitId: " TEST ID ",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          // debugPrint('$ad loaded.');
          interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          // debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }
}
