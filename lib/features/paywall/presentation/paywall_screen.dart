import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/core/monetization/monetization_provider.dart';
import 'package:saber_cristao/core/purchases/product_ids.dart';
import 'package:saber_cristao/core/purchases/purchase_product.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() async {
      await ref.read(monetizationControllerProvider.notifier).loadProducts();
      await ref.read(monetizationControllerProvider.notifier).refreshPremiumStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final monetization = ref.watch(monetizationControllerProvider);
    final products = ref
        .watch(monetizationControllerProvider.notifier)
        .products
        .where((item) => item.isSubscription)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Cristão Premium')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cristão Premium',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  AppSpacing.v12,
                  const Text(
                    'Uma experiência limpa para aprender, jogar e avançar sem interrupções.',
                  ),
                  AppSpacing.v16,
                  const Text('- Sem anúncios'),
                  AppSpacing.v8,
                  const Text('- Mais vidas para continuar jogando'),
                  AppSpacing.v8,
                  const Text('- Bônus diário de créditos'),
                  AppSpacing.v8,
                  const Text('- Experiência mais limpa e focada'),
                  AppSpacing.v8,
                  const Text('- Trilhas especiais futuras'),
                  AppSpacing.v8,
                  const Text('- Apoie o desenvolvimento do Saber Cristão'),
                  AppSpacing.v16,
                  Text('Modo de compra: ${monetization.purchaseModeLabel}'),
                  if (monetization.isPremium) ...[
                    AppSpacing.v12,
                    const Chip(label: Text('Você já é Premium')),
                  ],
                ],
              ),
            ),
          ),
          AppSpacing.v16,
          ...products.map(
            (product) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _PlanCard(
                product: product,
                ctaLabel: product.id == ProductIds.premiumYearly
                    ? 'Assinar anual'
                    : 'Assinar mensal',
                loading: monetization.isLoading,
                onTap: () async {
                  final result = await ref
                      .read(monetizationControllerProvider.notifier)
                      .buyProduct(product.id);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        result.message ?? 'Fluxo de compra iniciado.',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (monetization.errorMessage != null) ...[
            Text(
              monetization.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
            AppSpacing.v12,
          ],
          OutlinedButton(
            onPressed: monetization.isLoading
                ? null
                : () async {
                    final result = await ref
                        .read(monetizationControllerProvider.notifier)
                        .restorePurchases();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result.message ?? 'Restore iniciado.',
                        ),
                      ),
                    );
                  },
            child: const Text('Restaurar compras'),
          ),
          if (kDebugMode) ...[
            AppSpacing.v12,
            OutlinedButton(
              onPressed: () => ref
                  .read(monetizationControllerProvider.notifier)
                  .setPremiumDevOnly(!monetization.isPremium),
              child: Text(
                monetization.isPremium
                    ? 'Desativar Premium (dev)'
                    : 'Simular Premium (dev)',
              ),
            ),
          ],
          AppSpacing.v12,
          const Text(
            'O pagamento sera processado pela loja do seu dispositivo.',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
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
  const _PlanCard({
    required this.product,
    required this.ctaLabel,
    required this.loading,
    required this.onTap,
  });

  final PurchaseProduct product;
  final String ctaLabel;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              product.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            AppSpacing.v8,
            Text(product.description),
            AppSpacing.v8,
            Text(product.priceLabel),
            AppSpacing.v16,
            ElevatedButton(
              onPressed: loading ? null : onTap,
              child: Text(ctaLabel),
            ),
          ],
        ),
      ),
    );
  }
}
