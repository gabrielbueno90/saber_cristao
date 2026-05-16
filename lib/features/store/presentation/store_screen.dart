import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/features/store/presentation/credits_controller.dart';

class StoreScreen extends ConsumerWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credits = ref.watch(creditsControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Loja de creditos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text('Seus creditos atuais: $credits'),
            ),
          ),
          const SizedBox(height: 8),
          _CreditPackCard(
            title: '10 creditos',
            subtitle: 'Ideal para continuar fases e recuperar vidas.',
            onTap: () => ref.read(creditsControllerProvider.notifier).addCredits(10),
          ),
          _CreditPackCard(
            title: '50 creditos',
            subtitle: 'Perfeito para comprar dicas e segunda chance.',
            onTap: () => ref.read(creditsControllerProvider.notifier).addCredits(50),
          ),
          _CreditPackCard(
            title: '150 creditos',
            subtitle: 'Pacote avancado para evoluir mais rapido.',
            onTap: () => ref.read(creditsControllerProvider.notifier).addCredits(150),
          ),
          const SizedBox(height: 10),
          const Text('Os creditos podem ser usados para continuar fases, comprar dicas, recuperar vidas e segunda chance.'),
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
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(subtitle),
            const SizedBox(height: 12),
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
