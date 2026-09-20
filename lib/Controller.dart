import 'dart:io';
import 'package:ansicolor/ansicolor.dart';
import 'package:c_s__quiz/HttpServer.dart';

class Controller 
{
  static AnsiPen redPen = AnsiPen()..red();
  static AnsiPen greenPen = AnsiPen()..green();
  static AnsiPen bluePen = AnsiPen()..blue();

  Future<void> init() async
  {
    try{
        var conn = await HttpServer.vailidateConnection();

        if(!conn)
          exit(1);

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