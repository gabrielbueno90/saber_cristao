import 'package:flutter/material.dart';
import 'package:saber_cristao/app/theme.dart';

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
              Text(
                'Saber Cristao',
                style: TextStyle(
                  color: AppTheme.softGold,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              CircularProgressIndicator(color: AppTheme.softGold),
            ],
          ),
        ),
      ),
    );
  }
}
