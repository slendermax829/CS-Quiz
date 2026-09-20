import 'package:c_s__quiz/Controller.dart';
import 'package:c_s__quiz/Question.dart';
import 'package:c_s__quiz/MultipleChoice.dart';
import 'package:c_s__quiz/FillBlank.dart';
import 'package:c_s__quiz/HttpServer.dart';
import 'package:test/test.dart';

Future<void> main() async{
  test('validate(Success)', () async {
    expect(await HttpServer.vailidateConnection(), true);
  });

  test('validate(Failed)', () async{
    expect(await HttpServer.vailidateConnection(), false, reason: 'Connection is Sucessful');
  });

  test('MultipleChoice', () {
    num qNo = 1;
    QuestionType qType = QuestionType.MULTIPLE_CHOICE;
    String prompt = 'Is this a test?';
    List<String> options = ['true','false'];
    num ansIndex = 0;

    var mc = MultipleChoice(qNo,prompt,ansIndex,options);
    expect(mc.type, 'multiple_choice', reason: 'Type is not correct');
    expect(mc.qNo, 1, reason: 'Incorrect qNo');
    expect(mc.choices.isEmpty, false, reason: 'Multiple choice should contain choices to question');
    expect(mc.choices.length, 2, reason: 'Multiple choice should contain all choices to question');

  });

  test('Fill In Blank', () {
    num qNo = 2;
    QuestionType qType = QuestionType.FILL_IN_BLANK;
    String prompt = 'Hello I am a _____';
    List<String> ans = ['test','quiz'];

    var fb = FillBlank(qNo, prompt, ans);
    expect(fb.type, 'fill_in_blank', reason: 'Type is not correct');
    expect(fb.qNo, 2, reason: 'Incorrect qNo');
    expect(fb.choices.isEmpty, true, reason: 'Fill in the blank should not contain options');
  });
}
