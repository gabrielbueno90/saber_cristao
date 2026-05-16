import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cristão Premium')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cristão Premium', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  SizedBox(height: 12),
                  Text('Jogue sem anúncios e receba benefícios diários.'),
                  SizedBox(height: 16),
                  Text('- Sem anúncios'),
                  SizedBox(height: 8),
                  Text('- Bônus diário de créditos'),
                  SizedBox(height: 8),
                  Text('- Mais vidas'),
                  SizedBox(height: 8),
                  Text('- Experiência limpa para estudar e jogar'),
                  SizedBox(height: 8),
                  Text('- Trilhas especiais futuras'),
                ],
              ),
            ),
          ),
          AppSpacing.v16,
          _PlanCard(title: 'Mensal', price: 'R\$ 14,90 / mes'),
          AppSpacing.v16,
          _PlanCard(title: 'Anual com desconto', price: 'R\$ 119,90 / ano'),
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

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.title, required this.price});

  final String title;
  final String price;

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
            Text(price),
            AppSpacing.v16,
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Integração de assinatura será ativada em breve.')),
                );
              },
              child: const Text('Assinar plano'),
            )
          ],
        ),
      ),
    );
  }
}
