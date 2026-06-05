import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/features/levels/data/user_level_progress_repository.dart';
import 'package:saber_cristao/features/levels/domain/user_level_progress_model.dart';

final userLevelProgressesProvider =
    FutureProvider<List<UserLevelProgressModel>>((ref) async {
  return ref.watch(myLevelProgressProvider.future);
});
