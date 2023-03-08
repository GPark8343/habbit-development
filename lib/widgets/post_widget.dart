import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/models/post.dart';
import 'package:habbit/providers/report_manage.dart';
import 'package:habbit/widgets/avatar_widget.dart';
import 'package:habbit/widgets/image_frame.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostWidget extends StatelessWidget {
  final Post post;
  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget CategoryIcon(String selectedCategory) {
      if (selectedCategory == 'Kind.Reading') {
        return Container(
            width: MediaQuery.of(context).size.width / 360 * 20,
            height: MediaQuery.of(context).size.width / 360 * 20,
            child: Image.asset('assets/icons/reading.png'));
      } else if (selectedCategory == 'Kind.Exercise') {
        return Container(
            width: MediaQuery.of(context).size.width / 360 * 20,
            height: MediaQuery.of(context).size.width / 360 * 20,
            child: Image.asset('assets/icons/exercise.png'));
      } else if (selectedCategory == 'Kind.Language') {
        return Container(
            width: MediaQuery.of(context).size.width / 360 * 20,
            height: MediaQuery.of(context).size.width / 360 * 20,
            child: Image.asset('assets/icons/language.png'));
      } else if (selectedCategory == 'Kind.Study') {
        return Container(
            width: MediaQuery.of(context).size.width / 360 * 20,
            height: MediaQuery.of(context).size.width / 360 * 20,
            child: Image.asset('assets/icons/study.png'));
      } else {
        return Container(
            width: MediaQuery.of(context).size.width / 360 * 20,
            height: MediaQuery.of(context).size.width / 360 * 20,
            child: Image.asset('assets/icons/etc.png'));
      }
    }

    Widget _header() {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: post.userId)
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
                child: AvatarWidget(
                    type: AvatarType.TYPE3,
                    nickname: docData!['nickname'],
                    size: MediaQuery.of(context).size.width / 360 * 40,
                    thumbPath: docData['thumbnail']),

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
              ),
            );
          });
    }

    Widget _image() {
      return CachedNetworkImage(
        imageUrl: post.thumbnail!,
        placeholder: (context, url) => Center(
          child: Container(
            color: Colors.white,
          ),
        ),
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
                child: Container(
                  color: Colors.white,
                ),
              );
            }
            final docData = snapshot.data?.docs.first.data();
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 360 * 15.0),
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

    Widget _dateAgo(double size) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: size * 15.0),
        child: Text(
          timeago.format(post.createdAt!),
          style: TextStyle(color: Colors.grey, fontSize: size * 11),
        ),
      );
    }

    Widget ReportIcon(Post post) {
      return Container(
          width: MediaQuery.of(context).size.width / 360 * 20,
          height: MediaQuery.of(context).size.width / 360 * 20,
          child: GestureDetector(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        content: Text('이 포스트를 신고할까요?'),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor),
                            child: Text('아니오.'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor),
                            child: Text('네. 신고합니다.'),
                            onPressed: () async {
                              await Provider.of<ReportManage>(context,
                                      listen: false)
                                  .reportPost(
                                      post,
                                      FirebaseAuth
                                          .instance.currentUser!.email!);
                              Navigator.of(context).pop();
                              // 화면 업데이트 추가
                            },
                          ),
                        ],
                      );
                    });
              },
              child: Image.asset('assets/icons/siren.png')));
    }

    return Container(
      margin:
          EdgeInsets.only(top: MediaQuery.of(context).size.width / 360 * 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _header(),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 360 * 25),
                    child: ReportIcon(post),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 360 * 20),
                    child: CategoryIcon(post.category!),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.width / 360 * 15),
          _image(),
          SizedBox(height: MediaQuery.of(context).size.width / 360 * 15),
          // _infoCount(),
          // const SizedBox(height: 5),
          _infoDescription(),
          // const SizedBox(height: 5),
          // _replyTextBtn(),
          SizedBox(height: MediaQuery.of(context).size.width / 360 * 5),
          _dateAgo(MediaQuery.of(context).size.width / 360),
        ],
      ),
    );
  }
}
