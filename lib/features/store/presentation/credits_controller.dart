import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/features/store/data/credits_repository.dart';

class CreditsController extends StateNotifier<int> {
  CreditsController(this._ref) : super(10) {
    _load();
  }

  final Ref _ref;

  Future<void> _load() async {
    state = await _ref.read(creditsRepositoryProvider).loadCredits();
  }

  Future<void> addCreditsDevOnly(int amount) async {
    state = await _ref
        .read(creditsRepositoryProvider)
        .addCreditsDevOnly(state, amount);
  }

  Future<bool> spendCredits([int amount = 1]) async {
    final nextValue =
        await _ref.read(creditsRepositoryProvider).spendCredits(state, amount);
    if (nextValue == null) return false;
    state = nextValue;
    return true;
  }

  Future<void> setCredits(int value) async {
    state = await _ref.read(creditsRepositoryProvider).setCredits(value);
  }
}

final creditsControllerProvider =
    StateNotifierProvider<CreditsController, int>((ref) {
  return CreditsController(ref);
});
