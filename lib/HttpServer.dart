import 'dart:convert';
import 'package:console_bars/console_bars.dart';
import 'package:c_s__quiz/Question.dart';
import 'package:c_s__quiz/Controller.dart';
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
      print(Controller.redPen('CONNECTION Failed'));
      print(Controller.redPen('Status Code ${response.statusCode}'));
      
      return false;
    }

    print(Controller.greenPen('CONNECTION SUCCESSFUL'));
    return true;
  }
  /// Creates a [Map<num, List<Question>>] for the pool of questions
  /// Where [num] is the Quiz No and [List<Question>] is the list of questions that belong with the quiz
  static Future<Map<num,List<Question>>> fetchQuizzes() async
  {
    Map<num,List<Question>> pool = {};
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
        pool[quizResponse.quizNo] = quizResponse.questions;
        //bar.increment();

      }catch(e)
      {
        throw 'An error had occured trying to fetch quizzes: $e';
      }
    }
    print(Controller.greenPen('\nCOMPLETE\n'));
    return pool;
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
      //print('${jsonData['reason']}');
      return false;
    }
    return true;
  }

  /// Private Function where it returns a Record [{num quizNo, List<Question> questions}] from reading jsonData
  /// This acts as a helper function for [fetchQuizzes()] to add the record to the pool of questions
  /// 
  /// [quizNumber] is the quiz number to retrieve the quiz as well as its questions
  static Future<({num quizNo, List<Question> questions})>
  _fetchQuiz(num quizNumber) async
  {
    var url = Uri.parse('$baseURL?quiz=quiz${quizNumber.toString().padLeft(2,'0')}');
    //print(url);

    var response = await http.get(url);

    if(response.statusCode != 200)
    {
      throw 'Failed to retrieve quiz: ${response.statusCode}';
    }

    // A better way to decode the json response data since some data uses different form of characters that might cause a crash
    var jsonData = jsonDecode(
      utf8.decode(response.bodyBytes, allowMalformed: true),
    ) as Map<String,dynamic>;

    //var jsonData = jsonDecode(response.body) as Map<String,dynamic>;

    if(jsonData['response'] != true)
    {
      String reason = jsonData['reason'].toString();

      if(reason.toLowerCase().contains('not found'))
      {
        throw 'Quiz: $quizNumber not found.';
      }

      throw 'Response returned ${jsonData['response']}, Reason: $reason';
    }

    var quizData = jsonData['quiz'] as Map<String,dynamic>;

    List<dynamic> questionList = quizData['questions'];

    if(questionList.isEmpty)
    {
      throw 'Quiz is missing the questions array from response';
    }

    // creates a List<Question> variable where each value is transformed to a Question value using the factory constructor
    var questions = questionList.asMap().entries.map((qEntry) {
      return Question.fromJson(
        qEntry.value as Map<String, dynamic>, // sub jsonData for questions
        qEntry.key + 1 // question number
      );
    }).toList();

    return(quizNo:quizNumber, questions: questions);
  }
  
  /// Testing function that gets one record
  /// [quizNum] is the quiz number to retrieve the quiz as well as its questions
  static Future<({num quizNo, List<Question> questions})> testFetch(num quizNum) async => await _fetchQuiz(quizNum); // for test purposes

}