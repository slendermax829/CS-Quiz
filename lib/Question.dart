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

  List<String>? _choices; //optional, really used only for multiple choice 

  Question(this._qNo, this._prompt, this._type,[this._choices]);

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