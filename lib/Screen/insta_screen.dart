import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/models/post.dart';
import 'package:habbit/providers/ban_manage.dart';
import 'package:habbit/providers/category_manage.dart';
import 'package:habbit/providers/upload.dart';
import 'package:habbit/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class InstaScreen extends StatelessWidget {
  // Stream customSnapshots(String category) {
  //   if (category == 'all') {
  //     return FirebaseFirestore.instance
  //         .collection('posts')
  //         .orderBy('created_at', descending: true)
  //         .snapshots();
  //   }
  //   if (category == 'reading') {
  //     return FirebaseFirestore.instance
  //         .collection('posts')
  //         .where('category', isEqualTo: 'Kind.Reading')
  //         .orderBy('created_at', descending: true)
  //         .snapshots();
  //   }
  //   if (category == 'exercise') {
  //     return FirebaseFirestore.instance
  //         .collection('posts')
  //         .where('category', isEqualTo: 'Kind.Exercise')
  //         .orderBy('created_at', descending: true)
  //         .snapshots();
  //   }
  //   if (category == 'language') {
  //     return FirebaseFirestore.instance
  //         .collection('posts')
  //         .where('category', isEqualTo: 'Kind.Language')
  //         .orderBy('created_at', descending: true)
  //         .snapshots();
  //   }
  //   if (category == 'study') {
  //     return FirebaseFirestore.instance
  //         .collection('posts')
  //         .where('category', isEqualTo: 'Kind.Study')
  //         .orderBy('created_at', descending: true)
  //         .snapshots();
  //   }
  //   if (category == 'etc') {
  //     return FirebaseFirestore.instance
  //         .collection('posts')
  //         .where('category', isEqualTo: 'Kind.Etc')
  //         .orderBy('created_at', descending: true)
  //         .snapshots();
  //   }
  //   return FirebaseFirestore.instance
  //       .collection('posts')
  //       .orderBy('created_at', descending: true)
  //       .snapshots();
  // }

  @override
  Widget build(BuildContext context) {
    final upload = Provider.of<Upload>(context, listen: false);
    // var pickedCategory =
    //     Provider.of<CategoryManage>(context, listen: false).category;
    return FutureBuilder(
        future:
            Provider.of<BanManage>(context, listen: false).fetchAndSetBanUser(),
        builder: (context, futureSnapshot) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('created_at', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      color: backgroundColor
                    ),
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
