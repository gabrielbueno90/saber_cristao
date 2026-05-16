import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';

class LevelMapScreen extends StatelessWidget {
  const LevelMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final levels = List.generate(12, (index) {
      final level = index + 1;
      final unlocked = level <= 4;
      final completed = level <= 2;
      final stars = completed ? (level == 1 ? 3 : 2) : 0;
      return (level, unlocked, completed, stars);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de fases')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
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
    );
  }
}
