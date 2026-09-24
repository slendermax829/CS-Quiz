import 'package:c_s__quiz/Question.dart';

/// An extension class from Question where it handles fill in the blank logic
class FillBlank extends Question
{
  final List<String> ans;

  FillBlank(num qNo, String prompt, this.ans)
      : super(qNo, prompt, QuestionType.FILL_IN_BLANK);

  @override
  String toString()
  {
    return '''
  $qNo. ${prompt}\n
  ''';
  }

  @override
  String getAns() 
  {
    //return ans.toString();
    return 'Anwers: ${ans.map((a)=> '$a ').toString()}';
  }

  @override
  bool checkAns(String? input) 
  {
    var answers = ans.map((a) => a.toLowerCase()).toList();

    return input != null && answers.contains(input); 
  }

}