import 'package:saber_cristao/core/purchases/purchase_product.dart';
import 'package:saber_cristao/core/purchases/purchase_result.dart';

abstract class PurchaseService {
  String get modeLabel;
  Stream<PurchaseResult> get purchaseUpdates;
  Future<void> initialize();
  Future<List<PurchaseProduct>> loadProducts();
  Future<PurchaseResult> buyProduct(String productId);
  Future<PurchaseResult> restorePurchases();
}
