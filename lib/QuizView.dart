import 'package:c_s__quiz/Question.dart';
import 'package:c_s__quiz/QuestionPool.dart';
import 'package:dart_console/dart_console.dart';
import 'package:ansicolor/ansicolor.dart';
import 'dart:io';

class QuizView
{
  /// Object to produce 'red' text
  static AnsiPen redPen = AnsiPen()..red();

  /// Object ot produce 'green' text
  static AnsiPen greenPen = AnsiPen()..green();

  /// Object to produce 'blue' text
  static AnsiPen bluePen = AnsiPen()..blue();

  final console = Console();

  QuizView();

  void _clearScreen() 
  {
    try{
      console.clearScreen();
      console.resetCursorPosition();
    }catch(e){
      return;
    }
  }

  String? promptForMultipleChoice(Question question, bool isPractice, int questionNum, int numOfQuestions)
  {
    while(true)
    {
      _clearScreen();

      if(isPractice)
      {
        print(bluePen('*** Practice ***\n'));
      }
      print(bluePen('Question $questionNum / $numOfQuestions\n'));

      print(bluePen(question.toString()));
      print(bluePen('\nSelect an option by number:'));

      var input = stdin.readLineSync();

      if(input == null)
      {
        continue;
      }

      var parsedInput = int.tryParse(input);

      if (parsedInput != null && parsedInput >= 1 && parsedInput <= question.options.length)
        return input; // returns this if conditions are met if not loop back
    }

  }

  String? promptForFillInBlank(Question question, bool isPractice, int questionNum, int numOfQuestions)
  {
    while(true)
    {
      _clearScreen();

      if(isPractice)
      {
        print(bluePen('*** Practice ***\n'));
      }
      print(bluePen('Question $questionNum / $numOfQuestions\n'));

      print(bluePen(question.toString()));
      print(bluePen('\nType your answer:'));

      var input = stdin.readLineSync()?.toLowerCase();

      if(input == null)
      {
        continue;
      }

      return input;
    }
  }

  void showResult(Question question, bool isCorrect)
  {
    _clearScreen();
    print(isCorrect ? greenPen('CORRECT\n') : redPen('INCORRECT\n'));

    switch(isCorrect)
    {
      case true:
        print(greenPen('Correct Answer(s): ${question.getAns()}'));
      
      case false:
        print(redPen('Correct Answer(s): ${question.getAns()}'));
    }
    sleep(Duration(seconds: 4));
  }

  int showScore(List<Question> incorrectQuestions, int finalScore, (int,int) record, bool isPractice)
  {
    var correct = record.$1;
    var total = correct + record.$2;

    while(true)
    {
      _clearScreen();
      print(bluePen('Number of Questions: $total'));
      print(bluePen('UserScore: $correct / $total'));
      print(finalScore >= 70 ? greenPen('FINAL: $finalScore') : redPen('FINAL: $finalScore\n'));

      if(isPractice)
      {
        print(bluePen('\nQuestions that were incorrect\n'));
        for(int i = 0; i < incorrectQuestions.length; i++)
        {
          print(bluePen('- Q.${i+1} Answer: ${incorrectQuestions[i].getAns()}'));
        }
      }

      print(bluePen('\nPlease make a selection by typing in a number'));
      print(bluePen('1. Retake new quiz'));
      print(bluePen('2. quit\n'));

      var input = stdin.readLineSync();

      if(input == null)
      {
        continue;
      }

      var parsedInput = int.tryParse(input);

      if(parsedInput != null && parsedInput >=1 && parsedInput <=2)
      {
        return parsedInput;
      }
    }
  }

  int displayMenu(bool isPractice)
  {
    while(true)
    {
      _clearScreen();
      print(bluePen('Select an Option!\n'));
      print(bluePen('1. Take Quiz.'));
      print(bluePen('2. Take Random Quiz'));
      print(isPractice ? bluePen('3. Disable Practice'):bluePen('3. Enable Practice'));
      print(bluePen('4. Exit'));

      print(isPractice ? greenPen('\nPRACTICE ENABLED'): '\n'"");

      var input = stdin.readLineSync();

      if(input == null)
        continue;

      var parsedInput = int.tryParse(input);

      if(parsedInput != null && parsedInput >=1 && parsedInput <=4)
      {
        return parsedInput;
      }
    }
  }

  int displayQuizzes(List<int> quizNumbers)
  {
    while(true)
    {
      _clearScreen();
      print(bluePen('Select a Quiz to Take\n'));
      for(int num in quizNumbers)
      {
        print(bluePen('* Quiz [$num]'));
      }

      print(bluePen('Type in a corresponding number.\n'));
      var input = stdin.readLineSync();

      if(input == null)
      {
        continue;
      }

      var parsedInput = int.tryParse(input);

      if(parsedInput != null && parsedInput >=1 && parsedInput <=quizNumbers.length && quizNumbers.contains(parsedInput))
      {
        return parsedInput;
      }
    }

  }

  int selectRange(int numOfQuestions)
  {
    var max = (numOfQuestions / 3).round();

    while(true)
    {
      _clearScreen();
      print(bluePen('Select a range for questions'));
      print(bluePen('Number or Questions: $numOfQuestions'));
      print(bluePen('Max Range: $max\n'));

      var input = stdin.readLineSync();

      if(input == null)
      {
        continue;
      }

      var parsedInput = int.tryParse(input);

      if(parsedInput != null && parsedInput >=1 && parsedInput <=max)
      {
        return parsedInput;
      }
    }

  }

  void displayExit() async
  {
    _clearScreen();
    print(bluePen('GoodBye :^)'));
    await Future.delayed(Duration(seconds: 2));
    _clearScreen();
  }

}
