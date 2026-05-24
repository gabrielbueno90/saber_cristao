import 'package:saber_cristao/core/monetization/premium_entitlement.dart';

class MonetizationState {
  const MonetizationState({
    required this.entitlement,
    required this.isPremium,
    required this.adsEnabled,
    required this.isInitialized,
    required this.debugModeLabel,
    required this.purchaseModeLabel,
    required this.adModeLabel,
    required this.isLoading,
    this.errorMessage,
  });

  const MonetizationState.initial()
      : this(
          entitlement: PremiumEntitlement.free,
          isPremium: false,
          adsEnabled: true,
          isInitialized: false,
          debugModeLabel: 'Dev/mock',
          purchaseModeLabel: 'Mock',
          adModeLabel: 'Ads off',
          isLoading: false,
        );

  final PremiumEntitlement entitlement;
  final bool isPremium;
  final bool adsEnabled;
  final bool isInitialized;
  final String debugModeLabel;
  final String purchaseModeLabel;
  final String adModeLabel;
  final bool isLoading;
  final String? errorMessage;

  MonetizationState copyWith({
    PremiumEntitlement? entitlement,
    bool? isPremium,
    bool? adsEnabled,
    bool? isInitialized,
    String? debugModeLabel,
    String? purchaseModeLabel,
    String? adModeLabel,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MonetizationState(
      entitlement: entitlement ?? this.entitlement,
      isPremium: isPremium ?? this.isPremium,
      adsEnabled: adsEnabled ?? this.adsEnabled,
      isInitialized: isInitialized ?? this.isInitialized,
      debugModeLabel: debugModeLabel ?? this.debugModeLabel,
      purchaseModeLabel: purchaseModeLabel ?? this.purchaseModeLabel,
      adModeLabel: adModeLabel ?? this.adModeLabel,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
