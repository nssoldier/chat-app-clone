import 'package:chat/constants.dart';
import 'package:chat/models/Chat.dart';
import 'package:chat/models/ChatMessage.dart';
import 'package:flutter/material.dart';

import 'chat_input_field.dart';
import 'message.dart';

class Body extends StatefulWidget {
  final Chat conversation;
  Body({Key? key, required this.conversation}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List messages = demeChatMessages;
  ScrollController _scrollController = new ScrollController();

  addMessage(ChatMessage chat) {
    setState(() {
      messages.add(chat);
    });
  }

  scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) => Message(
                  message: messages[index], conversation: widget.conversation),
            ),
          ),
        ),
        ChatInputField(addMessage: addMessage, scrollToBottom: scrollToBottom),
      ],
    );
  }
}
