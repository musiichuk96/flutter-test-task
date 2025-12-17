import 'package:flutter/material.dart';
import '../models/quiz_result.dart';
import '../services/storage_service.dart';
import 'home_screen.dart';

class ResultsScreen extends StatefulWidget {
  final int correctAnswers;
  final int totalQuestions;

  const ResultsScreen({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _saveResult();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _saveResult() async {
    final result = QuizResult(
      dateTime: DateTime.now(),
      totalQuestions: widget.totalQuestions,
      correctAnswers: widget.correctAnswers,
    );
    await StorageService.saveQuizResult(result);
  }

  String _getResultMessage() {
    final percentage = (widget.correctAnswers / widget.totalQuestions) * 100;
    if (percentage >= 80) {
      return 'Excellent! 🎉';
    } else if (percentage >= 60) {
      return 'Good Job! 👍';
    } else if (percentage >= 40) {
      return 'Not Bad! 😊';
    } else {
      return 'Keep Practicing! 💪';
    }
  }

  Color _getResultColor() {
    final percentage = (widget.correctAnswers / widget.totalQuestions) * 100;
    if (percentage >= 80) {
      return Colors.green;
    } else if (percentage >= 60) {
      return Colors.blue;
    } else if (percentage >= 40) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.correctAnswers / widget.totalQuestions) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getResultColor().withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.emoji_events,
                      size: 80,
                      color: _getResultColor(),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  _getResultMessage(),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _getResultColor(),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'You got ${widget.correctAnswers} out of ${widget.totalQuestions} correct!',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: _getResultColor(),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Home'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/history',
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.history),
                      label: const Text('History'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

