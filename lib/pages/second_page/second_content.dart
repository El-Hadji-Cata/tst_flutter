import 'package:flutter/material.dart';

void main() => runApp(const VerticalDividerExampleApp());

class VerticalDividerExampleApp extends StatelessWidget {
  const VerticalDividerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: const Color(0xff6750a4)),
      home: Scaffold(
        appBar: AppBar(title: const Text('Divider Sample')), backgroundColor: Colors.green,
        body: const SecondContent(),
      ),
    );
  }
}
class SecondContent extends StatelessWidget {
  const SecondContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discord"),

      ),

    );
  }
}



