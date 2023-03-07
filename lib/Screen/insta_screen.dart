import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habbit/models/post.dart';
import 'package:habbit/providers/upload.dart';
import 'package:habbit/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class InstaScreen extends StatelessWidget {
  const InstaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final upload = Provider.of<Upload>(context, listen: false);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('created_at', descending: false)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Container(color: Colors.white,),
              );
          }
          final docs = snapshot.data?.docs;
          return ListView.builder(
              shrinkWrap: true,
              
              itemCount: docs?.length,
              itemBuilder: (context, index) {
                return docs?.length == 0
                    ? Container()
                    : PostWidget(
                        post: Post.fromJson(
                            docs![index]['uid'], docs[index].data()),
                      );
              });

          // SingleChildScrollView(
          //   child: Column(
          //     children: List.generate(
          //         upload.postList.length,
          //         (index) => PostWidget(
          //               post: upload.postList[index],
          //             )).toList(),
          //   ),
          // );
        });

    // FutureBuilder(
    //     future: upload.addPostList(),
    //     builder: (ctx, snapshot) =>
    //         snapshot.connectionState == ConnectionState.waiting
    //             ? Center(
    //                 child: CircularProgressIndicator(),
    //               )
    //             : SingleChildScrollView(
    //                 child: Column(
    //                   children: List.generate(
    //                       upload.postList.length,
    //                       (index) => PostWidget(
    //                             post: upload.postList[index],
    //                           )).toList(),
    //                 ),
    //               ));
  }
}
