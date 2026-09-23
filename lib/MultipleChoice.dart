import 'package:c_s__quiz/Question.dart';

/// An extension class from Question where it handles multiple choice logic
class MultipleChoice extends Question {
  final num ansIndex;

  MultipleChoice(num qNo, String prompt, this.ansIndex, List<String> choices)
    : super(qNo, prompt, QuestionType.MULTIPLE_CHOICE, choices);

  @override
  String toString() {
    return '''
  $qNo.
  $prompt\n
  ''';
  }

  @override
  String getAns() {
    return (ansIndex + 1).toString();
  }

  @override
  bool checkAns(String input) {
    var intParsed = int.parse(input) - 1;
    return intParsed == ansIndex;
  }
}
