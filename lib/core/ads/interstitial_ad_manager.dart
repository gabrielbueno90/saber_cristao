import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:saber_cristao/core/ads/ad_unit_ids.dart';

class InterstitialAdManager {
  InterstitialAd? _loadedAd;

  Future<void> preload() async {
    await InterstitialAd.load(
      adUnitId: AdUnitIds.interstitialTest,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _loadedAd = ad,
        onAdFailedToLoad: (_) => _loadedAd = null,
      ),
    );
  }

  Future<bool> show() async {
    final ad = _loadedAd;
    if (ad == null) return false;
    _loadedAd = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
      },
    );
    await ad.show();
    return true;
  }
}
