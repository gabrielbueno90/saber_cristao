import 'package:flutter/widgets.dart';
import 'package:saber_cristao/core/monetization/ad_placement.dart';
import 'package:saber_cristao/core/monetization/reward_type.dart';

abstract class AdService {
  Future<void> initialize();
  bool get isAvailable;
  String get modeLabel;
  Widget buildBanner({
    required AdPlacement placement,
    required bool enabled,
  });
  Future<bool> showInterstitialIfAllowed(AdPlacement placement);
  Future<bool> showRewardedAd(RewardType rewardType);
}
