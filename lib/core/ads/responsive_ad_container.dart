import 'package:flutter/material.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';

class ResponsiveAdContainer extends StatelessWidget {
  const ResponsiveAdContainer({
    super.key,
    required this.child,
    required this.showLabel,
  });

  final Widget child;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showLabel)
              const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.xs),
                child: Text(
                  'Publicidade',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
            DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppTheme.softGold, width: 0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Center(child: child),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
