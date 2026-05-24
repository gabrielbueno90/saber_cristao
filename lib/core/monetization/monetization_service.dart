import 'package:saber_cristao/core/ads/ad_service.dart';
import 'package:saber_cristao/core/monetization/ad_placement.dart';
import 'package:saber_cristao/core/monetization/reward_type.dart';
import 'package:saber_cristao/core/purchases/purchase_product.dart';
import 'package:saber_cristao/core/purchases/purchase_result.dart';
import 'package:saber_cristao/core/purchases/purchase_service.dart';
import 'package:saber_cristao/core/storage/local_storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MonetizationService {
  MonetizationService({
    required this.localStorage,
    required this.adService,
    required this.purchaseService,
    required this.supabaseClient,
  });

  final LocalStorageService localStorage;
  final AdService adService;
  final PurchaseService purchaseService;
  final SupabaseClient? supabaseClient;

  Future<void> initialize() async {
    await adService.initialize();
    await purchaseService.initialize();
  }

  Future<bool> getPremiumDevOverride() {
    return localStorage.getPremiumDevOverride();
  }

  Future<void> setPremiumDevOverride(bool value) {
    return localStorage.savePremiumDevOverride(value);
  }

  Future<bool> fetchRemotePremiumStatus(String userId) async {
    final client = supabaseClient;
    if (client == null) return false;
    final row = await client
        .from('profiles')
        .select('is_premium, premium_until')
        .eq('user_id', userId)
        .maybeSingle();
    if (row == null) return false;
    final isPremium = row['is_premium'] == true;
    final premiumUntil = row['premium_until'] == null
        ? null
        : DateTime.tryParse(row['premium_until'] as String);
    final stillValid = premiumUntil == null || premiumUntil.isAfter(DateTime.now());
    return isPremium && stillValid;
  }

  bool canShowAds(bool isPremium) => !isPremium;

  bool shouldShowBanner({
    required bool isPremium,
    required AdPlacement placement,
  }) {
    return !isPremium &&
        (placement == AdPlacement.home || placement == AdPlacement.levelMap);
  }

  Future<bool> showInterstitialIfAllowed({
    required bool isPremium,
    required AdPlacement placement,
  }) async {
    if (isPremium) return false;
    return adService.showInterstitialIfAllowed(placement);
  }

  Future<bool> showRewardedAd({
    required bool isPremium,
    required RewardType rewardType,
  }) async {
    if (isPremium) return false;
    return adService.showRewardedAd(rewardType);
  }

  Future<List<PurchaseProduct>> loadProducts() {
    return purchaseService.loadProducts();
  }

  Future<PurchaseResult> buyProduct(String productId) {
    return purchaseService.buyProduct(productId);
  }

  Future<PurchaseResult> restorePurchases() {
    return purchaseService.restorePurchases();
  }
}
