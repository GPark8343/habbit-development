import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habbit/Screen/story_detail_screen.dart';
import 'package:habbit/models/folder.dart';
import 'package:habbit/models/story.dart';
import 'package:habbit/providers/fame_repository_manage.dart';
import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:habbit/widgets/buttons/add_story_button.dart';
import 'package:provider/provider.dart';

class RepositoryScreen extends StatelessWidget {
  static const routeName = '/repository';
  const RepositoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Folder? folder;
    bool? isFame;
    bool? isRegistered;
    final folderId =
        (ModalRoute.of(context)?.settings.arguments as Map)['folder_id'];
    final category =
        (ModalRoute.of(context)?.settings.arguments as Map)['category'];
    final stories = Provider.of<StoryManage>(context, listen: false).items;
    Future first() async {
      await Provider.of<StoryManage>(context, listen: false)
          .fetchAndSetStories();
      await Provider.of<FolderManage>(context, listen: false)
          .fetchAndSetFolders();
      folder = await Provider.of<FolderManage>(context, listen: false)
          .findById(folderId);
      isFame = stories
              .where((element) => element.folderId == folder?.id)
              .toList()
              .length >=
          60;
      await FirebaseFirestore.instance
          .collection('fame_repository')
          .where('folderId', isEqualTo: folderId)
          .get()
          .then((value) => isRegistered = value.docs.isNotEmpty);

      print(isRegistered);
    }

    return FutureBuilder(
      //  FutureBuilder는 서버에서 데이터를 모두 받아오기전 화면을 그려줄수 있게 되는 장점을 가진다.
      future: first(),
      builder: (ctx, snapshot) => Scaffold(
        appBar: AppBar(
          title: Text('folder repository'),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        !(isRegistered ?? true) || (isFame ?? false)
                            ? Colors.blue
                            : Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                  !(isRegistered ?? true) || (isFame ?? false)
                      ? Provider.of<FameRepositoryManage>(context,
                              listen: false)
                          .registerFameStories(folder!, stories)
                      : print('');
                },
                child: Text((isRegistered ?? true) ? '이미 등록됨' : '명예의 전당 등록'))
          ],
        ),
        body: snapshot.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<StoryManage>(
                child: Center(
                    child: Column(
                  children: [
                    AddStoryButton(folderId, category),
                    const Text('Got no stories yet, start adding some!'),
                  ],
                )),
                builder: (ctx, greatStories, ch) {
                  List<Story> storiesOfFoler = greatStories.items
                      .where((element) => element.folderId == folderId)
                      .toList();
                  Widget isSameDate() {
               
                    return storiesOfFoler
                                .where((element) {
                                  DateTime now = DateTime.now();
                                  DateTime dateTime =
                                      DateTime.parse(element.createdAt);
                                  return DateTime.utc(dateTime.year,
                                          dateTime.month, dateTime.day) ==
                                      DateTime.utc(
                                          now.year, now.month, now.day);
                                })
                                .toList()
                                .length ==
                            0
                        ? AddStoryButton(folderId, category)
                        : Text('오늘 스토리를 업로드하였습니다.');
                  }

                  return storiesOfFoler.length <= 0
                      ? ch!
                      : Column(
                          children: [
                            isSameDate(),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: storiesOfFoler.length,
                              itemBuilder: (ctx, i) => Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        FileImage(storiesOfFoler[i].image),
                                  ),
                                  title: Text(greatStories.items[i].title),
                                  subtitle: Text((storiesOfFoler[i].description)
                                      as String),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        StoryDetailScreen.routeName,
                                        arguments: {
                                          'story_id': storiesOfFoler[i].id,
                                        });
                                  },
                                  trailing: Text(
                                      '${storiesOfFoler[i].category} 업로드 ? ${storiesOfFoler[i].isUploaded == 0 ? false : true}'),
                                ),
                              ),
                            ),
                          ],
                        );
                }),
      ),
    );
  }
}
