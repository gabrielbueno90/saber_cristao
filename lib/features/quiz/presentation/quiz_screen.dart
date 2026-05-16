import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/features/lives/presentation/lives_controller.dart';
import 'package:saber_cristao/features/progress/presentation/progress_controller.dart';
import 'package:saber_cristao/features/quiz/presentation/quiz_controller.dart';

class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(quizControllerProvider);
    final controller = ref.read(quizControllerProvider.notifier);
    final lives = ref.watch(livesControllerProvider);
    final question = controller.currentQuestion;

    if (lives <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/out-of-lives');
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text('Fase ${session.level}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  question.question,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(question.options.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton(
                  onPressed: () async {
                    final result = controller.answer(index);
                    final isLast = controller.isLastQuestion;
                    if (index != question.correctIndex) {
                      await ref.read(livesControllerProvider.notifier).loseLife();
                      final newLives = ref.read(livesControllerProvider);
                      if (!context.mounted) return;
                      if (newLives <= 0) {
                        context.go('/out-of-lives');
                        return;
                      }
                    }
                    if (!context.mounted) return;
                    if (isLast) {
                      await ref
                          .read(progressControllerProvider.notifier)
                          .applyQuizResult(
                            stars: result.stars,
                            score: result.score,
                            completed: true,
                          );
                      if (!context.mounted) return;
                      context.go('/result', extra: result);
                    }
                  },
                  child: Text(question.options[index]),
                ),
              );
            }),
            const Spacer(),
            Text(
              'Referencia: ${question.bibleReference}',
              style: const TextStyle(color: AppTheme.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
