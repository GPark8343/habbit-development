import 'package:flutter/material.dart';
import 'package:habbit/Screen/repository_screen.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/design_course/course_info_screen.dart';
import 'package:habbit/design_course/design_course_app_theme.dart';
import 'package:habbit/design_course/models/category.dart';
import 'package:habbit/main.dart';
import 'package:habbit/models/folder.dart';
import 'package:habbit/models/story.dart';
import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:habbit/providers/time_manage.dart';
import 'package:habbit/providers/upload.dart';
import 'package:provider/provider.dart';

class PopularCourseListView extends StatefulWidget {
  final Function? selectPage;
  PopularCourseListView({this.selectPage});

  @override
  _PopularCourseListViewState createState() => _PopularCourseListViewState();
}

class _PopularCourseListViewState extends State<PopularCourseListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  dispose() {
    animationController?.dispose(); // you need this
    super.dispose();
  }

  Future<bool> getData() async {
    await Provider.of<StoryManage>(context, listen: false).fetchAndSetStories();
    if (mounted) {
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
    }

    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: MediaQuery.of(context).size.width / 360 * 8),
      child: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return GridView.builder(
              shrinkWrap: true,
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width / 360 * 8),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: Provider.of<FolderManage>(context, listen: false)
                  .folders
                  .length,
              itemBuilder: (BuildContext context, int index) {
                List<Story> storiesOfFoler =
                    Provider.of<StoryManage>(context, listen: false)
                        .items
                        .where((element) =>
                            element.folderId ==
                            Provider.of<FolderManage>(context, listen: false)
                                .folders[index]
                                .id)
                        .toList();
                var numberOfstoriesOfFoler = storiesOfFoler.length;
                final int count =
                    Provider.of<FolderManage>(context, listen: false)
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
                return CategoryView(
                  selectPage: widget.selectPage,
                  folder: Provider.of<FolderManage>(context, listen: false)
                      .folders[index],
                  numberOfStories: numberOfstoriesOfFoler,
                  index: index,
                  animation: animation,
                  animationController: animationController,
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: MediaQuery.of(context).size.width / 360 * 32.0,
                crossAxisSpacing:
                    MediaQuery.of(context).size.width / 360 * 32.0,
                childAspectRatio: 0.8,
              ),
            );
          }
        },
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView(
      {Key? key,
      this.folder,
      this.numberOfStories,
      this.index,
      this.animationController,
      this.animation,
      this.selectPage})
      : super(key: key);
  final Function? selectPage;
  final Folder? folder;
  final int? numberOfStories;
  final int? index;
  final AnimationController? animationController;
  final Animation<double>? animation;

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

    String CategoryPicture(String selectedCategory) {
      if (selectedCategory == 'Kind.Reading') {
        return 'assets/icons/reading_picture.jpg';
      } else if (selectedCategory == 'Kind.Exercise') {
        return 'assets/icons/exercise_picture.jpg';
      } else if (selectedCategory == 'Kind.Language') {
        return 'assets/icons/language_picture.jpg';
      } else if (selectedCategory == 'Kind.Study') {
        return 'assets/icons/study_picture.jpg';
      } else {
        return 'assets/icons/etc_picture.jpg';
      }
    }

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text('진짜로 지우시겠습니까?'),
                        content: Text(
                            '지금 지우려는 폴더는 ${Provider.of<FolderManage>(context, listen: false).folders[index!].title}입니다.'),
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
                                      .folders[index!]
                                      .id);

                              animationController!.reset();
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      content: SingleChildScrollView(
                                        child:
                                            Text('삭제가 완료되었습니다.\n다시 화면을 로딩해주세요'),
                                      ),
                                    );
                                  });
                            },
                            child: const Text('삭제하기'),
                          ),
                        ],
                      );
                    });
              },
              onTap: () {
                Route _createRoute() {
                  return PageRouteBuilder(
                    settings: RouteSettings(arguments: {
                      'folder_title': folder!.title,
                      'folder_id': folder!.id,
                      'category': folder!.category
                    }),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        RepositoryScreen(selectPage: selectPage!),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
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

                Navigator.of(context).push(_createRoute());
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.width / 360 * 280,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: HexColor('#F8FAFB'),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    MediaQuery.of(context).size.width /
                                        360 *
                                        16.0)),
                                // border: new Border.all(
                                //     color: DesignCourseAppTheme.notWhite),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    360 *
                                                    16,
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    360 *
                                                    16,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    360 *
                                                    16),
                                            child: Text(
                                              folder!.title,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    360 *
                                                    16,
                                                letterSpacing:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        360 *
                                                        0.27,
                                                color: DesignCourseAppTheme
                                                    .darkerText,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    360 *
                                                    8,
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    360 *
                                                    16,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    360 *
                                                    16,
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    360 *
                                                    8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  ' ${numberOfStories}일/60일',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            360 *
                                                            12,
                                                    letterSpacing:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            360 *
                                                            0.27,
                                                    color: DesignCourseAppTheme
                                                        .grey,
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        numberOfStories! >= 60
                                                            ? '100%'
                                                            : ' ${((numberOfStories! / 60) * 100).ceil()}%',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              360 *
                                                              18,
                                                          letterSpacing:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  360 *
                                                                  0.27,
                                                          color:
                                                              DesignCourseAppTheme
                                                                  .grey,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.check,
                                                        color:
                                                            DesignCourseAppTheme
                                                                .nearlyBlue,
                                                        size: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            360 *
                                                            20,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        360 *
                                        48,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.width / 360 * 48,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width / 360 * 24,
                            right: MediaQuery.of(context).size.width / 360 * 16,
                            left: MediaQuery.of(context).size.width / 360 * 16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(
                                MediaQuery.of(context).size.width /
                                    360 *
                                    16.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: DesignCourseAppTheme.grey
                                      .withOpacity(0.2),
                                  offset: const Offset(0.0, 0.0),
                                  blurRadius:
                                      MediaQuery.of(context).size.width /
                                          360 *
                                          6.0),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(
                                MediaQuery.of(context).size.width /
                                    360 *
                                    16.0)),
                            child: AspectRatio(
                                aspectRatio: 1.28,
                                child: Image.asset(
                                    CategoryPicture(folder!.category),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
