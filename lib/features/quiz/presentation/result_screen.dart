import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/app/theme.dart';
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
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                const SizedBox(height: 10),
                Text('Pontuacao: ${result.score}'),
                Text('Estrelas: ${result.stars}'),
                Text('Acertos: ${result.correctCount}'),
                Text('Erros: ${result.wrongCount}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(quizControllerProvider.notifier).restart();
                    context.go('/home');
                  },
                  child: const Text('Voltar para inicio'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
