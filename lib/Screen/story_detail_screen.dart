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
    final isUploaded = selectedStory.isUploaded;

    fetchAndSetStories() {
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

    return FutureBuilder(
        future: fetchAndSetStories(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text(selectedStory.title),
            ),
            body: snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Container(
                        height: 250,
                        width: double.infinity,
                        child: Image.file(
                          selectedStory.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        selectedStory.createdAt as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        selectedStory.description as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        selectedStory.category as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text('스토리 를 내릴까요?'),
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
                                        isUploaded == 0
                                            ? deleteStory(storyId)
                                            : deleteStoryAndPost(storyId);
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
                        child: Text('delete story'),
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.white),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            // firebase upload function
                            IUser? userInfo = await upload.loadUserByUid(
                                FirebaseAuth.instance.currentUser!.uid);
                            upload.uplaodPost(
                                Post(
                                    userId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    userInfo: userInfo,
                                    description: selectedStory.description,
                                    uid: selectedStory.id,
                                    createdAt: DateTime.now(),
                                    category: selectedStory.category),
                                selectedStory.image,
                                selectedStory.id);
                            Provider.of<StoryManage>(context, listen: false)
                                .changeIsUploaded(selectedStory);
                            // upload.uploadFile(selectedStory.image, '/${selectedStory.id}/${Uuid().v4()}.jpg');
                            // upload.updatePost(Post(id: 'post', userInfo: userInfo,description:selectedStory.description ,thumbnail:selectedStory.image. ,uid: id ));
                          },
                          child: Text('upload story'))
                    ],
                  ),
          );
        });
  }
}
