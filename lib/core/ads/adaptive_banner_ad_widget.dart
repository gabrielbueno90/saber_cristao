import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/core/ads/ad_unit_ids.dart';
import 'package:saber_cristao/core/ads/responsive_ad_container.dart';

class AdaptiveBannerAdWidget extends StatefulWidget {
  const AdaptiveBannerAdWidget({
    super.key,
    required this.enabled,
    this.showLabel = true,
  });

  final bool enabled;
  final bool showLabel;

  @override
  State<AdaptiveBannerAdWidget> createState() => _AdaptiveBannerAdWidgetState();
}

class _AdaptiveBannerAdWidgetState extends State<AdaptiveBannerAdWidget> {
  BannerAd? _bannerAd;
  AdSize? _adSize;
  bool _ready = false;
  double? _lastWidth;

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> _loadBanner(double width) async {
    if (!widget.enabled || kIsWeb) return;
    if (_lastWidth == width && _bannerAd != null) return;

    _lastWidth = width;
    _ready = false;
    await _bannerAd?.dispose();
    _bannerAd = null;

    final adaptiveSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width.truncate(),
    );
    if (!mounted || adaptiveSize == null) return;

    final banner = BannerAd(
      adUnitId: AdUnitIds.bannerTest,
      request: const AdRequest(),
      size: adaptiveSize,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) return;
          setState(() {
            _ready = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _bannerAd = null;
            _adSize = null;
            _ready = false;
          });
          debugPrint('Adaptive banner failed: ${error.message}');
        },
      ),
    );

    await banner.load();
    if (!mounted) {
      banner.dispose();
      return;
    }

    setState(() {
      _bannerAd = banner;
      _adSize = adaptiveSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        if (!kIsWeb && availableWidth > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _loadBanner(availableWidth);
            }
          });
        }

        if (kIsWeb) {
          return ResponsiveAdContainer(
            showLabel: widget.showLabel,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 50, maxWidth: 420),
              decoration: BoxDecoration(
                color: AppTheme.parchment,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.softGold, width: 0.6),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: const Text(
                'Banner de teste desativado na web',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
            ),
          );
        }

        if (_bannerAd == null || _adSize == null || !_ready) {
          return const SizedBox.shrink();
        }

        return ResponsiveAdContainer(
          showLabel: widget.showLabel,
          child: SizedBox(
            width: _adSize!.width.toDouble(),
            height: _adSize!.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ),
        );
      },
    );
  }
}
