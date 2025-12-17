import '../models/question.dart';

class QuizData {
  static List<Question> getQuestions() {
    return [
      Question(
        questionText: 'What is the capital of France?',
        options: ['London', 'Berlin', 'Paris', 'Madrid'],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: 'Which planet is known as the Red Planet?',
        options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: 'What is 2 + 2?',
        options: ['3', '4', '5', '6'],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: 'Who painted the Mona Lisa?',
        options: ['Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Michelangelo'],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: 'What is the largest ocean on Earth?',
        options: ['Atlantic Ocean', 'Indian Ocean', 'Arctic Ocean', 'Pacific Ocean'],
        correctAnswerIndex: 3,
      ),
      Question(
        questionText: 'In which year did World War II end?',
        options: ['1943', '1944', '1945', '1946'],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: 'What is the chemical symbol for gold?',
        options: ['Go', 'Gd', 'Au', 'Ag'],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: 'Which programming language is Flutter primarily based on?',
        options: ['Java', 'Dart', 'Python', 'JavaScript'],
        correctAnswerIndex: 1,
      ),
    ];
  }
}

