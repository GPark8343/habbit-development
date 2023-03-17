import 'package:flutter/material.dart';
import 'package:habbit/Screen/repository_screen.dart';
import 'package:habbit/design_course/course_info_screen.dart';
import 'package:habbit/design_course/design_course_app_theme.dart';
import 'package:habbit/design_course/models/category.dart';
import 'package:habbit/main.dart';
import 'package:habbit/models/folder.dart';
import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/time_manage.dart';
import 'package:provider/provider.dart';

class PopularCourseListView extends StatefulWidget {
  const PopularCourseListView({Key? key, this.callBack}) : super(key: key);

  final Function()? callBack;
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

  Future<bool> getData() async {
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
            return GridView(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width / 360 * 8),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: List<Widget>.generate(
                Provider.of<FolderManage>(context, listen: false)
                    .folders
                    .length,
                (int index) {
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
                    folder: Provider.of<FolderManage>(context, listen: false)
                        .folders[index],
                    callback: widget.callBack,
                    category: Category.popularCourseList[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
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
      this.category,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback? callback;
  final Category? category;
  final Folder? folder;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
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
              onTap: () {
                Navigator.of(context)
                    .pushNamed(RepositoryScreen.routeName, arguments: {
                  'folder_title': folder!.title,
                  'folder_id': folder!.id,
                  'category': folder!.category
                });
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
                                                fontSize: MediaQuery.of(context).size.width / 360 *16,
                                                letterSpacing:MediaQuery.of(context).size.width / 360 * 0.27,
                                                color: DesignCourseAppTheme
                                                    .darkerText,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:  EdgeInsets.only(
                                                top: MediaQuery.of(context).size.width / 360 *8,
                                                left: MediaQuery.of(context).size.width / 360 *16,
                                                right: MediaQuery.of(context).size.width / 360 *16,
                                                bottom: MediaQuery.of(context).size.width / 360 *8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  '${category!.lessonCount} lesson',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: MediaQuery.of(context).size.width / 360 *12,
                                                    letterSpacing: MediaQuery.of(context).size.width / 360 *0.27,
                                                    color: DesignCourseAppTheme
                                                        .grey,
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        '${category!.rating}',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize:MediaQuery.of(context).size.width / 360 * 18,
                                                          letterSpacing: MediaQuery.of(context).size.width / 360 *0.27,
                                                          color:
                                                              DesignCourseAppTheme
                                                                  .grey,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color:
                                                            DesignCourseAppTheme
                                                                .nearlyBlue,
                                                        size: MediaQuery.of(context).size.width / 360 *20,
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
                                    width:MediaQuery.of(context).size.width / 360 * 48,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width / 360 *48,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding:
                           EdgeInsets.only(top:MediaQuery.of(context).size.width / 360 * 24, right: MediaQuery.of(context).size.width / 360 *16, left: MediaQuery.of(context).size.width / 360 *16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                             BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width / 360 *16.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: DesignCourseAppTheme.grey
                                      .withOpacity(0.2),
                                  offset: const Offset(0.0, 0.0),
                                  blurRadius: MediaQuery.of(context).size.width / 360 *6.0),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16.0)),
                            child: AspectRatio(
                                aspectRatio: 1.28,
                                child: Image.asset(category!.imagePath)),
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
