import 'dart:convert';
import 'package:c_s__quiz/Question.dart';
import 'package:c_s__quiz/Controller.dart';
import 'package:http/http.dart' as http;

class HttpServer 
{
  static const baseURL = 'https://www.cs.utep.edu/cheon/cs4381/homework/quiz/';
  static const quizRange = 99;
  
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

  static Future<Map<num,List<Question>>> fetchQuizes() async
  {
    Map<num,List<Question>> pool = {};

    for(num i = 1; i <= quizRange; i++)
    {
      try{
        if(!(await _validateQuiz(i)))
        {
          continue;
        }
        var quizResponse = await _fetchQuiz(i);
        pool[quizResponse.quizNo] = quizResponse.questions;

      }catch(e){
        throw 'An error had occured trying to fetch quizzes: $e';
      }
    }
    return pool;
  }

  static Future<bool> _validateQuiz(num quizNumber) async
  {
    var url = Uri.parse('$baseURL?quiz=quiz${quizNumber.toString().padLeft(2,'0')}');
    var response = await http.get(url);

    var jsonData = jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true)) as Map<String, dynamic>;

    if(jsonData['response'] == false)
    {
      print('${jsonData['reason']}');
      return false;
    }

    return true;

  }

  static Future<({num quizNo, List<Question> questions})>
  _fetchQuiz(num quizNumber) async
  {
    var url = Uri.parse('$baseURL?quiz=quiz${quizNumber.toString().padLeft(2,'0')}');
    print(url);

    var response = await http.get(url);

    if(response.statusCode != 200)
    {
      throw 'Failed to retrieve quiz: ${response.statusCode}';
    }

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

    var questions = questionList.asMap().entries.map((qEntry) {
      return Question.fromJson(
        qEntry.value as Map<String, dynamic>, 
        qEntry.key + 1
      );
    }).toList();

    return(quizNo:quizNumber, questions: questions);
  }

  static Future<({num quizNo, List<Question> questions})> testFetch(num quizNum) async => await _fetchQuiz(quizNum); // for test purposes

}