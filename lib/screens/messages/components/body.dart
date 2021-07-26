import 'dart:convert';

import 'package:chat/constants.dart';
import 'package:chat/models/Chat.dart';
import 'package:chat/models/ChatMessage.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

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
  late Socket socket;

  @override
  void initState() {
    super.initState();
    connectToServer();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      scrollToBottom();
    });
  }

  void connectToServer() {
    try {
      // Configure socket transports must be sepecified
      socket = io('http://0.0.0.0:3001', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      socket.connect();
      socket.on('connect', (_) => print('connect: ${socket.id}'));
      socket.on('message', handleMessage);
      socket.on('disconnect', (_) => socket.connect());
      socket.on('fromServer', (_) => print(_));
    } catch (e) {
      print(e.toString());
    }
  }

  // Send a Message to the server
  sendMessage(String message) {
    socket.emit(
      "message",
      {
        "id": socket.id,
        "message": message, // Message to be sent
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Listen to all message events from connected users
  void handleMessage(data) {
    data = json.decode(data);
    ChatMessage chatMessage = new ChatMessage(
        messageType: ChatMessageType.text,
        messageStatus: MessageStatus.not_view,
        isSender: data['id'] == socket.id,
        text: data['text']);
    if (mounted) {
      setState(() {
        messages.add(chatMessage);
      });
    }
  }

  addMessage(ChatMessage chat) {
    socket.emit(
        'message',
        json.encode({
          "id": socket.id,
          "messageType": 'text',
          "messageStatus": 'not_view',
          "text": chat.text
        }));
  }

  scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    scrollToBottom();
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
