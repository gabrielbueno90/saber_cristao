import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/features/progress/presentation/progress_controller.dart';
import 'package:saber_cristao/features/store/presentation/credits_controller.dart';

class StoreScreen extends ConsumerWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credits = ref.watch(creditsControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Loja de créditos')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text('Seus créditos atuais: $credits'),
            ),
          ),
          AppSpacing.v16,
          _CreditPackCard(
            title: '10 créditos',
            subtitle: 'Ideal para continuar fases e recuperar vidas.',
            onTap: () {
              ref.read(creditsControllerProvider.notifier).addCredits(10);
              ref.read(progressControllerProvider.notifier).syncToRemote();
            },
          ),
          AppSpacing.v16,
          _CreditPackCard(
            title: '50 créditos',
            subtitle: 'Perfeito para comprar dicas e segunda chance.',
            onTap: () {
              ref.read(creditsControllerProvider.notifier).addCredits(50);
              ref.read(progressControllerProvider.notifier).syncToRemote();
            },
          ),
          AppSpacing.v16,
          _CreditPackCard(
            title: '150 créditos',
            subtitle: 'Pacote avançado para evoluir mais rápido.',
            onTap: () {
              ref.read(creditsControllerProvider.notifier).addCredits(150);
              ref.read(progressControllerProvider.notifier).syncToRemote();
            },
          ),
          AppSpacing.v24,
          const Text('Os créditos podem ser usados para continuar fases, comprar dicas, recuperar vidas e segunda chance.'),
          AppSpacing.v24,
          OutlinedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Voltar para início'),
          ),
        ],
      ),
    );
  }
}

class _CreditPackCard extends StatelessWidget {
  const _CreditPackCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            AppSpacing.v8,
            Text(subtitle),
            AppSpacing.v16,
            ElevatedButton(
              onPressed: onTap,
              child: const Text('Selecionar pacote'),
            )
          ],
        ),
      ),
    );
  }
}
