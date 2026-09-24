import 'dart:io';
import 'package:c_s__quiz/HttpServer.dart';
import 'package:c_s__quiz/QuizView.dart';
import 'package:c_s__quiz/QuestionPool.dart';
import 'package:c_s__quiz/Question.dart';

/// Controller class to load quiz data and running the mainloop
class Controller 
{
   /// flag to specify if a test/quiz is practice only
  bool isPractice = false;

  /// Source of loaded quiz questions
  late QuestionPool _qPool;
  late QuizView _view;

  late bool _isNumberedQuiz;

  List<Question>? _subSet;

  Controller();
  
  /// Validates connectivity, fetches the quiz, and loads it into the pool.
  Future<void> init() async
  {
    try{
        var conn = await HttpServer.vailidateConnection();

        if(!conn)
        {
          exit(1);
        }

      _qPool = QuestionPool();
      await _qPool.populatePool();

      print(QuizView.bluePen('Loaded ${_qPool.numOfQuestions} questions from ${_qPool.numOfQuizzes}'));

      _initializeMenu();

      }catch(e){
        throw 'An error has occurred $e';
      }
  }

  void _initializeMenu()
  {
    _view = QuizView();
    
    int menuChoice = _view.displayMenu(isPractice);

    if(menuChoice == 1)
    {
      int quizChoice = _view.displayQuizzes(_qPool.quizNumbers);
      _isNumberedQuiz = true;
      setUpQuiz(quizChoice: quizChoice);
      mainLoop();
      return;
    }

    if(menuChoice == 2)
    {
      int randRange = _view.selectRange(_qPool.numOfQuestions);
      _isNumberedQuiz = false;
      setUpQuiz(randRange: randRange);
      mainLoop();
      return;
    }

    if(menuChoice == 3)
    {
      isPractice = !isPractice;
      _initializeMenu();
      return;
    }

    _quit();
  }

  void setUpQuiz({int? quizChoice, int? randRange})
  {
    if(_isNumberedQuiz && quizChoice != null)
    {
      _subSet = _qPool.getListFromQuiz(quizChoice) ?? <Question>[];
    }else{
      if(randRange != null)
      {
        _subSet = _qPool.getRandQuestions(range: randRange) ?? <Question>[];
      }
    }
  }

  /// The main loop for user to engage with.
  ///
  /// Repeatedly asks questions until the player finishes.
  void mainLoop()
  {
      var questions = _subSet;

      if(questions == null || questions.isEmpty)
      {
        print(QuizView.redPen('No questions were loaded for the selected quiz.'));
        _initializeMenu();
        return;
      }

      var score = 0;
      var questionNum = 1;
      var numOfQuestions = questions.length;

      List<Question> incorrectQuestions = [];

      while(true)
      {
        String? userAns;
        var nextQuestion = questions[questionNum-1];

        switch(nextQuestion.type)
        {
          case 'multiple_choice':
           userAns = _view.promptForMultipleChoice(
              nextQuestion,
              isPractice,
              questionNum,
              numOfQuestions);
           break;

          case 'fill_in_blank':
           userAns = _view.promptForFillInBlank(
              nextQuestion,
              isPractice,
              questionNum,
              numOfQuestions);
           break;
        }

        bool isCorrect = nextQuestion.checkAns(userAns ?? '');

        if(isCorrect)
        {
          score++;
        }
        else
        {
          incorrectQuestions.add(nextQuestion);
        }

        if(isPractice)
        {
          _view.showResult(nextQuestion, isCorrect);
        }

        if(questionNum == questions.length)
        {
          break;
        }
        questionNum++;
      }

    _getResults(score, incorrectQuestions);

  }

  void _getResults(int score, List<Question> incorrectQuestions)
  {
    var finalScore = ((score/_subSet!.length) * 100).round();
    var correctNum = _subSet!.length - incorrectQuestions.length;
    var incorrectNum = incorrectQuestions.length;

    int choice = _view.showScore(incorrectQuestions, finalScore, (correctNum,incorrectNum), isPractice);

    if(choice == 1)
    {
      _initializeMenu();
      return;
    }

    _quit();

  }
  
  void _quit()
  {
    _view.displayExit();
  }
}