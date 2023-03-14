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

class StoryDetailScreen extends StatefulWidget {
  static const routeName = '/story-detail';

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final storyId =
        (ModalRoute.of(context)?.settings.arguments as Map)['story_id'];

    final upload = Provider.of<Upload>(context, listen: false);
    final selectedStory =
        Provider.of<StoryManage>(context, listen: false).findById(storyId);
    var isUploaded = selectedStory.isUploaded;

    DateTime now = DateTime.now();
    DateTime dateTime = DateTime.parse(selectedStory.createdAt);
    var isToday = DateTime.utc(dateTime.year, dateTime.month, dateTime.day) ==
        DateTime.utc(now.year, now.month, now.day);

    fetchAndSetStories() {
      print(isToday);
      print(isToday);
      Provider.of<StoryManage>(context, listen: false).fetchAndSetStories();
    }

    deletePost(String selectedStoryId) {
      Provider.of<Upload>(context, listen: false).deletePost(selectedStoryId);
    }

    deleteStory(String selectedStoryId) {
      Folder findedFolder = Provider.of<FolderManage>(context, listen: false)
          .findById(selectedStory.folderId);
      Provider.of<StoryManage>(context, listen: false)
          .deleteStories(selectedStoryId);
      Provider.of<StoryManage>(context, listen: false).fetchAndSetStories();
      // Provider.of<FolderManage>(context, listen: false)
      //     .minusOneDay(findedFolder);
    }

    deleteStoryAndPost(String selectedStoryId) {
      Provider.of<Upload>(context, listen: false).deletePost(selectedStoryId);
      Folder findedFolder = Provider.of<FolderManage>(context, listen: false)
          .findById(selectedStory.folderId);
      Provider.of<StoryManage>(context, listen: false)
          .deleteStories(selectedStoryId);
      // Provider.of<FolderManage>(context, listen: false)
      //     .minusOneDay(findedFolder);
    }

    _uploadPost() async {
      IUser? userInfo =
          await upload.loadUserByUid(FirebaseAuth.instance.currentUser!.uid);
      upload.uploadPost(
          Post(
              title: selectedStory.title,
              userId: FirebaseAuth.instance.currentUser!.uid,
              userInfo: userInfo,
              description: selectedStory.description,
              uid: selectedStory.id,
              createdAt: DateTime.now(),
              category: selectedStory.category),
          selectedStory.image,
          selectedStory.folderId);
      await Provider.of<StoryManage>(context, listen: false)
          .changeIsUploaded(selectedStory);
      await fetchAndSetStories();
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

    final GlobalKey<ScaffoldState>? _scaffoldKey = GlobalKey<ScaffoldState>();
    return FutureBuilder(
        future: fetchAndSetStories(),
        builder: (context, snapshot) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              actions: [
                isUploaded == 0
                    ? IconButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        onPressed: () async {
                          showDialog<bool>(
                              context: _scaffoldKey!.currentContext!,
                              builder: (ctx) {
                                return AlertDialog(
                                  content: Text('포스트를 업로드할까요?'),
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
                                      child: Text('네. 업로드합니다.'),
                                      onPressed: () async {
                                        await _uploadPost();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: Icon(
                          Icons.upload_file,
                          color: mainColor,
                        ))
                    : Container()
              ],
              iconTheme: IconThemeData(
                color: mainColor, //색변경
              ),
              title: Text(
                selectedStory.title,
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
                          CategoryIcon(selectedStory.category),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.width / 360 * 10,
                          ),
                          isToday
                              ? TextButton(
                                  onPressed: () {
                                    showDialog<bool>(
                                        context: _scaffoldKey!.currentContext!,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            content: Text('스토리 를 내릴까요?'),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: mainColor),
                                                child: Text('아니오.'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: mainColor),
                                                child: Text('네. 삭제합니다.'),
                                                onPressed: () {
                                                  isUploaded == 0
                                                      ? deleteStory(storyId)
                                                      : deleteStoryAndPost(
                                                          storyId);
                                                  fetchAndSetStories();
                                                  Navigator.of(context).pop();
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
                                  child: Text('스토리 삭제하기'),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: mainColor),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}
