import 'package:exp_flutter_sqlite_crud/page/note_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// SOURCE OF THIS EXPERIMENT: https://www.youtube.com/watch?v=UpKrhZ0Hppk
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = "Notes SQLite";

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.blueGrey.shade900,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0
        )
      ),

      home: NotePage(),
    );
  }
}
