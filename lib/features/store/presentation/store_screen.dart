import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/core/monetization/monetization_provider.dart';
import 'package:saber_cristao/core/purchases/product_ids.dart';
import 'package:saber_cristao/core/purchases/purchase_product.dart';
import 'package:saber_cristao/features/store/presentation/credits_controller.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(monetizationControllerProvider.notifier).loadProducts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final credits = ref.watch(creditsControllerProvider);
    final monetization = ref.watch(monetizationControllerProvider);
    final products = ref
        .watch(monetizationControllerProvider.notifier)
        .products
        .where((item) => !item.isSubscription)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Loja de créditos')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Seus créditos atuais: $credits'),
                  AppSpacing.v8,
                  Text(
                    'Modo de compra: ${monetization.purchaseModeLabel}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.v16,
          ...products.map(
            (product) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _CreditPackCard(
                product: product,
                badge: _badgeForProduct(product.id),
                onTap: monetization.isLoading
                    ? null
                    : () async {
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
          AppSpacing.v16,
          const Text(
            'Créditos podem ser usados para continuar fases, recuperar vidas, comprar dicas futuras e garantir uma segunda chance.',
          ),
          AppSpacing.v24,
          OutlinedButton(
            onPressed: () => context.push('/paywall'),
            child: const Text('Conhecer Premium'),
          ),
          AppSpacing.v12,
          OutlinedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Voltar para início'),
          ),
        ],
      ),
    );
  }

  String _badgeForProduct(String id) {
    if (id == ProductIds.credits50) return 'Mais Popular';
    if (id == ProductIds.credits150) return 'Melhor Valor';
    return 'Pacote Inicial';
  }
}

class _CreditPackCard extends StatelessWidget {
  const _CreditPackCard({
    required this.product,
    required this.badge,
    required this.onTap,
  });

  final PurchaseProduct product;
  final String badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(label: Text(badge)),
            ),
            AppSpacing.v8,
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
              onPressed: onTap,
              child: const Text('Comprar créditos'),
            ),
          ],
        ),
      ),
    );
  }
}
