import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:habbit/Screen/error_screen.dart';
import 'package:habbit/Screen/repository_screen.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/introduction_animation/tutorial_screen.dart';
import 'package:habbit/models/folder.dart';
import 'package:habbit/models/story.dart';
import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:habbit/providers/time_manage.dart';
import 'package:habbit/providers/upload.dart';
import 'package:provider/provider.dart';

import '../fitness_app/fitness_app_theme.dart';

class AreaListView extends StatefulWidget {
  const AreaListView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _AreaListViewState createState() => _AreaListViewState();
}

class _AreaListViewState extends State<AreaListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  // List<String> areaListData = <String>[
  //   'assets/fitness_app/area1.png',
  //   'assets/fitness_app/area2.png',
  //   'assets/fitness_app/area3.png',
  //   'assets/fitness_app/area1.png',
  // ];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: first(),
        builder: (context, futureSnapshot) {
          return AnimatedBuilder(
            animation: widget.mainScreenAnimationController!,
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: widget.mainScreenAnimation!,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: GridView(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 16),
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        children: List<Widget>.generate(
                          Provider.of<FolderManage>(context, listen: false)
                              .folders
                              .length,
                          (int index) {
                            final int count = Provider.of<FolderManage>(context,
                                    listen: false)
                                .folders
                                .length;
                            final Animation<double> animation =
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: animationController!,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn),
                              ),
                            );
                            animationController?.forward();
                            return AreaView(
                              number: index,
                              folderName: Provider.of<FolderManage>(context,
                                      listen: false)
                                  .folders[index]
                                  .title,
                              animation: animation,
                              animationController: animationController!,
                            );
                          },
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 24.0,
                          crossAxisSpacing: 24.0,
                          childAspectRatio: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}

class AreaView extends StatefulWidget {
  const AreaView({
    Key? key,
    this.number,
    this.folderName,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final int? number;
  final String? folderName;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  State<AreaView> createState() => _AreaViewState();
}

class _AreaViewState extends State<AreaView> {
  @override
  Widget build(BuildContext context) {
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

    Widget CategoryIcon(String selectedCategory) {
      if (selectedCategory == 'Kind.Reading') {
        return Container(
            width: MediaQuery.of(context).size.width / 360 * 100,
            height: MediaQuery.of(context).size.width / 360 * 100,
            child: Image.asset('assets/icons/reading.png'));
      } else if (selectedCategory == 'Kind.Exercise') {
        return Container(
            width: MediaQuery.of(context).size.width / 360 * 100,
            height: MediaQuery.of(context).size.width / 360 * 100,
            child: Image.asset('assets/icons/exercise.png'));
      } else if (selectedCategory == 'Kind.Language') {
        return Container(
            width: MediaQuery.of(context).size.width / 360 * 100,
            height: MediaQuery.of(context).size.width / 360 * 100,
            child: Image.asset('assets/icons/language.png'));
      } else if (selectedCategory == 'Kind.Study') {
        return Container(
            width: MediaQuery.of(context).size.width / 360 * 100,
            height: MediaQuery.of(context).size.width / 360 * 100,
            child: Image.asset('assets/icons/study.png'));
      } else {
        return Container(
            width: MediaQuery.of(context).size.width / 360 * 100,
            height: MediaQuery.of(context).size.width / 360 * 100,
            child: Image.asset('assets/icons/etc.png'));
      }
    }

    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - widget.animation!.value), 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: FitnessAppTheme.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: FitnessAppTheme.grey.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  splashColor: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.2),
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text('진짜로 지우시겠습니까?'),
                            content: Text(
                                '지금 지우려는 폴더는 ${Provider.of<FolderManage>(context, listen: false).folders[widget.number!].title}입니다.'),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: mainColor),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('취소하기'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: mainColor),
                                onPressed: () async {
                                  await _deleteFolderStoryAndPost(
                                      Provider.of<FolderManage>(context,
                                              listen: false)
                                          .folders[widget.number!]
                                          .id);
                                  widget.animationController!.reset();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('삭제하기'),
                              ),
                            ],
                          );
                        });
                  },
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(RepositoryScreen.routeName, arguments: {
                      'folder_title':
                          Provider.of<FolderManage>(context, listen: false)
                              .folders[widget.number!]
                              .title,
                      'folder_id':
                          Provider.of<FolderManage>(context, listen: false)
                              .folders[widget.number!]
                              .id,
                      'category':
                          Provider.of<FolderManage>(context, listen: false)
                              .folders[widget.number!]
                              .category
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CategoryIcon(
                            Provider.of<FolderManage>(context, listen: false)
                                .folders[widget.number!]
                                .category),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8, left: 8, right: 8),
                        child: Text(widget.folderName!),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
