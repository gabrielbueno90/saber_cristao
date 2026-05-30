import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:saber_cristao/core/purchases/product_ids.dart';
import 'package:saber_cristao/core/purchases/purchase_product.dart';
import 'package:saber_cristao/core/purchases/purchase_result.dart';
import 'package:saber_cristao/core/purchases/purchase_service.dart';
import 'package:saber_cristao/core/purchases/purchase_status.dart';

class InAppPurchaseService implements PurchaseService {
  InAppPurchaseService(this._iap);

  final InAppPurchase _iap;
  final StreamController<PurchaseResult> _purchaseUpdates =
      StreamController<PurchaseResult>.broadcast();
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _available = false;
  List<ProductDetails> _products = const [];

  @override
  String get modeLabel => kIsWeb ? 'Mock (web)' : (_available ? 'Sandbox/teste' : 'Mock fallback');

  @override
  Stream<PurchaseResult> get purchaseUpdates => _purchaseUpdates.stream;

  @override
  Future<void> initialize() async {
    if (kIsWeb) return;
    _available = await _iap.isAvailable();
    _subscription ??= _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) {
        _purchaseUpdates.add(
          PurchaseResult(
            status: PurchaseStatusState.error,
            productId: 'unknown',
            message: 'Falha ao receber atualização da loja: $error',
          ),
        );
      },
    );
  }

  @override
  Future<List<PurchaseProduct>> loadProducts() async {
    if (!_available || kIsWeb) {
      return _mockProducts;
    }
    final response = await _iap.queryProductDetails(ProductIds.all.toSet());
    if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
      _purchaseUpdates.add(
        PurchaseResult(
          status: PurchaseStatusState.error,
          productId: response.notFoundIDs.join(', '),
          message:
              'Produtos nao encontrados na loja. Confira IDs, build interno e testadores.',
        ),
      );
      return _mockProducts;
    }
    _products = response.productDetails;
    return _products
        .map(
          (product) => PurchaseProduct(
            id: product.id,
            title: product.title,
            description: product.description,
            priceLabel: product.price,
            isSubscription: ProductIds.subscriptions.contains(product.id),
          ),
        )
        .toList();
  }

  @override
  Future<PurchaseResult> buyProduct(String productId) async {
    if (kIsWeb || !_available) {
      return PurchaseResult(
        status: PurchaseStatusState.purchased,
        productId: productId,
        message: 'Compra simulada em modo dev/mock.',
      );
    }
    final product = _products.where((item) => item.id == productId).firstOrNull;
    if (product == null) {
      return PurchaseResult(
        status: PurchaseStatusState.error,
        productId: productId,
        message: 'Produto nao encontrado no ambiente atual.',
      );
    }

    final purchaseParam = PurchaseParam(productDetails: product);
    if (ProductIds.subscriptions.contains(productId)) {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } else {
      await _iap.buyConsumable(purchaseParam: purchaseParam);
    }
    return PurchaseResult(
      status: PurchaseStatusState.pending,
      productId: productId,
      message: 'Compra enviada para a loja.',
    );
  }

  @override
  Future<PurchaseResult> restorePurchases() async {
    if (kIsWeb || !_available) {
      return const PurchaseResult(
        status: PurchaseStatusState.restored,
        productId: 'restore',
        message: 'Restore simulado em modo dev/mock.',
      );
    }
    await _iap.restorePurchases();
    return const PurchaseResult(
      status: PurchaseStatusState.pending,
      productId: 'restore',
      message: 'Solicitacao de restore enviada.',
    );
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      final result = _mapPurchaseDetails(purchase);
      _purchaseUpdates.add(result);

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  PurchaseResult _mapPurchaseDetails(PurchaseDetails purchase) {
    switch (purchase.status) {
      case PurchaseStatus.pending:
        return PurchaseResult(
          status: PurchaseStatusState.pending,
          productId: purchase.productID,
          message: 'Compra pendente na loja.',
        );
      case PurchaseStatus.purchased:
        return PurchaseResult(
          status: PurchaseStatusState.purchased,
          productId: purchase.productID,
          message: 'Compra concluida pela loja.',
        );
      case PurchaseStatus.restored:
        return PurchaseResult(
          status: PurchaseStatusState.restored,
          productId: purchase.productID,
          message: 'Compra restaurada pela loja.',
        );
      case PurchaseStatus.canceled:
        return PurchaseResult(
          status: PurchaseStatusState.cancelled,
          productId: purchase.productID,
          message: 'Compra cancelada.',
        );
      case PurchaseStatus.error:
        return PurchaseResult(
          status: PurchaseStatusState.error,
          productId: purchase.productID,
          message: purchase.error?.message ?? 'Erro na compra.',
        );
    }
  }
}

final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  return InAppPurchaseService(InAppPurchase.instance);
});

const List<PurchaseProduct> _mockProducts = [
  PurchaseProduct(
    id: ProductIds.premiumMonthly,
    title: 'Premium mensal',
    description: 'Sem anuncios, bonus diario e mais vidas.',
    priceLabel: 'R\$ 14,90 / mes',
    isSubscription: true,
  ),
  PurchaseProduct(
    id: ProductIds.premiumYearly,
    title: 'Premium anual',
    description: 'Plano com desconto para quem joga com frequencia.',
    priceLabel: 'R\$ 119,90 / ano',
    isSubscription: true,
  ),
  PurchaseProduct(
    id: ProductIds.credits10,
    title: 'Pacote Inicial',
    description: '10 creditos para continuar fases e recuperar vidas.',
    priceLabel: '10 creditos',
    isSubscription: false,
  ),
  PurchaseProduct(
    id: ProductIds.credits50,
    title: 'Mais Popular',
    description: '50 creditos para dicas e segundas chances.',
    priceLabel: '50 creditos',
    isSubscription: false,
  ),
  PurchaseProduct(
    id: ProductIds.credits150,
    title: 'Melhor Valor',
    description: '150 creditos para quem quer evoluir rapido.',
    priceLabel: '150 creditos',
    isSubscription: false,
  ),
];
