import 'package:dlchat/src/feature/initialization/initialization.dart' deferred as initialization show AppRunner;

Future<void> main() async {
  await initialization.loadLibrary();
  await initialization.AppRunner.startup();
}
