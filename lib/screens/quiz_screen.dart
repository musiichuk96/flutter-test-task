import 'package:flutter/material.dart';
import '../models/question.dart';
import '../data/quiz_data.dart';
import 'results_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late List<Question> _questions;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _questions = QuizData.getQuestions();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswerIndex = index;
      _isAnswered = true;
      if (index == _questions[_currentQuestionIndex].correctAnswerIndex) {
        _correctAnswers++;
      }
    });

    // Wait a moment to show the result, then move to next question
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _isAnswered = false;
      });
      _animationController.reset();
      _animationController.forward();
    } else {
      // Quiz completed, navigate to results
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            correctAnswers: _correctAnswers,
            totalQuestions: _questions.length,
          ),
        ),
      );
    }
  }

  Color _getAnswerColor(int index) {
    if (!_isAnswered) {
      return _selectedAnswerIndex == index
          ? Colors.deepPurple.shade300
          : Colors.grey.shade200;
    }

    if (index == _questions[_currentQuestionIndex].correctAnswerIndex) {
      return Colors.green.shade400;
    } else if (index == _selectedAnswerIndex &&
        index != _questions[_currentQuestionIndex].correctAnswerIndex) {
      return Colors.red.shade400;
    }
    return Colors.grey.shade200;
  }

  IconData? _getAnswerIcon(int index) {
    if (!_isAnswered) return null;

    if (index == _questions[_currentQuestionIndex].correctAnswerIndex) {
      return Icons.check_circle;
    } else if (index == _selectedAnswerIndex &&
        index != _questions[_currentQuestionIndex].correctAnswerIndex) {
      return Icons.cancel;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Progress bar
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.deepPurple,
                ),
                minHeight: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Question text
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            question.questionText,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Answer options
                      Expanded(
                        child: ListView.builder(
                          itemCount: question.options.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: ElevatedButton(
                                  onPressed: () => _selectAnswer(index),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _getAnswerColor(index),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: _isAnswered ? 2 : 4,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          question.options[index],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      if (_getAnswerIcon(index) != null)
                                        Icon(
                                          _getAnswerIcon(index),
                                          size: 28,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

