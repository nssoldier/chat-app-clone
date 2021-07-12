import 'package:chat/components/filled_outline_button.dart';
import 'package:chat/constants.dart';
import 'package:chat/models/Chat.dart';
import 'package:chat/screens/messages/message_screen.dart';
import 'package:flutter/material.dart';

import 'chat_card.dart';

class Body extends StatefulWidget {
  Body() : super();

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool filterOnlyActive = false;
  List listConversation = chatsData;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
              kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
          color: kPrimaryColor,
          child: Row(
            children: [
              FillOutlineButton(
                  press: () {
                    setState(() {
                      filterOnlyActive = false;
                      listConversation = chatsData;
                    });
                  },
                  text: "Recent Message",
                  isFilled: !filterOnlyActive),
              SizedBox(width: kDefaultPadding),
              FillOutlineButton(
                press: () {
                  setState(() {
                    filterOnlyActive = true;
                    listConversation = chatsData
                        .where((conversation) => (conversation.isActive))
                        .toList();
                  });
                },
                text: "Active",
                isFilled: filterOnlyActive,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: listConversation.length,
            itemBuilder: (context, index) => ChatCard(
              chat: listConversation[index],
              press: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MessagesScreen(conversation: listConversation[index]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
