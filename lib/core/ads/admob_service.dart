import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:saber_cristao/core/ads/ad_frequency_controller.dart';
import 'package:saber_cristao/core/ads/ad_service.dart';
import 'package:saber_cristao/core/ads/adaptive_banner_ad_widget.dart';
import 'package:saber_cristao/core/ads/interstitial_ad_manager.dart';
import 'package:saber_cristao/core/ads/rewarded_ad_manager.dart';
import 'package:saber_cristao/core/monetization/ad_placement.dart';
import 'package:saber_cristao/core/monetization/reward_type.dart';

class AdMobService implements AdService {
  AdMobService(this._frequencyController);

  final AdFrequencyController _frequencyController;
  final InterstitialAdManager _interstitialManager = InterstitialAdManager();
  final RewardedAdManager _rewardedManager = RewardedAdManager();
  bool _initialized = false;

  @override
  bool get isAvailable => !kIsWeb;

  @override
  String get modeLabel => kIsWeb ? 'Ads off (web)' : 'AdMob teste';

  @override
  Future<void> initialize() async {
    if (_initialized || kIsWeb) return;
    await MobileAds.instance.initialize();
    await _interstitialManager.preload();
    await _rewardedManager.preload();
    _initialized = true;
  }

  @override
  Widget buildBanner({
    required AdPlacement placement,
    required bool enabled,
  }) {
    return AdaptiveBannerAdWidget(
      enabled: enabled,
      showLabel: placement == AdPlacement.home,
    );
  }

  @override
  Future<bool> showInterstitialIfAllowed(AdPlacement placement) async {
    if (kIsWeb || !_initialized) return false;
    final shouldShow = await _frequencyController.shouldShowInterstitial();
    if (!shouldShow) return false;
    final shown = await _interstitialManager.show();
    await _interstitialManager.preload();
    return shown;
  }

  @override
  Future<bool> showRewardedAd(RewardType rewardType) async {
    if (kIsWeb || !_initialized) return false;
    final rewarded = await _rewardedManager.show();
    await _rewardedManager.preload();
    return rewarded;
  }
}
