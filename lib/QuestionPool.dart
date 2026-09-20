
import 'package:c_s__quiz/Question.dart';

class QuestionPool 
{
  final Map<num, List<Question>> _quizQuestions = {};

  num get numOfQuizzes => _quizQuestions.length;
  num get numOfQuestions => _quizQuestions.values.fold(0, (total, questions) => total + questions.length);

  QuestionPool();

  void addQuestions(num quizNo, List<Question> questions)
  {
    if(_quizQuestions.containsKey(quizNo))
      return;

    _quizQuestions[quizNo] = List.unmodifiable(questions); // questions should not be changed ever

  }

  List<Question> getQuestionsFromQuiz(num quizNo)
  {
    var questions = _quizQuestions[quizNo];

    if (questions == null || questions.isEmpty)
    {
      throw 'Quiz not found: $quizNo';
    }

    return questions;
  }
}