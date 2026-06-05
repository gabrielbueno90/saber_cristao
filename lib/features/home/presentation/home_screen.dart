import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/core/ads/banner_ad_widget.dart';
import 'package:saber_cristao/core/app_config.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/core/monetization/ad_placement.dart';
import 'package:saber_cristao/core/monetization/monetization_provider.dart';
import 'package:saber_cristao/features/auth/presentation/auth_controller.dart';
import 'package:saber_cristao/features/lives/presentation/lives_controller.dart';
import 'package:saber_cristao/features/progress/presentation/progress_controller.dart';
import 'package:saber_cristao/features/store/presentation/credits_controller.dart';
import 'package:saber_cristao/shared/widgets/app_action_buttons.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      ref.read(progressControllerProvider.notifier).loadForCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final lives = ref.watch(livesControllerProvider);
    final credits = ref.watch(creditsControllerProvider);
    final progress = ref.watch(progressControllerProvider);
    final monetization = ref.watch(monetizationControllerProvider);

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
            if (AppConfig.showDevBadges) ...[
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  Chip(
                    label: Text(
                      auth.isUsingSupabase ? 'Supabase conectado' : 'Modo mock',
                    ),
                  ),
                  Chip(
                    label: Text('Progresso: ${progress.sourceLabel}'),
                  ),
                  Chip(
                    label: Text('Ads: ${monetization.adModeLabel}'),
                  ),
                ],
              ),
              AppSpacing.v12,
            ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saber Cristão',
                    style: TextStyle(
                      color: AppTheme.softGold,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12),
                  const Text(
                    'Aprenda a Bíblia, avance por desafios e fortaleça sua fé.',
                    style: TextStyle(color: AppTheme.cream),
                  ),
                  if (monetization.isPremium) ...[
                    AppSpacing.v12,
                    const Chip(
                      label: Text('Premium ativo'),
                      backgroundColor: AppTheme.softGold,
                    ),
                  ],
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
            AppPrimaryButton(
              label: 'Começar desafio',
              onPressed: () => context.push('/quiz?level=${progress.currentLevel}'),
            ),
            AppSpacing.v12,
            AppSecondaryButton(
              label: 'Ver fases',
              onPressed: () => context.push('/levels'),
            ),
            AppSpacing.v12,
            AppSecondaryButton(
              label: 'Créditos e loja',
              onPressed: () => context.push('/store'),
            ),
            AppSpacing.v16,
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!monetization.isPremium) ...[
                      const Text(
                        'Cristão Premium',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      AppSpacing.v8,
                      const Text('Jogue sem anúncios e receba benefícios diários.'),
                      AppSpacing.v16,
                      AppPrimaryButton(
                        label: 'Conhecer Premium',
                        onPressed: () => context.push('/paywall'),
                      ),
                    ] else ...[
                      const Text(
                        'Seu plano Premium está ativo',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      AppSpacing.v8,
                      const Text('Você joga sem anúncios e com uma experiência mais limpa.'),
                    ],
                  ],
                ),
              ),
            ),
            if (AppConfig.showDevBadges) ...[
              AppSpacing.v12,
              AppSecondaryButton(
                label: monetization.isPremium
                    ? 'Desativar Premium (dev)'
                    : 'Simular Premium (dev)',
                onPressed: () => ref
                    .read(monetizationControllerProvider.notifier)
                    .setPremiumDevOnly(!monetization.isPremium),
              ),
            ],
            AppSpacing.v12,
            AppOutlineButton(
              label: 'Abrir perfil',
              onPressed: () => context.push('/profile'),
            ),
            AppSpacing.v16,
            const MonetizedBannerSlot(placement: AdPlacement.home),
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
