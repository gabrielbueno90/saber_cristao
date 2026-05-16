import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/features/lives/presentation/lives_controller.dart';

class CreditsController extends StateNotifier<int> {
  CreditsController(this._ref) : super(10) {
    _load();
  }

  final Ref _ref;

  Future<void> _load() async {
    final storage = _ref.read(localStorageProvider);
    state = await storage.getCredits();
  }

  Future<void> addCredits(int amount) async {
    state += amount;
    await _ref.read(localStorageProvider).saveCredits(state);
  }

  Future<bool> consumeCredit([int amount = 1]) async {
    if (state < amount) return false;
    state -= amount;
    await _ref.read(localStorageProvider).saveCredits(state);
    return true;
  }
}

final creditsControllerProvider =
    StateNotifierProvider<CreditsController, int>((ref) {
  return CreditsController(ref);
});
