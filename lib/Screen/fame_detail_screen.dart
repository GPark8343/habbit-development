import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:habbit/widgets/avatar_widget.dart';
import 'dart:io';
import 'package:timeago/timeago.dart' as timeago;

class FameDetailScreen extends StatelessWidget {
  const FameDetailScreen({super.key});
  static const routeName = '/fame-detail';
  @override
  Widget build(BuildContext context) {
    final userId =
        (ModalRoute.of(context)?.settings.arguments as Map)['userId'];
    final createdAt = ((ModalRoute.of(context)?.settings.arguments
        as Map)['created_at'] as String);
    final title = (ModalRoute.of(context)?.settings.arguments as Map)['title'];
    final description =
        (ModalRoute.of(context)?.settings.arguments as Map)['description'];
    final category =
        (ModalRoute.of(context)?.settings.arguments as Map)['category'];
    final image = ((ModalRoute.of(context)?.settings.arguments as Map)['image']
        as String);

    Widget _header() {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: const CircularProgressIndicator(),
              );
            }
            final docData = snapshot.data?.docs.first.data();
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 360 * 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AvatarWidget(
                      type: AvatarType.TYPE3,
                      nickname: docData!['nickname'],
                      size: MediaQuery.of(context).size.width / 360 * 40,
                      thumbPath: docData['thumbnail']),
                  Text(
                    ' 카테고리 ${category ?? ''}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          });
    }

    Widget _image() {
      return Image.file(
        File(image),
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    Widget _infoDescription() {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: const CircularProgressIndicator(),
              );
            }
            final docData = snapshot.data?.docs.first.data();
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 360 * 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ExpandableText(
                    description ?? '',
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

    Widget _dateAgo(double size) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: size * 15.0),
        child: Text(
          timeago.format(DateTime.parse(createdAt)),
          style: TextStyle(color: Colors.grey, fontSize: size * 11),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(title: Text('명예의 전당 스토리')),
        body: Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.width / 360 * 20),
          child: SingleChildScrollView(
        
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(),
                SizedBox(height: MediaQuery.of(context).size.width / 360 * 15),
                _image(),
                SizedBox(height: MediaQuery.of(context).size.width / 360 * 15),
                _infoDescription(),
                SizedBox(height: MediaQuery.of(context).size.width / 360 * 5),
                _dateAgo(MediaQuery.of(context).size.width / 360),
              ],
            ),
          ),
        ));
  }
}
