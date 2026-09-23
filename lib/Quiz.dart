import 'package:c_s__quiz/Question.dart';
import 'dart:math' as math;

class Quiz 
{
  final String _name;
  final int _quizNum;
  final List<Question> _questions;

  String get name => _name;
  int get quizNum => _quizNum;
  List<Question> get questions => _questions;
  int get numOfQuestions => _questions.length;
  
  Quiz(this._name, this._quizNum, this._questions);

  Question? getQuestion(int questionNo)
  {
    return _questions.firstWhere((q) => q.qNo == questionNo, orElse: null);
  }

  List<Question> getRandOrder()
  {
    return List.from(_questions)..shuffle();
  }
}