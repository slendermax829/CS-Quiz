
import 'dart:math' as math;
import 'package:c_s__quiz/HttpServer.dart';
import 'package:c_s__quiz/Question.dart';
import "package:c_s__quiz/Quiz.dart";

class QuestionPool 
{
  List<Quiz> _quizzes = [];
  List<Question> _questions = [];

  int get numOfQuizzes => _quizzes.length;
  int get numOfQuestions => _questions.length;

  QuestionPool();

  Future<void> populatePool() async
  {
    try{
      if(_quizzes.isEmpty || _questions.isEmpty)
      {
        _quizzes.clear();
        _questions.clear();
      }

      _quizzes = await HttpServer.fetchQuizzes();

      for(int i = 0; i < _quizzes.length; i++)
      {
        var currQuestions = _quizzes[i].questions;
        _questions.addAll(currQuestions);
      }
    }catch(e){
      throw 'Could not fill the pool from http server: $e';
    }
  }

  List<Question>? getListFromQuiz(int quizNum)
  {
    var quiz = _quizzes.where((q) => q.quizNum == quizNum).firstOrNull;

    if(quiz == null)
    {
      return null;
    }

    return quiz.questions;
  }

  List<Question>? getRandQuestions({int range = 10})
  {
    if(range <= 0 || range > _questions.length)
    {
      return null;
    }

    var random = List<Question>.from(_questions);
    random.shuffle();

    return random.sublist(0, range);

  }

  Question getQuestion({required int quizNo, required int questionNo})
  {
    var quiz = _quizzes.firstWhere((q)=> q.quizNum == quizNo);

    return quiz.questions.firstWhere((qu)=> qu.qNo == questionNo);
  }

  Question getRandQuestion()
  {
    var random = math.Random();

    return _questions[random.nextInt(numOfQuestions)];
  }
  
}