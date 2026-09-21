import 'package:c_s__quiz/Controller.dart';
import 'package:c_s__quiz/Question.dart';
import 'package:c_s__quiz/MultipleChoice.dart';
import 'package:c_s__quiz/FillBlank.dart';
import 'package:c_s__quiz/HttpServer.dart';
import 'package:c_s__quiz/QuestionPool.dart';
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

  test('API Response', () async{
    var quizResponse = await HttpServer.testFetch(1); // from API. See HTTPServer Base URL

    num qNo = quizResponse.quizNo;
    List<Question> questions = quizResponse.questions;

    // for(Question q in questions)
    // {
    //   print(q.qNo);
    //   print(q.prompt);
    //   print('${q.choices}\n');
      
    // }

    expect(questions[0].type, 'multiple_choice', reason: 'type is not correct from response');
    expect(questions[3].choices.length, 4, reason: 'Question 4 should contain 4 options' );
    expect(qNo, 1, reason: 'qNo should be Quiz #1');
    expect(questions[5].choices.length, 0, reason: 'Question 5 should not contain choices it is a Fill in Blank Q');
  });

  test('QuestionPool.populatePool(API)', () async {
    final pool = QuestionPool();

    await pool.populatePool();

    //Question q = pool.getQuestion(7,10);

    //print(q.prompt);

    expect(pool.numOfQuizzes, greaterThan(0), reason: 'Expected quizzes to load from the API');
    expect(pool.numOfQuestions, greaterThan(0), reason: 'Expected questions to load from the API');
    expect(pool.getFromQuiz(7).length, 10, reason: 'Quiz 07 should contain 10 questions in total');
    expect(pool.getQuestion(7, 10).type, 'fill_in_blank', reason: 'Quiz 07, Question 10 should be a fill in blank question');
  });

  test('RandomQuestionsGet', () async{
    final pool = QuestionPool();
    await pool.populatePool();

    List<Question> RandChosen = pool.getRandQuestions(range:15);
    for(Question q in RandChosen)
    {
      print(q.prompt);
      print(q.choices);
      print('${q.type}\n');
    }

    expect(RandChosen.length, 15, reason: 'the length of randQuestions should be 15');
  });

  test('QuestionsFromQuiz', () async{
    final pool = QuestionPool();
    await pool.populatePool();

    List<Question> fromQuiz = pool.getFromQuiz(3);
    Question q = fromQuiz.firstWhere((q)=> q.qNo == 5);

    expect(fromQuiz.length, 10, reason: 'number of questions should be 10');
    expect(q.type, 'multiple_choice',reason: 'qNo 5 should be multiple choice'); 
  });
}
