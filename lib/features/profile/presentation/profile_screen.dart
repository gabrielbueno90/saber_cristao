import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/core/monetization/monetization_provider.dart';
import 'package:saber_cristao/features/auth/presentation/auth_controller.dart';
import 'package:saber_cristao/features/lives/presentation/lives_controller.dart';
import 'package:saber_cristao/features/progress/presentation/progress_controller.dart';
import 'package:saber_cristao/features/store/presentation/credits_controller.dart';
import 'package:saber_cristao/shared/widgets/app_action_buttons.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() async {
      await ref.read(progressControllerProvider.notifier).loadForCurrentUser();
      await ref.read(monetizationControllerProvider.notifier).refreshPremiumStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final progress = ref.watch(progressControllerProvider);
    final lives = ref.watch(livesControllerProvider);
    final credits = ref.watch(creditsControllerProvider);
    final monetization = ref.watch(monetizationControllerProvider);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar para início',
        ),
      ),
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [AppTheme.darkBrown, AppTheme.primaryBrown],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName.isNotEmpty == true ? user!.displayName : 'Seu perfil',
                  style: const TextStyle(
                    color: AppTheme.softGold,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.v8,
                Text(
                  user?.email ?? 'email nao disponivel',
                  style: const TextStyle(color: AppTheme.cream),
                ),
                AppSpacing.v12,
                Chip(
                  backgroundColor: monetization.isPremium
                      ? AppTheme.softGold
                      : AppTheme.cream,
                  label: Text(
                    monetization.isPremium ? 'Premium' : 'Gratuito',
                  ),
                ),
                if (monetization.isPremium) ...[
                  AppSpacing.v8,
                  const Text(
                    'Você joga sem anúncios',
                    style: TextStyle(
                      color: AppTheme.cream,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          AppSpacing.v16,
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  _MetricTile(label: 'Nível atual', value: '${progress.currentLevel}'),
                  _MetricTile(label: 'Estrelas', value: '${progress.totalStars}'),
                  _MetricTile(label: 'Pontuação', value: '${progress.totalScore}'),
                  _MetricTile(label: 'Créditos', value: '$credits'),
                  _MetricTile(label: 'Vidas', value: '$lives'),
                  _MetricTile(
                    label: 'Status',
                    value: monetization.isPremium ? 'Premium' : 'Livre',
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.v16,
          if (!monetization.isPremium) ...[
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
                    const Text('Experiência limpa, sem anúncios e com benefícios diários.'),
                    AppSpacing.v16,
                    AppSecondaryButton(
                      label: 'Conhecer Premium',
                      onPressed: () => context.push('/paywall'),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.v16,
          ] else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Premium ativo',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    AppSpacing.v8,
                    const Text('Você joga sem anúncios e com uma experiência mais limpa.'),
                  ],
                ),
              ),
            ),
            AppSpacing.v16,
          ],
          AppPrimaryButton(
            label: 'Restaurar compras',
            onPressed: () async {
              await ref.read(monetizationControllerProvider.notifier).restorePurchases();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Solicitação de restore enviada.')),
              );
            },
          ),
          AppSpacing.v8,
          const Text(
            'Use esta opção se você já assinou o Premium e reinstalou o app ou trocou de aparelho.',
            style: TextStyle(fontSize: 12),
          ),
          AppSpacing.v12,
          AppSecondaryButton(
            label: 'Sair da conta',
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (!context.mounted) return;
              context.go('/login');
            },
          ),
          AppSpacing.v12,
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

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.cream,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.darkBrown,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }
}
