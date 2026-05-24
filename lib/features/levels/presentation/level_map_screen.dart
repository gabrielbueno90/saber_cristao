import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/core/ads/banner_ad_widget.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/core/monetization/ad_placement.dart';
import 'package:saber_cristao/features/progress/presentation/progress_controller.dart';

class LevelMapScreen extends ConsumerWidget {
  const LevelMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressControllerProvider);
    final levels = List.generate(12, (index) {
      final level = index + 1;
      final completed = level < progress.currentLevel;
      final unlocked = level <= progress.currentLevel + 1;
      final stars = completed ? 2 : 0;
      return (level, unlocked, completed, stars);
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
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: levels.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.05,
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
                      context.push('/quiz');
                    },
                    child: Card(
                      color: unlocked ? AppTheme.parchment : AppTheme.cream,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$level',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            AppSpacing.v8,
                            Text(
                              completed ? 'Concluída' : (unlocked ? 'Desbloqueada' : 'Bloqueada'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                            AppSpacing.v8,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                3,
                                (i) => Icon(
                                  Icons.star,
                                  size: 14,
                                  color: i < stars ? AppTheme.gold : AppTheme.secondaryBrown.withValues(alpha: 0.35),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            AppSpacing.v16,
            OutlinedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Voltar para início'),
            ),
            AppSpacing.v12,
            const MonetizedBannerSlot(placement: AdPlacement.levelMap),
          ],
        ),
      ),
    );
  }
}
