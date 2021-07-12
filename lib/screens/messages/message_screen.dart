import 'package:chat/constants.dart';
import 'package:chat/models/Chat.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class MessagesScreen extends StatelessWidget {
  final Chat conversation;
  const MessagesScreen({Key? key, required this.conversation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(conversation: conversation),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(),
          CircleAvatar(
            backgroundImage: AssetImage(conversation.image),
          ),
          SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                conversation.name,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                conversation.isActive ? "Active" : "Active 3m ago",
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.local_phone),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.videocam),
          onPressed: () {},
        ),
        SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }
}
