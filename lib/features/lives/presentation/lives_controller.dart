import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/core/storage/local_storage_service.dart';

class LivesController extends StateNotifier<int> {
  LivesController(this._storage) : super(5) {
    _load();
  }

  final LocalStorageService _storage;

  Future<void> _load() async {
    state = await _storage.getLives();
  }

  Future<void> loseLife() async {
    state = (state - 1).clamp(0, 99);
    await _storage.saveLives(state);
  }

  Future<void> addLife([int amount = 1]) async {
    state = (state + amount).clamp(0, 99);
    await _storage.saveLives(state);
  }

  Future<void> setLives(int value) async {
    state = value.clamp(0, 99);
    await _storage.saveLives(state);
  }
}

final localStorageProvider = Provider<LocalStorageService>((_) {
  return LocalStorageService();
});

final livesControllerProvider = StateNotifierProvider<LivesController, int>(
  (ref) => LivesController(ref.watch(localStorageProvider)),
);
