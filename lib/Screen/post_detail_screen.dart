import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/models/folder.dart';
import 'package:habbit/models/i_user.dart';
import 'package:habbit/models/post.dart';
import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:habbit/providers/upload.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PostDetailScreen extends StatefulWidget {
  static const routeName = '/post-detail';

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState>? _scaffoldKey = GlobalKey<ScaffoldState>();
    final storyId =
        (ModalRoute.of(context)?.settings.arguments as Map)['story_id'];
    final createdAt =
        (ModalRoute.of(context)?.settings.arguments as Map)['created_at'];
    final title = (ModalRoute.of(context)?.settings.arguments as Map)['title'];
    final image = (ModalRoute.of(context)?.settings.arguments as Map)['image'];
    final description =
        (ModalRoute.of(context)?.settings.arguments as Map)['description'];
    final category =
        (ModalRoute.of(context)?.settings.arguments as Map)['category'];

    final upload = Provider.of<Upload>(context, listen: false);
    final selectedStory =
        Provider.of<StoryManage>(context, listen: false).findById(storyId);
    final isUploaded = selectedStory.isUploaded;

    fetchAndSetStories() {
      Provider.of<StoryManage>(context, listen: false).fetchAndSetStories();
    }

    deletePost(String selectedStoryId) {
      if (selectedStory.id == 'no_found') {
        Provider.of<Upload>(context, listen: false).deletePost(selectedStoryId);
      } else {
        Provider.of<StoryManage>(context, listen: false)
            .changeIsUploaded(selectedStory);
        Provider.of<Upload>(context, listen: false).deletePost(selectedStoryId);
      }
    }

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

    return FutureBuilder(
        future: fetchAndSetStories(),
        builder: (context, snapshot) {
          DateTime dateTime = (createdAt as Timestamp).toDate();
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog<bool>(
                        context: _scaffoldKey!.currentContext!,
                        builder: (ctx) {
                          return AlertDialog(
                            content: Text('포스트를 내릴까요?'),
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
                                child: Text('네. 삭제합니다.'),
                                onPressed: () {
                                  deletePost(storyId);

                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  // 화면 업데이트 추가
                                },
                              ),
                            ],
                          );
                        });

                    // 여기에 화면 다시 업데이트하는 함수 만들기
                  },
                  icon: Icon(Icons.delete),
                  style: TextButton.styleFrom(foregroundColor: mainColor),
                ),
              ],
              iconTheme: IconThemeData(
                color: mainColor, //색변경
              ),
              title: Text(
                title,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 360 * 25,
                    color: mainColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: snapshot.connectionState == ConnectionState.waiting
                ? SafeArea(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            child: CachedNetworkImage(
                              imageUrl: image,
                              placeholder: (context, url) => Container(
                                color: Colors.white,
                              ),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.width / 360 * 10,
                          ),
                          Text(
                            '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width /
                                    360 *
                                    20,
                                color: Colors.grey),
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.width / 360 * 10,
                          ),
                          Text(
                            description as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width /
                                    360 *
                                    20,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.width / 360 * 10,
                          ),
                          CategoryIcon(category),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}
