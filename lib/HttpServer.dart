import 'dart:convert';
import 'package:c_s__quiz/Quiz.dart';
import 'package:console_bars/console_bars.dart';
import 'package:c_s__quiz/Question.dart';
import 'package:c_s__quiz/Controller.dart';
import 'package:c_s__quiz/QuizView.dart';
import 'package:http/http.dart' as http;

/// The service used to retrieve quiz response data from the provided API
class HttpServer 
{
  /// The url that will be used to navigate the api
  static const baseURL = 'https://www.cs.utep.edu/cheon/cs4381/homework/quiz/';

  /// The range of quizzes that will be retrieved through response
  static const quizRange = 99;
  
  /// Validates the connection by checking the url to the API
  static Future<bool> vailidateConnection() async
  {
    var url = Uri.parse(baseURL);
    var response = await http.get(url);

    if(response.statusCode != 200)
    {
      print(QuizView.redPen('CONNECTION Failed'));
      print(QuizView.redPen('Status Code ${response.statusCode}'));
      
      return false;
    }

    print(QuizView.greenPen('CONNECTION SUCCESSFUL\n'));
    return true;
  }

  /// Creates a [Map<num, List<Question>>] for the pool of questions
  /// Where [num] is the Quiz No and [List<Question>] is the list of questions that belong with the quiz
  static Future<List<Quiz>> fetchQuizzes() async
  {
    List<Quiz> quizList = [];
    //final bar = FillingBar(total: quizRange, desc: 'Fetching Quizzes', time: false, percentage: true, scale: 0.2, fill: '#');

    for(int i = 1; i <= quizRange; i++)
    {
      try
      {
        if(!(await _validateQuiz(i)))
        {
          //bar.increment();
          continue;
        }

        var quizResponse = await _fetchQuiz(i);
        quizList.add(quizResponse);
        //bar.increment();

      }catch(e)
      {
        throw 'An error had occured trying to fetch quizzes: $e';
      }
    }
    print(QuizView.greenPen('\nCOMPLETE\n'));
    return quizList;
  }

  /// Checks wether the quiz is found or not from the response
  /// [quizNumber] is the quiz number to be checked
  static Future<bool> _validateQuiz(num quizNumber) async
  {
    var url = Uri.parse('$baseURL?quiz=quiz${quizNumber.toString().padLeft(2,'0')}');
    var response = await http.get(url);

    var jsonData = jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true)) as Map<String, dynamic>;

    if(jsonData['response'] == false)
    {
      print(QuizView.redPen('Quiz: $quizNumber not retrieved, Reason: ${jsonData['reason']}'));
      //print('${jsonData['reason']}');
      return false;
    }
    print(QuizView.greenPen('Quiz: $quizNumber retrieved.'));
    return true;
  }

  static Future<Quiz>
  _fetchQuiz(int quizNumber) async
  {
    var url = Uri.parse('$baseURL?quiz=quiz${quizNumber.toString().padLeft(2,'0')}');
    var response = await http.get(url);

    if(response.statusCode != 200)
      throw 'Failed to retrieve data: ${response.statusCode}';

    var jsonData = jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true)) as Map<String, dynamic>;

    if(jsonData['response'] != true)
    {
      String reason = jsonData['reason'].toString();
      throw 'Quiz: $quizNumber not found';
    }

    var quizData = jsonData['quiz'] as Map<String, dynamic>;

    List<dynamic> questionList = quizData['questions'];

    if(questionList.isEmpty)
    {
      throw 'Quiz is missing the List of Questions from response';
    }

    List<Question> questions = questionList.asMap().entries.map((q){
      return Question.fromJson(
        q.value as Map<String, dynamic>,
        q.key + 1
      );
    }).toList();

    var name = quizData['name'] as String;

    Quiz newQuiz = Quiz(name, quizNumber, questions);

    return newQuiz;
  }

  static Future<Quiz> testFetch(int quizNum) async => await _fetchQuiz(quizNum);
}