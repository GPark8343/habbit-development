import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/providers/post_message_manage.dart';
import 'package:habbit/widgets/chat/chat_box.dart';
import 'package:habbit/widgets/chat/new_message.dart';
import 'package:provider/provider.dart';

class PostChatScreen extends StatefulWidget {
  static const routeName = '/post-chat';
  const PostChatScreen({super.key});

  @override
  State<PostChatScreen> createState() => _PostChatScreenState();
}

class _PostChatScreenState extends State<PostChatScreen> {
  @override
  Widget build(BuildContext context) {
    final postId =
        (ModalRoute.of(context)?.settings.arguments as Map)['postId'];
    return Scaffold(
      appBar: AppBar(
          actions: [],
          iconTheme: IconThemeData(
            color: mainColor, //색변경
          ),
          title: Text(
            '댓글',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 360 * 25,
                color: mainColor,
                fontWeight: FontWeight.bold),
          )),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .doc(postId)
                    .collection(postId)
                    .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  var docs = snapshot.data!.docs;
                  return Expanded(
                    child: ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          // if (docs == null) return const Text('Loading...');
                          return docs.length == 0
                              ? Container()
                              : ChatBox(
                                  docs[index]['text'],
                                  docs[index]['userId'],
                                  (docs[index]['created_at'] as Timestamp)
                                      .toDate(),
                                  postId,
                                  docs[index]['uid']);
                        }),
                  );
                }),
            NewMessage(postId)
          ],
        ),
      ),
    );

    // SingleChildScrollView(
    //   child: Column(
    //     children: List.generate(
    //         upload.postList.length,
    //         (index) => PostWidget(
    //               post: upload.postList[index],
    //             )).toList(),
    //   ),
    // );
  }
}
// import 'package:flutter/material.dart';

// class PostChatScreen extends StatefulWidget {
//   const PostChatScreen({super.key});
//   static const routeName = '/post-chat';
//   @override
//   State<PostChatScreen> createState() => _PostChatScreenState();
// }

// class _PostChatScreenState extends State<PostChatScreen> {
//   final _controller = TextEditingController();
//   Key _k1 = new GlobalKey();
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: TextFormField(
//         key: _k1,
//         controller: _controller,
//         decoration: InputDecoration(labelText: '댓글'),
//         keyboardType: TextInputType.text,
//       ),
//     );
//   }
// }
