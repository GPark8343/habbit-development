import 'package:flutter/material.dart';
import 'package:habbit/models/folder.dart';
import 'package:habbit/models/story.dart';
import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:provider/provider.dart';

class Deco extends StatelessWidget {
  const Deco({super.key});

  @override
  Widget build(BuildContext context) {
    List<int> attendanceList = [];
    Future first() async {
      await Provider.of<FolderManage>(context, listen: false)
          .fetchAndSetFolders();
      await Provider.of<StoryManage>(context, listen: false)
          .fetchAndSetStories();
      List<Folder> folders =
          Provider.of<FolderManage>(context, listen: false).folders;

      for (int i = 0; i < folders.length; i++) {
        attendanceList.add(Provider.of<StoryManage>(context, listen: false)
            .items
            .where((element) => element.folderId == folders[i].id)
            .toList()
            .length);
      }
      print(attendanceList);
    }

    Widget Reward() {
      int rewardStandard =
          attendanceList.where((number) => number >= 0).toList().length;
      if (rewardStandard == 0) {
        return Container();
      }
      return ListView.builder(
          shrinkWrap: true,
          reverse: true,
          itemCount: rewardStandard,
          itemBuilder: (context, index) {
            return Icon(Icons.abc);
          });
    }

    return FutureBuilder(
        future: first(),
        builder: (context, snapshot) {
          return Reward();
        });
    
  }
}
