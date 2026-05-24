import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class PurchasesRepository {
  Future<void> applyPurchaseDevOnly({
    required String productId,
    required String purchaseType,
  });
}

class DevPurchasesRepository implements PurchasesRepository {
  @override
  Future<void> applyPurchaseDevOnly({
    required String productId,
    required String purchaseType,
  }) async {
    // SECURITY BEFORE PRODUCTION:
    // purchases must be validated by backend or Edge Function before granting
    // premium or consumable credits in production.
  }
}

final purchasesRepositoryProvider = Provider<PurchasesRepository>((ref) {
  return DevPurchasesRepository();
});
