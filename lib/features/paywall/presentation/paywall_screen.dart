import 'package:flutter/material.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cristao Premium')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Cristao Premium', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  SizedBox(height: 8),
                  Text('Jogue sem anuncios e receba beneficios diarios.'),
                  SizedBox(height: 12),
                  Text('- Sem anuncios'),
                  Text('- Bonus diario de creditos'),
                  Text('- Mais vidas'),
                  Text('- Experiencia limpa para estudar e jogar'),
                  Text('- Trilhas especiais futuras'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          _PlanCard(title: 'Mensal', price: 'R\$ 14,90 / mes'),
          _PlanCard(title: 'Anual com desconto', price: 'R\$ 119,90 / ano'),
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
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(price),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Integracao de assinatura sera ativada em breve.')),
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
