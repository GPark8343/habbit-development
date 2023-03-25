import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habbit/providers/post_message_manage.dart';
import 'package:provider/provider.dart';

class NewMessage extends StatefulWidget {
  final String postId;

  NewMessage(this.postId);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';

  final _controller = TextEditingController();
  Key _k1 = new GlobalKey();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: _controller,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          enableSuggestions: true,
          decoration: InputDecoration(labelText: 'Send a message...'),
          onChanged: (value) {
            if (mounted) {
              setState(() {
                _enteredMessage = value;
              });
            }
          },
        )),
        IconButton(
            onPressed: () async {
              if (_enteredMessage == '') {
                return;
              }
              FocusScope.of(context).unfocus();
              _controller.clear();
              await Provider.of<PostMessageManage>(context, listen: false)
                  .sendMessage(_enteredMessage, widget.postId);
            },
            icon: Icon(Icons.send))
      ],
    );
  }
}
