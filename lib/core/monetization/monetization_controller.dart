import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/core/monetization/ad_placement.dart';
import 'package:saber_cristao/core/monetization/monetization_constants.dart';
import 'package:saber_cristao/core/monetization/monetization_service.dart';
import 'package:saber_cristao/core/monetization/monetization_state.dart';
import 'package:saber_cristao/core/monetization/premium_entitlement.dart';
import 'package:saber_cristao/core/monetization/reward_type.dart';
import 'package:saber_cristao/core/purchases/product_ids.dart';
import 'package:saber_cristao/core/purchases/purchase_product.dart';
import 'package:saber_cristao/core/purchases/purchase_result.dart';
import 'package:saber_cristao/core/purchases/purchase_status.dart';
import 'package:saber_cristao/features/auth/presentation/auth_controller.dart';
import 'package:saber_cristao/features/auth/presentation/auth_state.dart';
import 'package:saber_cristao/features/lives/presentation/lives_controller.dart';
import 'package:saber_cristao/features/paywall/data/purchases_repository.dart';
import 'package:saber_cristao/features/progress/presentation/progress_controller.dart';
import 'package:saber_cristao/features/store/data/rewards_repository.dart';
import 'package:saber_cristao/features/store/presentation/credits_controller.dart';

class MonetizationController extends StateNotifier<MonetizationState> {
  MonetizationController(this._ref, this._service)
      : super(const MonetizationState.initial());

  final Ref _ref;
  final MonetizationService _service;
  List<PurchaseProduct> _cachedProducts = const [];
  StreamSubscription<PurchaseResult>? _purchaseSubscription;

  List<PurchaseProduct> get products => _cachedProducts;

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await _service.initialize();
    _purchaseSubscription ??= _service.purchaseService.purchaseUpdates.listen(
      _handlePurchaseUpdate,
    );
    await refreshPremiumStatus();
    _cachedProducts = await _service.loadProducts();
    state = state.copyWith(
      isInitialized: true,
      isLoading: false,
      adModeLabel: _service.adService.modeLabel,
      purchaseModeLabel: _service.purchaseService.modeLabel,
      debugModeLabel: _service.supabaseClient == null ? 'Dev/mock' : 'Supabase real',
    );
  }

  Future<void> refreshPremiumStatus() async {
    final auth = _ref.read(authControllerProvider);
    final devOverride = kDebugMode && await _service.getPremiumDevOverride();
    var premium = devOverride;

    if (!premium &&
        auth.status == AuthStatus.authenticated &&
        auth.user != null &&
        _service.supabaseClient != null) {
      premium = await _service.fetchRemotePremiumStatus(auth.user!.id);
    }

    state = state.copyWith(
      entitlement:
          premium ? PremiumEntitlement.premium : PremiumEntitlement.free,
      isPremium: premium,
      adsEnabled: !premium,
      errorMessage: null,
    );
  }

  bool isPremium() => state.isPremium;

  bool canShowAds() => state.adsEnabled;

  bool shouldShowBanner(AdPlacement placement) {
    return _service.shouldShowBanner(
      isPremium: state.isPremium,
      placement: placement,
    );
  }

  Future<bool> showInterstitialIfAllowed(AdPlacement placement) {
    return _service.showInterstitialIfAllowed(
      isPremium: state.isPremium,
      placement: placement,
    );
  }

  Future<bool> showRewardedAd(RewardType rewardType) async {
    final rewarded = await _service.showRewardedAd(
      isPremium: state.isPremium,
      rewardType: rewardType,
    );
    if (rewarded) {
      await grantRewardDevOnly(rewardType);
    }
    return rewarded;
  }

  Future<void> grantRewardDevOnly(RewardType rewardType) async {
    switch (rewardType) {
      case RewardType.life:
        await _ref
            .read(rewardsRepositoryProvider)
            .grantAdRewardDevOnly(rewardType: 'life', rewardAmount: 1);
        await _ref.read(livesControllerProvider.notifier).addLife(
              MonetizationConstants.rewardedLifeAmount,
            );
        break;
      case RewardType.credit:
        await _ref
            .read(rewardsRepositoryProvider)
            .grantAdRewardDevOnly(
              rewardType: 'credit',
              rewardAmount: MonetizationConstants.rewardedCreditAmount,
            );
        await _ref
            .read(creditsControllerProvider.notifier)
            .addCreditsDevOnly(MonetizationConstants.rewardedCreditAmount);
        break;
      case RewardType.hint:
      case RewardType.doubleReward:
      case RewardType.continueGame:
        await _ref.read(rewardsRepositoryProvider).grantAdRewardDevOnly(
              rewardType: rewardType.name,
              rewardAmount: 1,
            );
        break;
    }
    await _ref.read(progressControllerProvider.notifier).syncToRemote();
  }

  Future<void> setPremiumDevOnly(bool value) async {
    if (!kDebugMode) return;
    await _service.setPremiumDevOverride(value);
    await refreshPremiumStatus();
  }

  Future<void> loadProducts() async {
    _cachedProducts = await _service.loadProducts();
    state = state.copyWith(
      purchaseModeLabel: _service.purchaseService.modeLabel,
    );
  }

  Future<PurchaseResult> buyProduct(String productId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _service.buyProduct(productId);

    if (result.status == PurchaseStatusState.purchased && kDebugMode) {
      await _applyDevPurchaseResult(productId);
    }

    state = state.copyWith(
      isLoading: false,
      errorMessage: result.status == PurchaseStatusState.error
          ? result.message
          : null,
    );
    return result;
  }

  Future<void> _handlePurchaseUpdate(PurchaseResult result) async {
    if (result.status == PurchaseStatusState.pending) {
      state = state.copyWith(isLoading: true, errorMessage: null);
      return;
    }

    if ((result.status == PurchaseStatusState.purchased ||
            result.status == PurchaseStatusState.restored) &&
        kDebugMode) {
      await _applyDevPurchaseResult(result.productId);
    }

    state = state.copyWith(
      isLoading: false,
      errorMessage: result.status == PurchaseStatusState.error
          ? result.message
          : null,
    );
  }

  Future<void> _applyDevPurchaseResult(String productId) async {
    await _ref.read(purchasesRepositoryProvider).applyPurchaseDevOnly(
          productId: productId,
          purchaseType: ProductIds.subscriptions.contains(productId)
              ? 'subscription'
              : 'consumable',
        );
    if (productId == ProductIds.premiumMonthly ||
        productId == ProductIds.premiumYearly) {
      await setPremiumDevOnly(true);
    }
    if (productId == ProductIds.credits10) {
      await _ref.read(creditsControllerProvider.notifier).addCreditsDevOnly(10);
    }
    if (productId == ProductIds.credits50) {
      await _ref.read(creditsControllerProvider.notifier).addCreditsDevOnly(50);
    }
    if (productId == ProductIds.credits150) {
      await _ref.read(creditsControllerProvider.notifier).addCreditsDevOnly(150);
    }
    await _ref.read(progressControllerProvider.notifier).syncToRemote();
  }

  Future<PurchaseResult> restorePurchases() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _service.restorePurchases();
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.status == PurchaseStatusState.error
          ? result.message
          : null,
    );
    return result;
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}
