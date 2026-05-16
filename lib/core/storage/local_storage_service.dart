import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _livesKey = 'local_lives';
  static const _creditsKey = 'local_credits';
  static const _starsKey = 'local_stars';

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
}
