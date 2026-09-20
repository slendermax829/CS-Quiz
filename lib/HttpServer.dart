import 'dart:convert';
import 'package:c_s__quiz/Question.dart';
import 'package:c_s__quiz/Controller.dart';
import 'package:http/http.dart' as http;

class HttpServer 
{
  static const baseURL = 'https://www.cs.utep.edu/cheon/cs4381/homework/quiz/';
  
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

  static Future<({num quizNo, List<Question> questions})>
  fetchQuiz(num quizNumber) async
  {
    var url = Uri.parse('$baseURL?quiz=quiz${quizNumber.toString().padLeft(2,'0')}');
    var response = await http.get(url);

    if(response.statusCode != 200)
    {
      throw 'Failed to retrieve quiz: ${response.statusCode}';
    }

    var jsonData = jsonDecode(response.body) as Map<String,dynamic>;

    if(jsonData['response'] != true)
    {
      throw 'Response returned ${jsonData['response']}, Reason: ${jsonData['reason']}';
    }

    var quizData = jsonData['quiz'] as Map<String,dynamic>;

    String quizName = quizData['name'];
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

}