import 'dart:io';
import 'package:ansicolor/ansicolor.dart';
import 'package:c_s__quiz/HttpServer.dart';
import 'package:c_s__quiz/QuestionPool.dart';

class Controller 
{
  static AnsiPen redPen = AnsiPen()..red();
  static AnsiPen greenPen = AnsiPen()..green();
  static AnsiPen bluePen = AnsiPen()..blue();

  QuestionPool qPool = QuestionPool();

  Future<void> init() async
  {
    try{
        var conn = await HttpServer.vailidateConnection();

        if(!conn)
          exit(1);

      await qPool.populatePool();
      mainLoop();

      }catch(e){
        throw 'An error has occurred $e';
      }
  }

  void mainLoop()
  {

    print(bluePen('This is the main loop'));

  }
}