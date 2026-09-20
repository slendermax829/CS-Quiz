import 'package:c_s__quiz/FillBlank.dart';
import 'package:c_s__quiz/MultipleChoice.dart';

enum QuestionType
{
  MULTIPLE_CHOICE,
  FILL_IN_BLANK;
}
abstract class Question 
{
  final num _qNo;

  final String _prompt;
  final QuestionType _type;

  List<String>? _choices; //optional, really used only for multiple choice only

  Question(this._qNo, this._prompt, this._type,[this._choices]);

  factory Question.fromJson(Map<String, dynamic> jsonData, num qNo)
  {
    int type = jsonData['type'];
    String prompt = jsonData['stem'];

    switch(type)
    {
      case 1:
        num answer = jsonData['answer'] as num;
        List<String> options = (jsonData['options'] as List<dynamic>).map((option) => option.toString()).toList();

        return MultipleChoice(
          qNo, 
          prompt, 
          answer, 
          options
        );

      case 2:
        List<String> answers = (jsonData['answer'] as List<dynamic>).map((option) => option.toString()).toList();

        return FillBlank(
          qNo, 
          prompt, 
          answers
        );

      default:
        throw 'Unknown question type: $type';
    }

  }

  num get qNo => _qNo;
  String get prompt => _prompt;
  String get type => _type.name.toLowerCase();
  List<String> get choices => _choices ?? [];

  set choices(List<String> newChoices) => _choices = newChoices;

  num get typeNum
  {
    switch(_type.name.toLowerCase())
    {
      case 'multiple_choice':
        return 1;

      case 'fill_in_blank':
        return 2;

      default:
        return -1;
    }
  }

  @override
  bool operator ==(Object o)
  {
    if(o is! Question)
      return false;

    if(o._qNo != this._qNo)
      return false;

    return true;
  } 

  @override
  String toString();

  String getAns();

  bool checkAns();

}