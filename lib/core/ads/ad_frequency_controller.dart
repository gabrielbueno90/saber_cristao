import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/core/monetization/monetization_constants.dart';
import 'package:saber_cristao/core/storage/local_storage_service.dart';

class AdFrequencyController {
  AdFrequencyController(this._storage);

  final LocalStorageService _storage;

  Future<bool> shouldShowInterstitial() async {
    final current = await _storage.getInterstitialCounter();
    final next = current + 1;
    await _storage.saveInterstitialCounter(next);
    if (next < MonetizationConstants.interstitialEveryNQuizCompletions) {
      return false;
    }
    await _storage.saveInterstitialCounter(0);
    return true;
  }
}

final adFrequencyControllerProvider = Provider<AdFrequencyController>((ref) {
  return AdFrequencyController(ref.read(localStorageProvider));
});
