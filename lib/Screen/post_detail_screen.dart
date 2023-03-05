import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

    return FutureBuilder(
        future: fetchAndSetStories(),
        builder: (context, snapshot) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(selectedStory.title),
            ),
            body: snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : selectedStory.id == 'no_found'
                    ? Center(
                        child: Column(
                          children: [
                            Text('스토리가 남아 있지 않습니다.'),
                            ElevatedButton(
                              child: Text('네. 삭제합니다.'),
                              onPressed: () {
                                deletePost(storyId);
                                Navigator.of(context).pop();
                                // 화면 업데이트 추가
                              },
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            height:
                                MediaQuery.of(context).size.width / 360 * 250,
                            width: double.infinity,
                            child: Image.file(
                              selectedStory.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.width / 360 * 10,
                          ),
                          Text(
                            selectedStory.createdAt as String,
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
                            selectedStory.description as String,
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
                            selectedStory.category as String,
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
                          TextButton(
                            onPressed: () {
                              showDialog<bool>(
                                  context: _scaffoldKey!.currentContext!,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text('포스트 를 내릴까요?'),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: Text('아니오.'),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        ElevatedButton(
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
                            child: Text('delete post'),
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white),
                          ),
                        ],
                      ),
          );
        });
  }
}
