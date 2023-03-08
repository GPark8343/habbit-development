import 'package:flutter/material.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/models/folder.dart';
import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/marker_manage.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:habbit/widgets/calendar/calendar.dart';
import 'package:provider/provider.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    List<Folder> folderList =
        Provider.of<FolderManage>(context, listen: false).folders;
    int folderListLength = folderList.length;
    void moveLeftIndex() {
      if (index - 1 < 0) {
        setState(() {
          index = folderListLength - 1;
        });
      } else {
        setState(() {
          index--;
        });
      }
    }

    void moveRightIndex() {
      print(MediaQuery.of(context).size.height);
      print(MediaQuery.of(context).size.width);
      if (index + 1 > folderListLength - 1) {
        setState(() {
          index = 0;
        });
      } else {
        setState(() {
          index++;
        });
      }
    }

    Future? first() async {
      await Provider.of<FolderManage>(context, listen: false)
          .fetchAndSetFolders();
      await Provider.of<StoryManage>(context, listen: false)
          .fetchAndSetStories();

      await Provider.of<MarkerManage>(context, listen: false).addMarker();
    }

    return FutureBuilder(
        future: first(),
        builder: (context, snapshot) {
          return folderListLength == 0
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '폴더를 먼저 추가해주세요',
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width / 360 * 15,
                          color: mainColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ))
              : SingleChildScrollView(
                  child: Column(
                  children: [
                    Calendar(folderList[index]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor),
                          onPressed: moveLeftIndex,
                          child: Icon(Icons.arrow_left),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor),
                            onPressed: moveRightIndex,
                            child: Icon(Icons.arrow_right)),
                      ],
                    ),
                  ],
                ));
        });
  }
}
