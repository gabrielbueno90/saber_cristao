import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class RewardsRepository {
  Future<void> grantAdRewardDevOnly({
    required String rewardType,
    required int rewardAmount,
  });
}

class DevRewardsRepository implements RewardsRepository {
  @override
  Future<void> grantAdRewardDevOnly({
    required String rewardType,
    required int rewardAmount,
  }) async {
    // SECURITY BEFORE PRODUCTION:
    // ad rewards must be granted only after backend or Edge Function validation
    // of a completed rewarded ad event before production.
  }
}

final rewardsRepositoryProvider = Provider<RewardsRepository>((ref) {
  return DevRewardsRepository();
});
