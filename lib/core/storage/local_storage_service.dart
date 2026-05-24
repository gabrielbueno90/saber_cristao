import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _livesKey = 'local_lives';
  static const _creditsKey = 'local_credits';
  static const _starsKey = 'local_stars';
  static const _premiumDevKey = 'premium_dev_override';
  static const _interstitialCounterKey = 'interstitial_counter';

  Future<void> saveLives(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_livesKey, value);
  }

  Future<int> getLives({int fallback = 5}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_livesKey) ?? fallback;
  }

  Future<void> saveCredits(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_creditsKey, value);
  }

  Future<int> getCredits({int fallback = 10}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_creditsKey) ?? fallback;
  }

  Future<void> saveStars(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_starsKey, value);
  }

  Future<int> getStars({int fallback = 0}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_starsKey) ?? fallback;
  }

  Future<void> savePremiumDevOverride(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumDevKey, value);
  }

  Future<bool> getPremiumDevOverride({bool fallback = false}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_premiumDevKey) ?? fallback;
  }

  Future<void> saveInterstitialCounter(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_interstitialCounterKey, value);
  }

  Future<int> getInterstitialCounter({int fallback = 0}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_interstitialCounterKey) ?? fallback;
  }
}

final localStorageProvider = Provider<LocalStorageService>((_) {
  return LocalStorageService();
});
