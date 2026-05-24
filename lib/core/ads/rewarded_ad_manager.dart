import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:saber_cristao/core/ads/ad_unit_ids.dart';

class RewardedAdManager {
  RewardedAd? _loadedAd;

  Future<void> preload() async {
    await RewardedAd.load(
      adUnitId: AdUnitIds.rewardedTest,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _loadedAd = ad,
        onAdFailedToLoad: (_) => _loadedAd = null,
      ),
    );
  }

  Future<bool> show() async {
    final ad = _loadedAd;
    if (ad == null) return false;
    _loadedAd = null;
    final completer = Completer<bool>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (!completer.isCompleted) completer.complete(false);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        if (!completer.isCompleted) completer.complete(false);
      },
    );
    await ad.show(
      onUserEarnedReward: (ad, reward) {
        if (!completer.isCompleted) completer.complete(true);
      },
    );
    return completer.future;
  }
}
