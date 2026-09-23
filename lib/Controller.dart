import 'dart:io';
import 'package:ansicolor/ansicolor.dart';
import 'package:c_s__quiz/HttpServer.dart';
import 'package:c_s__quiz/Hud.dart';
import 'package:c_s__quiz/QuestionPool.dart';
import 'package:c_s__quiz/Question.dart';

/// Controller class to load quiz data and running the mainloop
class Controller 
{
   /// flag to specify if a test/quiz is practice only
  static bool isPractice = false;

  /// Source of loaded quiz questions
  final qPool = QuestionPool();
  final ui = Hud();

  late List<Question> subset;
  
  /// Validates connectivity, fetches the quiz, and loads it into the pool.
  Future<void> init() async
  {
    try{
        var conn = await HttpServer.vailidateConnection();

        if(!conn)
        {
          exit(1);
        }

      await qPool.populatePool();
      print(Hud.bluePen('Loaded ${qPool.numOfQuestions} questions from ${qPool.numOfQuizzes}'));
      quit();
      //mainLoop();

      }catch(e){
        throw 'An error has occurred $e';
      }
  }

  /// The main loop for user to engage with.
  ///
  /// Repeatedly asks questions until the player either finishes or quits.
  void mainLoop()
  {
      print(Hud.bluePen('This is a Test main loop lol'));
      
  }
  
  void quit()
  {
    print(Hud.redPen('This is the exit bye...'));

  }
}