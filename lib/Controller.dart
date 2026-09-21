import 'dart:io';
import 'package:ansicolor/ansicolor.dart';
import 'package:c_s__quiz/HttpServer.dart';
import 'package:c_s__quiz/QuestionPool.dart';

/// Controller class to load quiz data and running the mainloop
class Controller 
{
  /// Object to produce 'red' text
  static AnsiPen redPen = AnsiPen()..red();

  /// Object ot produce 'green' text
  static AnsiPen greenPen = AnsiPen()..green();

  /// Object to produce 'blue' text
  static AnsiPen bluePen = AnsiPen()..blue();

  /// Source of loaded quiz questions
  final qPool = QuestionPool();

  /// flag to specify if a test/quiz is practice only
  bool isPractice = false;
  
  /// Validates connectivity, fetches the quiz, and loads it into the pool.
  Future<void> init() async
  {
    try{
        var conn = await HttpServer.vailidateConnection();

        if(!conn)
          exit(1);

      await qPool.populatePool();
      print(bluePen('Loaded ${qPool.numOfQuestions} questions from ${qPool.numOfQuizzes}'));
      mainLoop();

      }catch(e){
        throw 'An error has occurred $e';
      }
  }

  /// The main loop for user to engage with.
  ///
  /// Repeatedly asks questions until the player either finishes or quits.
  void mainLoop()
  {
    print(bluePen('This is the main loop'));
  }
}