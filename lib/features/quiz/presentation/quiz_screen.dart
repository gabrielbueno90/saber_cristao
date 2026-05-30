import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/features/lives/presentation/lives_controller.dart';
import 'package:saber_cristao/features/progress/presentation/progress_controller.dart';
import 'package:saber_cristao/features/quiz/domain/quiz_result_model.dart';
import 'package:saber_cristao/features/quiz/presentation/quiz_controller.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, this.initialLevel});

  final int? initialLevel;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int? _selectedIndex;
  QuizResultModel? _pendingResult;
  bool _submittingResult = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLevel != null) {
      Future<void>.microtask(
        () => ref.read(quizControllerProvider.notifier).loadLevel(widget.initialLevel!),
      );
    }
  }

  Future<bool> _confirmExit() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sair do desafio'),
          content: const Text(
            'Deseja sair do desafio? Seu progresso desta rodada será perdido.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Continuar jogando'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Sair para início'),
            ),
          ],
        );
      },
    );
    return leave ?? false;
  }

  Future<void> _exitQuiz() async {
    final leave = await _confirmExit();
    if (!mounted || !leave) return;
    ref.read(quizControllerProvider.notifier).restart();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(quizControllerProvider);
    final controller = ref.read(quizControllerProvider.notifier);
    final lives = ref.watch(livesControllerProvider);
    if (!controller.hasQuestions) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final question = controller.currentQuestion;

    if (lives <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/out-of-lives');
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _exitQuiz();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fase ${session.level}'),
          leading: IconButton(
            onPressed: _exitQuiz,
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Voltar para início',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  question.question,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            AppSpacing.v16,
            if (kDebugMode && controller.loadWarning != null) ...[
              Text(
                controller.loadWarning!,
                style: const TextStyle(color: AppTheme.error),
              ),
              AppSpacing.v12,
            ],
            if (kDebugMode) ...[
              Text(
                controller.questionsFromSupabase
                    ? 'Perguntas: Supabase | dificuldade ${controller.expectedDifficulty} | ${controller.expectedQuestionCount} perguntas'
                    : 'Perguntas: mock',
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                ),
              ),
              AppSpacing.v12,
            ],
            ...List.generate(question.options.length, (index) {
              final selected = _selectedIndex == index;
              final answered = _selectedIndex != null;
              final correct = question.correctIndex == index;
              final foreground = answered
                  ? (correct
                      ? AppTheme.success
                      : (selected ? AppTheme.error : AppTheme.darkBrown))
                  : null;

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: OutlinedButton(
                  onPressed: answered
                      ? null
                      : () async {
                          final result = controller.evaluateAnswer(index);
                          if (index != question.correctIndex) {
                            await ref.read(livesControllerProvider.notifier).loseLife();
                            await ref.read(progressControllerProvider.notifier).syncToRemote();
                            final newLives = ref.read(livesControllerProvider);
                            if (!context.mounted) return;
                            if (newLives <= 0) {
                              context.go('/out-of-lives');
                              return;
                            }
                          }
                          setState(() {
                            _selectedIndex = index;
                            _pendingResult = result;
                          });
                        },
                  child: Text(
                    question.options[index],
                    style: TextStyle(color: foreground),
                  ),
                ),
              );
            }),
            if (_selectedIndex != null) ...[
              AppSpacing.v12,
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedIndex == question.correctIndex ? 'Resposta correta!' : 'Resposta incorreta.',
                        style: TextStyle(
                          color: _selectedIndex == question.correctIndex ? AppTheme.success : AppTheme.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      AppSpacing.v8,
                      Text(question.explanation),
                    ],
                  ),
                ),
              ),
              AppSpacing.v12,
              ElevatedButton(
                onPressed: _submittingResult
                    ? null
                    : () async {
                        setState(() => _submittingResult = true);
                  final result = _pendingResult!;
                  final wasLast = controller.isLastQuestion;
                  controller.advanceWithResult(result);
                  if (wasLast) {
                    await ref.read(progressControllerProvider.notifier).applyQuizResult(
                          level: result.level,
                          stars: result.stars,
                          score: result.score,
                          completed: result.stars > 0,
                        );
                    await controller.recordAttempt(result);
                    if (!context.mounted) return;
                    context.go('/result', extra: result);
                    return;
                  }
                  setState(() {
                    _selectedIndex = null;
                    _pendingResult = null;
                    _submittingResult = false;
                  });
                },
                child: Text(controller.isLastQuestion ? 'Ver resultado' : 'Próxima pergunta'),
              ),
            ],
            const Spacer(),
            Text(
              'Referência: ${question.bibleReference}',
              style: const TextStyle(color: AppTheme.textMuted),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
