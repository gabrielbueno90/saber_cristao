class PurchaseProduct {
  const PurchaseProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.priceLabel,
    required this.isSubscription,
  });

  final String id;
  final String title;
  final String description;
  final String priceLabel;
  final bool isSubscription;
}
