import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tst_flutter/firebase_options.dart';
import 'package:tst_flutter/pages/home_page.dart';
import 'package:tst_flutter/pages/second_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(brightness: isDark ? Brightness.dark : Brightness.light);
    return MaterialApp(
      theme: themeData,
      title: 'Flutter Demo',
      home: SecondPage(),
    );
  }
}

