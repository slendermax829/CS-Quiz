import 'package:c_s__quiz/Controller.dart';

Future<void> main(List<String> arguments) async
{
  final controller = Controller();
  await controller.init();
}
