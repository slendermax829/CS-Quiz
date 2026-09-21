import 'dart:math' as math;
import 'package:c_s__quiz/HttpServer.dart';
import 'package:c_s__quiz/Question.dart';

class QuestionPool 
{
  Map<num, List<Question>> _quizQuestions = {};

  /// returns the number of overall quizzes from the pool
  int get numOfQuizzes => _quizQuestions.length;

  /// returns the number of questions from the pool
  int get numOfQuestions => _quizQuestions.values.fold(0, (total, questions) => total + questions.length);

  /// returns a list of quiz numbers 
  List<num> get quizzes => _quizQuestions.keys.toList();

  QuestionPool();

  /// populate the pool by retrieving http response data
  Future<void> populatePool() async
  {
    if(_quizQuestions.isEmpty)
      _quizQuestions = await HttpServer.fetchQuizzes();

  }

  /// returns a subset of questions from a certain [quizNo]
  List<Question> getFromQuiz(num quizNo)
  {
    var questions = _quizQuestions[quizNo];

    if (questions == null || questions.isEmpty)
    {
      throw 'Quiz not found: $quizNo';
    }
    return questions;
  }

  @Deprecated('Use either getFromQuiz() or getRandQuestions()')
  Question getQuestion(num quizNo, num questionNo)
  {
    var questions = _quizQuestions[quizNo];

    if (questions == null || questions.isEmpty)
    {
      throw 'Quiz not found: $quizNo';
    }

    return questions.firstWhere((question) => question.qNo == questionNo);

  }

  /// returns a subset of random question given a certain range
  /// 
  /// [range] default value is set to 10
  List<Question> getRandQuestions({int range = 10})
  {
    if (_quizQuestions.isEmpty)
    {
      throw 'Question pool is empty';
    }

    if(range > 30)
    {
      range = 30;
    }

    List<Question> questions = [];
    Set<Record> routlette = {};

    final quizNumbers = this.quizzes;

    var quizRNG = math.Random();
    var questRNG = math.Random();

    for(int i = 0; i < range; i++)
    {
      while(true)
      {
        var quizIndex = quizRNG.nextInt(quizNumbers.length);
        var quizDraw = quizNumbers[quizIndex];

        var quizQuestions = _quizQuestions[quizDraw]!;
        var questionDraw = questRNG.nextInt(quizQuestions.length);

        var entry = (quizDraw,questionDraw);

        if(!routlette.contains(entry))
        {
          routlette.add(entry);
          questions.add(quizQuestions[questionDraw]);
          break;
        }
      }
    }

    return questions;
  }
}