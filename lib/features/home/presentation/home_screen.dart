import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/app/theme.dart';
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
        title: const Text('Saber Cristao'),
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
                    'Saber Cristao',
                    style: TextStyle(
                      color: AppTheme.softGold,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Aprenda a Biblia, avance por desafios e fortaleça sua fe.',
                    style: TextStyle(color: AppTheme.cream),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
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
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.push('/quiz'),
              child: const Text('Comecar desafio'),
            ),
            OutlinedButton(
              onPressed: () => context.push('/levels'),
              child: const Text('Ver fases'),
            ),
            OutlinedButton(
              onPressed: () => context.push('/store'),
              child: const Text('Creditos e loja'),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cristao Premium',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    const Text('Jogue sem anuncios e receba beneficios diarios.'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.push('/paywall'),
                      child: const Text('Conhecer Premium'),
                    ),
                  ],
                ),
              ),
            ),
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
