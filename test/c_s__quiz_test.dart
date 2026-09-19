import 'package:c_s__quiz/Controller.dart';
import 'package:c_s__quiz/HttpServer.dart';
import 'package:test/test.dart';

Future<void> main() async{
  test('validate(Success)', () async {
    expect(await HttpServer.vailidateConnection(), true);
  });

  test('validate(Failed)', () async{
    expect(await HttpServer.vailidateConnection(), false, reason: 'Connection is Sucessful');
  });
}
