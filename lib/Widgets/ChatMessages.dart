import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({
    super.key,
    required this.query,
    required this.sender,
  });
  final String query;
  final String sender;

  @override
  Widget build(BuildContext context) {
   
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: (sender=="You"?TextDirection.rtl: TextDirection.ltr),
        children: [
          Text(sender)
              .text
              .subtitle1(context)
              .make()
              .box
              .color(sender == "You" ? Vx.red200 : Vx.green200)
              .p8
              .customRounded(BorderRadius.circular(10))
              .alignCenter
              .makeCentered(),
          Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Vx.amber100),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SelectableText(
                  query,
                  style: const TextStyle(fontSize: 16),
                ),
              )).p(8),
        ],
      ).py8();
   
    }
  }

