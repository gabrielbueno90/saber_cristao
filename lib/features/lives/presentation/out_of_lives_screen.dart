import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/core/monetization/monetization_provider.dart';
import 'package:saber_cristao/core/monetization/reward_type.dart';
import 'package:saber_cristao/features/lives/presentation/lives_controller.dart';
import 'package:saber_cristao/features/progress/presentation/progress_controller.dart';
import 'package:saber_cristao/features/store/presentation/credits_controller.dart';

class OutOfLivesScreen extends ConsumerWidget {
  const OutOfLivesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monetization = ref.watch(monetizationControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Sem vidas')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            const Text(
              'Você ficou sem vidas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            AppSpacing.v8,
            const Text(
              'Continue sua jornada bíblica escolhendo uma das opções abaixo.',
            ),
            AppSpacing.v24,
            if (!monetization.isPremium) ...[
              ElevatedButton(
                onPressed: () async {
                  final rewarded = await ref
                      .read(monetizationControllerProvider.notifier)
                      .showRewardedAd(RewardType.life);
                  if (!rewarded && kDebugMode) {
                    await ref
                        .read(monetizationControllerProvider.notifier)
                        .grantRewardDevOnly(RewardType.life);
                  }
                  if (!context.mounted) return;
                  final lives = ref.read(livesControllerProvider);
                  if (lives <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Anuncio indisponivel no momento. Escolha outra opcao para continuar.'),
                      ),
                    );
                    return;
                  }
                  if (context.mounted) context.go('/quiz');
                },
                child: const Text('Assistir anúncio e ganhar 1 vida'),
              ),
              AppSpacing.v12,
            ],
            OutlinedButton(
              onPressed: () async {
                final ok = await ref.read(creditsControllerProvider.notifier).spendCredits(1);
                if (!context.mounted) return;
                if (!ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Você não tem créditos suficientes.')),
                  );
                  return;
                }
                await ref.read(livesControllerProvider.notifier).addLife();
                await ref.read(progressControllerProvider.notifier).syncToRemote();
                if (context.mounted) context.go('/quiz');
              },
              child: const Text('Usar 1 crédito para continuar'),
            ),
            AppSpacing.v12,
            OutlinedButton(
              onPressed: () => context.push('/store'),
              child: const Text('Comprar créditos'),
            ),
            AppSpacing.v12,
            OutlinedButton(
              onPressed: () => context.push('/paywall'),
              child: const Text('Conhecer Premium'),
            ),
            if (monetization.isPremium) ...[
              AppSpacing.v12,
              const Text(
                'Premium ativo: seus anúncios ficam desativados.',
                textAlign: TextAlign.center,
              ),
            ],
            AppSpacing.v24,
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('Voltar para início'),
            ),
          ],
        ),
      ),
    );
  }
}
