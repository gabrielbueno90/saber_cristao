import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/core/ads/adaptive_banner_ad_widget.dart';
import 'package:saber_cristao/core/monetization/ad_placement.dart';
import 'package:saber_cristao/core/monetization/monetization_provider.dart';

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({
    super.key,
    required this.enabled,
    this.showLabel = true,
  });

  final bool enabled;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBannerAdWidget(
      enabled: enabled,
      showLabel: showLabel,
    );
  }
}

class MonetizedBannerSlot extends ConsumerWidget {
  const MonetizedBannerSlot({
    super.key,
    required this.placement,
    this.showLabel = true,
  });

  final AdPlacement placement;
  final bool showLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monetization = ref.watch(monetizationControllerProvider);
    final enabled = !monetization.isPremium &&
        ref
            .read(monetizationControllerProvider.notifier)
            .shouldShowBanner(placement);
    return ref.watch(adServiceProvider).buildBanner(
          placement: placement,
          enabled: enabled,
        );
  }
}
