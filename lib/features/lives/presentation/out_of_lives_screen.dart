import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/features/lives/presentation/lives_controller.dart';
import 'package:saber_cristao/features/store/presentation/credits_controller.dart';

class OutOfLivesScreen extends ConsumerWidget {
  const OutOfLivesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sem vidas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Voce ficou sem vidas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Continue sua jornada biblica escolhendo uma das opcoes abaixo.',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await ref.read(livesControllerProvider.notifier).addLife();
                if (context.mounted) context.go('/quiz');
              },
              child: const Text('Assistir anuncio e ganhar 1 vida'),
            ),
            OutlinedButton(
              onPressed: () async {
                final ok = await ref.read(creditsControllerProvider.notifier).consumeCredit(1);
                if (!context.mounted) return;
                if (!ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Voce nao tem creditos suficientes.')),
                  );
                  return;
                }
                await ref.read(livesControllerProvider.notifier).addLife();
                if (context.mounted) context.go('/quiz');
              },
              child: const Text('Usar 1 credito para continuar'),
            ),
            OutlinedButton(
              onPressed: () => context.push('/store'),
              child: const Text('Comprar creditos'),
            ),
            OutlinedButton(
              onPressed: () => context.push('/paywall'),
              child: const Text('Conhecer Premium'),
            ),
          ],
        ),
      ),
    );
  }
}
