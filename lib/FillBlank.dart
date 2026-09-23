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
    return ans.toString();
    
  }

  @override
  bool checkAns(String? input) {
    return input != null && ans.contains(input); 
  }

}