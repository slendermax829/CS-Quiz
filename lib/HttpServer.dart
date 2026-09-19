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

}