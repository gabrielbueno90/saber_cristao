import 'package:flutter/material.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/shared/widgets/brand_mark.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.backgroundDark, AppTheme.primaryBrown],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BrandMark(size: 104),
              SizedBox(height: 16),
              Text(
                'Saber Cristão',
                style: TextStyle(
                  color: AppTheme.softGold,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Estudo bíblico em forma de desafio',
                style: TextStyle(
                  color: AppTheme.cream,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 14),
              CircularProgressIndicator(color: AppTheme.softGold),
            ],
          ),
        ),
      ),
    );
  }
}
