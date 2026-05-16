import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/features/quiz/domain/quiz_result_model.dart';
import 'package:saber_cristao/features/quiz/presentation/quiz_controller.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key, required this.result});

  final QuizResultModel result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Resultado da fase',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                AppSpacing.v16,
                Text('Pontuação: ${result.score}'),
                AppSpacing.v8,
                Text('Estrelas: ${result.stars}'),
                AppSpacing.v8,
                Text('Acertos: ${result.correctCount}'),
                AppSpacing.v8,
                Text('Erros: ${result.wrongCount}'),
                AppSpacing.v24,
                ElevatedButton(
                  onPressed: () {
                    ref.read(quizControllerProvider.notifier).restart();
                    context.go('/home');
                  },
                  child: const Text('Voltar para início'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
