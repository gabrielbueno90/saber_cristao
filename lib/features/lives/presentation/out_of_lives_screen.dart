import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/core/storage/local_storage_service.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/core/monetization/monetization_provider.dart';
import 'package:saber_cristao/core/monetization/reward_type.dart';
import 'package:saber_cristao/features/lives/presentation/lives_controller.dart';
import 'package:saber_cristao/features/progress/presentation/progress_controller.dart';
import 'package:saber_cristao/features/store/presentation/credits_controller.dart';
import 'package:saber_cristao/shared/widgets/app_action_buttons.dart';

class OutOfLivesScreen extends ConsumerWidget {
  const OutOfLivesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monetization = ref.watch(monetizationControllerProvider);
    final isPremium = monetization.isPremium;
    final interval = Duration(minutes: isPremium ? 15 : 30);
    return Scaffold(
      appBar: AppBar(title: const Text('Sem vidas')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.lg + AppSpacing.md,
          ),
          children: [
            const Text(
              'Você ficou sem vidas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            AppSpacing.v8,
            const Text(
              'Continue sua jornada bíblica escolhendo uma das opções abaixo.',
            ),
            AppSpacing.v8,
            FutureBuilder<DateTime?>(
              future: ref.read(localStorageProvider).getLastLifeRegenAt(),
              builder: (context, snapshot) {
                final last = snapshot.data;
                final elapsed = last == null ? Duration.zero : DateTime.now().difference(last);
                final remaining = interval - elapsed;
                final display = remaining.isNegative
                    ? '00:00'
                    : _formatDuration(remaining);
                return Text(
                  'Próxima vida em: $display',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                );
              },
            ),
            AppSpacing.v24,
            if (!isPremium) ...[
              AppPrimaryButton(
                label: 'Assistir anúncio e ganhar 1 vida',
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
              ),
              AppSpacing.v12,
            ],
            if (isPremium) ...[
              AppSpacing.v12,
              const Text(
                'Você ficou sem vidas, mas sua recuperação é mais rápida como Premium.',
                textAlign: TextAlign.center,
              ),
              AppSpacing.v12,
            ],
            AppSecondaryButton(
              label: 'Usar 1 crédito para continuar',
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
            ),
            AppSpacing.v12,
            AppSecondaryButton(
              label: 'Comprar créditos',
              onPressed: () => context.push('/store'),
            ),
            AppSpacing.v12,
            AppSecondaryButton(
              label: 'Conhecer Premium',
              onPressed: () => context.push('/paywall'),
            ),
            AppSpacing.v24,
            AppOutlineButton(
              label: 'Voltar para início',
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  final safe = duration.isNegative ? Duration.zero : duration;
  final minutes = safe.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = safe.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
