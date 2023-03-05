import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habbit/models/folder.dart';
import 'package:habbit/models/story.dart';
import 'package:habbit/providers/deco_manage.dart';
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
      Provider.of<DecoManage>(context, listen: false)
          .updateReward(attendanceList);
      print(attendanceList);
    }

    Widget Reward() {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: const CircularProgressIndicator(),
              );
            }
            final List rewardList =
                snapshot.data?.docs.first.data()['number_of_reward']??[];
            int rewardStandard =
                rewardList.where((number) => number >= 60).toList().length;
            if (rewardStandard == 0) {
              return Text('아직 훈장이 없습니다.(60일 달성 시 지급)');
            }
            return ListView.builder(
                shrinkWrap: true,
                itemCount: rewardStandard,
                itemBuilder: (context, index) {
                  return Icon(Icons.abc);
                });
          });
    }

    return FutureBuilder(
        future: first(),
        builder: (context, snapshot) {
          return Reward();
        });
  }
}
