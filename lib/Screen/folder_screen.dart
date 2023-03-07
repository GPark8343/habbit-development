import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habbit/Screen/repository_screen.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/helper/db_helper.dart';
import 'package:habbit/models/folder.dart';
import 'package:habbit/models/story.dart';
import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:habbit/providers/time_manage.dart';
import 'package:habbit/providers/upload.dart';
import 'package:habbit/widgets/buttons/add_folder_button.dart';
import 'package:provider/provider.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  @override
  Widget build(BuildContext context) {
    Future first() async {
      await Provider.of<FolderManage>(context, listen: false)
          .fetchAndSetFolders()
          .then((value) {
        List<Folder> foldersList =
            Provider.of<FolderManage>(context, listen: false).folders;
        foldersList.forEach((folder) {
          Provider.of<FolderManage>(context, listen: false).controlDay(
              folder,
              Provider.of<TimeManage>(context, listen: false)
                  .howManyDaysPassed(folder));
        });
      });
      await Provider.of<FolderManage>(context, listen: false)
          .fetchAndSetFolders();
    }

    _deleteFolderStoryAndPost(String selectedFolderId) async {
      await Provider.of<StoryManage>(context, listen: false)
          .fetchAndSetStories(); //
      List<Story> storiesOfFoler =
          Provider.of<StoryManage>(context, listen: false)
              .findByFolderId(selectedFolderId);

      storiesOfFoler.map((story) {
        Provider.of<Upload>(context, listen: false).deletePost(story.id);
        Provider.of<StoryManage>(context, listen: false)
            .deleteStories(story.id);
      });
      await Provider.of<FolderManage>(context, listen: false)
          .deleteFolders(selectedFolderId);
    }

    return FutureBuilder(
        //  FutureBuilder는 서버에서 데이터를 모두 받아오기전 화면을 그려줄수 있게 되는 장점을 가진다.
        future: first(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<FolderManage>(
                child: Center(
                    child: Column(
                  children: [
                    const Text('Got no folders yet, start adding some!'),
                  ],
                )),
                builder: (ctx, greatFolders, ch) => greatFolders
                            .folders.length <=
                        0
                    ? ch!
                    : ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: greatFolders.folders.length,
                        itemBuilder: (ctx, i) => Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) => _deleteFolderStoryAndPost(
                              greatFolders.folders[i].id),
                          confirmDismiss: (direction) {
                            return showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: const Text('Are you sure?'),
                                    content: Text(
                                        'Now I am deleting ${greatFolders.folders[i].title}'),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: mainColor),
                                        onPressed: () {
                                          return Navigator.of(context)
                                              .pop(false);
                                        },
                                        child: const Text('CANCEL'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: mainColor),
                                        onPressed: () {
                                          return Navigator.of(context)
                                              .pop(true);
                                        },
                                        child: const Text('DELETE'),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: ListTile(
                            // leading: CircleAvatar(
                            //   backgroundImage:
                            //       FileImage(greatFolders.folders[i].image),
                            // ),
                            title: Text(greatFolders.folders[i].title),
                            subtitle: Text((greatFolders.folders[i].description)
                                as String),
                            onTap: () {
                              Route _createRoute() {
                                return PageRouteBuilder(
                                  settings: RouteSettings(arguments: {
                                    'folder_id': greatFolders.folders[i].id,
                                    'category': greatFolders.folders[i].category
                                  }),
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      RepositoryScreen(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    const curve = Curves.ease;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                );
                              }

                              Provider.of<TimeManage>(context, listen: false)
                                  .howManyDaysPassed(greatFolders.folders[i]);
                              Navigator.of(context).push(
                                _createRoute(),
                              );
                            },
                            trailing: Text(
                                "category ${greatFolders.folders[i].category} day ${greatFolders.folders[i].days}"),
                          ),
                        ),
                      ),
              ));
  }
}
