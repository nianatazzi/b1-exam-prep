/// Результат одного упражнения — хранится только в памяти во время прохождения субпарта.
/// Используется для ResultScreen и последующей записи агрегата в Firestore.
class ExerciseResult {
  final String exerciseId;
  final bool isCorrect;
  final List<String> grammarTypes;
  final String userAnswer;
  final String correctAnswer;
  final String? question;

  const ExerciseResult({
    required this.exerciseId,
    required this.isCorrect,
    required this.grammarTypes,
    required this.userAnswer,
    required this.correctAnswer,
    this.question,
  });
}
