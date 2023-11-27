import 'package:any_chat/Animations/ThreeDots.dart';
import 'package:any_chat/Widgets/ChatMessages.dart';
import 'package:any_chat/constants.dart';
import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessages> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool isTyping = false;

  OpenAI? chatGPT = OpenAI.instance.build(
    token: api_key,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(
        seconds: 25,
      ),
    ),
    enableLog: true,
  );

  void sendQuery() async {
    if (_controller.text == "") {
      return;
    } else {
      ChatMessages query = ChatMessages(query: _controller.text, sender: "You");
      setState(() {
        isTyping = true;
        _messages.insert(0, query);
      });
      _controller.clear();

      List<Messages> messagesHistory = _messages.reversed.map((m) {
        if (m.sender == "You") {
          return Messages(role: Role.user, content: m.query);
        } else {
          return Messages(role: Role.assistant, content: m.query);
        }
      }).toList();

      final request = ChatCompleteText(
          model: GptTurbo16k0631Model(),
          messages: messagesHistory,
          maxToken: 200);

      final response = await chatGPT!.onChatCompletion(request: request);

      for (var choices in response!.choices) {
        if (choices.message != null) {
          setState(() {
            isTyping = false;
            _messages.insert(
              0,
              ChatMessages(sender: "Bot", query: choices.message!.content),
            );
          });
        }
      }
    }
  }

  Widget _textComposer() {
    return Row(
      children: [
        Expanded(
            child: TextField(
          onSubmitted: (value) => sendQuery(),
          controller: _controller,
          decoration: const InputDecoration.collapsed(
              hintText: "Hi! How can I help you today?",
              hintStyle: TextStyle(color: Vx.gray400)),
        )),
        IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => (_controller.text == "" ? {} : sendQuery()))
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.gray200,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'IntelliChat',
          style: TextStyle(color: Vx.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
           
            Flexible(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  padding: Vx.m8,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _messages[index];
                  }),
            ),
            if (isTyping) const ThreeDots(),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: context.cardColor,
              ),
              child: _textComposer(),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
