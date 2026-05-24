import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/core/ads/ad_frequency_controller.dart';
import 'package:saber_cristao/core/ads/ad_service.dart';
import 'package:saber_cristao/core/ads/admob_service.dart';
import 'package:saber_cristao/core/monetization/monetization_controller.dart';
import 'package:saber_cristao/core/monetization/monetization_service.dart';
import 'package:saber_cristao/core/monetization/monetization_state.dart';
import 'package:saber_cristao/core/purchases/in_app_purchase_service.dart';
import 'package:saber_cristao/core/purchases/purchase_service.dart';
import 'package:saber_cristao/core/storage/local_storage_service.dart';
import 'package:saber_cristao/core/supabase/supabase_client_provider.dart';

final adServiceProvider = Provider<AdService>((ref) {
  return AdMobService(ref.read(adFrequencyControllerProvider));
});

final purchaseFacadeProvider = Provider<PurchaseService>((ref) {
  return ref.read(purchaseServiceProvider);
});

final monetizationServiceProvider = Provider<MonetizationService>((ref) {
  return MonetizationService(
    localStorage: ref.read(localStorageProvider),
    adService: ref.read(adServiceProvider),
    purchaseService: ref.read(purchaseFacadeProvider),
    supabaseClient: ref.read(supabaseClientProvider),
  );
});

final monetizationControllerProvider =
    StateNotifierProvider<MonetizationController, MonetizationState>((ref) {
  final controller = MonetizationController(
    ref,
    ref.read(monetizationServiceProvider),
  );
  controller.initialize();
  return controller;
});
