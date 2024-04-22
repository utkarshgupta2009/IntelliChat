import 'package:any_chat/Screens/ChatScreen.dart';
import 'package:any_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {
  Gemini.init(apiKey: api_key);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff00A67E)),
          useMaterial3: true,
        ),
        home: const ChatScreen());
  }
}
