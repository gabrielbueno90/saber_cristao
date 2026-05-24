import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/core/storage/local_storage_service.dart';

abstract class CreditsRepository {
  Future<int> loadCredits();
  Future<int> addCreditsDevOnly(int currentCredits, int amount);
  Future<int?> spendCredits(int currentCredits, int amount);
  Future<int> setCredits(int value);
}

class LocalCreditsRepository implements CreditsRepository {
  LocalCreditsRepository(this._ref);

  final Ref _ref;

  @override
  Future<int> loadCredits() async {
    final storage = _ref.read(localStorageProvider);
    return storage.getCredits();
  }

  @override
  Future<int> addCreditsDevOnly(int currentCredits, int amount) async {
    // SECURITY BEFORE PRODUCTION:
    // move credit grants to Supabase Edge Function before production.
    final nextValue = currentCredits + amount;
    await _ref.read(localStorageProvider).saveCredits(nextValue);
    return nextValue;
  }

  @override
  Future<int?> spendCredits(int currentCredits, int amount) async {
    if (currentCredits < amount) return null;
    // SECURITY BEFORE PRODUCTION:
    // move credit spending validation to Supabase Edge Function before production.
    final nextValue = currentCredits - amount;
    await _ref.read(localStorageProvider).saveCredits(nextValue);
    return nextValue;
  }

  @override
  Future<int> setCredits(int value) async {
    final nextValue = value.clamp(0, 999999);
    await _ref.read(localStorageProvider).saveCredits(nextValue);
    return nextValue;
  }
}

final creditsRepositoryProvider = Provider<CreditsRepository>((ref) {
  return LocalCreditsRepository(ref);
});
