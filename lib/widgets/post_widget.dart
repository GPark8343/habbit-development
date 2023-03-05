import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:habbit/models/post.dart';
import 'package:habbit/widgets/avatar_widget.dart';
import 'package:habbit/widgets/image_frame.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostWidget extends StatelessWidget {
  final Post post;
  const PostWidget({Key? key, required this.post}) : super(key: key);

  Widget _header() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: post.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
          final docData = snapshot.data?.docs.first.data();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AvatarWidget(
                    type: AvatarType.TYPE3,
                    nickname: docData!['nickname'],
                    size: 40,
                    thumbPath: docData['thumbnail']),Text(
                  '카테고리 ${post.category ?? ''}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // GestureDetector(
                //   onTap: () {},
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: ImageFrame(
                //       IconsPath.postMoreIcon,
                //       width: 30,
                //     ),
                //   ),
                // )
              ],
            ),
          );
        });
  }

  Widget _image() {
    return CachedNetworkImage(
      imageUrl: post.thumbnail!,
      placeholder: (context, url) => new CircularProgressIndicator(),
    );
  }

  // Widget _infoCount() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Row(
  //           children: [
  //             ImageFrame(
  //               IconsPath.likeOffIcon,
  //               width: 65,
  //             ),
  //             const SizedBox(width: 15),
  //             ImageFrame(
  //               IconsPath.replyIcon,
  //               width: 60,
  //             ),
  //             const SizedBox(width: 15),
  //             ImageFrame(
  //               IconsPath.directMessage,
  //               width: 55,
  //             ),
  //           ],
  //         ),
  //         ImageFrame(
  //           IconsPath.bookMarkOffIcon,
  //           width: 50,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _infoDescription() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: post.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
          final docData = snapshot.data?.docs.first.data();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '좋아요 ${post.likeCount ?? 0}개',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                
                ExpandableText(
                  post.description ?? '',
                  prefixText: docData!['nickname'],
                  onPrefixTap: () {
                    print('개발하는남자 페이지 이동');
                  },
                  prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
                  expandText: '더보기',
                  collapseText: '접기',
                  maxLines: 3,
                  expandOnTextTap: true,
                  collapseOnTextTap: true,
                  linkColor: Colors.grey,
                )
              ],
            ),
          );
        });
  }

  // Widget _replyTextBtn() {
  //   return GestureDetector(
  //     onTap: () {},
  //     child: const Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 15.0),
  //       child: Text(
  //         '댓글 199개 모두 보기',
  //         style: TextStyle(color: Colors.grey, fontSize: 13),
  //       ),
  //     ),
  //   );
  // }

  Widget _dateAgo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
        timeago.format(post.createdAt!),
        style: const TextStyle(color: Colors.grey, fontSize: 11),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(),
          const SizedBox(height: 15),
          _image(),
          const SizedBox(height: 15),
          // _infoCount(),
          // const SizedBox(height: 5),
          _infoDescription(),
          // const SizedBox(height: 5),
          // _replyTextBtn(),
          const SizedBox(height: 5),
          _dateAgo(),
        ],
      ),
    );
  }
}
