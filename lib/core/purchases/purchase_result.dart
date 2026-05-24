import 'package:saber_cristao/core/purchases/purchase_status.dart';

class PurchaseResult {
  const PurchaseResult({
    required this.status,
    required this.productId,
    this.message,
  });

  final PurchaseStatusState status;
  final String productId;
  final String? message;
}
