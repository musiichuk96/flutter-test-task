class QuizResult {
  final DateTime dateTime;
  final int totalQuestions;
  final int correctAnswers;
  final double percentage;

  QuizResult({
    required this.dateTime,
    required this.totalQuestions,
    required this.correctAnswers,
  }) : percentage = (correctAnswers / totalQuestions) * 100;

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'percentage': percentage,
    };
  }

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      dateTime: DateTime.parse(json['dateTime']),
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
    );
  }
}

