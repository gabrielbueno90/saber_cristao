import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/core/ads/banner_ad_widget.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/core/monetization/ad_placement.dart';
import 'package:saber_cristao/features/progress/presentation/progress_controller.dart';
import 'package:saber_cristao/features/levels/presentation/user_level_progress_controller.dart';
import 'package:saber_cristao/shared/widgets/app_action_buttons.dart';

class LevelMapScreen extends ConsumerWidget {
  const LevelMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressControllerProvider);
    final levelProgressAsync = ref.watch(userLevelProgressesProvider);
    final levels = List.generate(15, (index) {
      final level = index + 1;
      final completed = level < progress.currentLevel;
      final unlocked = level <= progress.currentLevel;
      final bestStars = levelProgressAsync.maybeWhen(
        data: (items) {
          final matches = items.where((item) => item.level == level).toList();
          return matches.isEmpty ? 0 : matches.first.bestStars;
        },
        orElse: () => 0,
      );
      return (level, unlocked, completed, bestStars);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de fases'),
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar para início',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.lg + AppSpacing.md,
          ),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  itemCount: levels.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (context, index) {
                    final data = levels[index];
                    final level = data.$1;
                    final unlocked = data.$2;
                    final completed = data.$3;
                    final stars = data.$4;

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        if (!unlocked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Essa fase ainda está bloqueada. Continue sua jornada.'),
                            ),
                          );
                          return;
                        }
                        context.push('/quiz?level=$level');
                      },
                      child: Card(
                        color: unlocked ? AppTheme.parchment : AppTheme.cream,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 8,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '$level',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                completed
                                    ? 'Concluída'
                                    : (unlocked ? 'Desbloqueada' : 'Bloqueada'),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11),
                              ),
                              FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    3,
                                    (i) => Icon(
                                      Icons.star,
                                      size: 13,
                                      color: i < stars
                                          ? AppTheme.gold
                                          : AppTheme.secondaryBrown.withValues(alpha: 0.35),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              AppSpacing.v24,
              AppSecondaryButton(
                label: 'Voltar para início',
                onPressed: () => context.go('/home'),
              ),
              AppSpacing.v16,
              const MonetizedBannerSlot(placement: AdPlacement.levelMap),
              AppSpacing.v16,
            ],
          ),
        ),
      ),
    );
  }
}
