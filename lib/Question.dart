import 'package:c_s__quiz/FillBlank.dart';
import 'package:c_s__quiz/MultipleChoice.dart';

/// Describes the supported quiz question variants.
enum QuestionType
{
  MULTIPLE_CHOICE,
  FILL_IN_BLANK;
}

/// Base type for quiz questions parsed from the remote quiz payload.
/// Cannot be initiated.
abstract class Question 
{
  final num _qNo;

  final String _prompt;
  final QuestionType _type;

  List<String>? _choices; //optional, really used only for multiple choice only

  /// The one-based number used when presenting the question.
  num get qNo => _qNo;

  /// The text shown to the player for this question.
  String get prompt => _prompt;

  /// The lowercase serialized name of the question type.
  String get type => _type.name.toLowerCase();

  /// The options used for answering a question.
  List<String> get choices => _choices ?? [];

  /// Setter for changing the choices.
  set choices(List<String> newChoices) => _choices = newChoices;

  /// The number of the question type.
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

   /// Creates a question with its display number, prompt, and question type.
  Question(this._qNo, this._prompt, this._type,[this._choices]);

  /// Builds the appropriate question subtype from quiz JSON data.
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

  /// Returns the canonical answer text for display after an incorrect guess.
  String getAns();

  /// Returns whether user input is correct for this question.
  bool checkAns();

}