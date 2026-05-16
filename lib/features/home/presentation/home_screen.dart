import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/features/auth/presentation/auth_controller.dart';
import 'package:saber_cristao/features/lives/presentation/lives_controller.dart';
import 'package:saber_cristao/features/progress/presentation/progress_controller.dart';
import 'package:saber_cristao/features/store/presentation/credits_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final lives = ref.watch(livesControllerProvider);
    final credits = ref.watch(creditsControllerProvider);
    final progress = ref.watch(progressControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saber Cristão'),
        actions: [
          if (auth.user != null)
            IconButton(
              onPressed: () =>
                  ref.read(authControllerProvider.notifier).signOut(),
              icon: const Icon(Icons.logout),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [AppTheme.darkBrown, AppTheme.primaryBrown],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(18),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saber Cristão',
                    style: TextStyle(
                      color: AppTheme.softGold,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Aprenda a Bíblia, avance por desafios e fortaleça sua fé.',
                    style: TextStyle(color: AppTheme.cream),
                  ),
                ],
              ),
            ),
            AppSpacing.v16,
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: _MetricTile(label: 'Progresso', value: 'Nivel ${progress.currentLevel}'),
                    ),
                    Expanded(
                      child: _MetricTile(label: 'Vidas', value: '$lives'),
                    ),
                    Expanded(
                      child: _MetricTile(label: 'Creditos', value: '$credits'),
                    ),
                    Expanded(
                      child: _MetricTile(label: 'Estrelas', value: '${progress.totalStars}'),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.v24,
            ElevatedButton(
              onPressed: () => context.push('/quiz'),
              child: const Text('Comecar desafio'),
            ),
            AppSpacing.v12,
            OutlinedButton(
              onPressed: () => context.push('/levels'),
              child: const Text('Ver fases'),
            ),
            AppSpacing.v12,
            OutlinedButton(
              onPressed: () => context.push('/store'),
              child: const Text('Creditos e loja'),
            ),
            AppSpacing.v16,
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cristão Premium',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    AppSpacing.v8,
                    const Text('Jogue sem anúncios e receba benefícios diários.'),
                    AppSpacing.v16,
                    ElevatedButton(
                      onPressed: () => context.push('/paywall'),
                      child: const Text('Conhecer Premium'),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.v12,
            TextButton(
              onPressed: () => context.push('/profile'),
              child: const Text('Abrir perfil'),
            )
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.darkBrown,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
