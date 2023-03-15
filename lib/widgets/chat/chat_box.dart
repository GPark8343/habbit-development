import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/widgets/avatar_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatBox extends StatefulWidget {
  final String messageText;
  final String userId;
  final DateTime createdAt;
  final String postId;
  final String uid;
  ChatBox(this.messageText, this.userId, this.createdAt, this.postId, this.uid);

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                color: Colors.white,
              ),
            );
          }
          final docData = snapshot.data?.docs.first.data();
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 360 * 15.0),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Card(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(docData!['thumbnail']),
                        backgroundColor: Colors.white,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width /
                                    360 *
                                    12.5),
                            child: Text(
                              docData['nickname'],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width /
                                    360 *
                                    16,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width -
                                    MediaQuery.of(context).size.width /
                                        360 *
                                        45,
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width /
                                          360 *
                                          10,
                                      right: MediaQuery.of(context).size.width /
                                          360 *
                                          30,
                                      top: MediaQuery.of(context).size.width /
                                          360 *
                                          5,
                                      bottom:
                                          MediaQuery.of(context).size.width /
                                              360 *
                                              5,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.messageText,
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                360 *
                                                16,
                                          ),
                                        ),
                                        Text(
                                          timeago.format(widget.createdAt),
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  360 *
                                                  11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          );
        });
  }
}
