import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habbit/Screen/fame_repository_screen.dart';
import 'package:habbit/design_course/design_course_app_theme.dart';
import 'package:habbit/design_course/models/category.dart';
import 'package:habbit/main.dart';
import 'package:habbit/models/folder.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({Key? key}) : super(key: key);

  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  bool _isChecked = false;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

//  StreamBuilder(
//             stream: customSnapshot,
//             builder: (ctx, snapshot1) {
//               if (snapshot1.connectionState == ConnectionState.waiting) {
//                 return Center(
//                   child: Container(
//                     color: Colors.white,
//                   ),
//                 );
//               }
//               final docs1 = snapshot1.data?.docs;

//               return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: docs1?.length,
//                   itemBuilder: (ctx, i) {

//                     return StreamBuilder(
//                         stream: FirebaseFirestore.instance
//                             .collection('users')
//                             .where('uid', isEqualTo: docs1?[i]['userId'])
//                             .snapshots(),
//                         builder: (ctx, snapshot2) {
//                           if (snapshot2.connectionState ==
//                               ConnectionState.waiting) {
//                             return Center(
//                               child: Container(
//                                 color: Colors.white,
//                               ),
//                             );
//                           }
//                           final docs2 = snapshot2.data?.docs;

//                           return Row(
//                             children: [
//                               Container(
//                                 width: MediaQuery.of(context).size.width /
//                                     360 *
//                                     30,
//                                 height: MediaQuery.of(context).size.width /
//                                     360 *
//                                     30,
//                                 child: Image.asset('assets/icons/trophy.png'),
//                               ),
//                               Card(
//                                 child: Container(
//                                   width: MediaQuery.of(context).size.width -
//                                       MediaQuery.of(context).size.width /
//                                           360 *
//                                           40,
//                                   child: ListTile(
//                                     leading: CircleAvatar(
//                                       backgroundColor: mainColor,
//                                       backgroundImage: NetworkImage(
//                                           docs2!.first.data()['thumbnail']),
//                                     ),
//                                     title: Text(
//                                       docs1?[i]['folder']['title'],
//                                       style: TextStyle(
//                                           fontSize: MediaQuery.of(context)
//                                                   .size
//                                                   .width /
//                                               360 *
//                                               15,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     subtitle: Text(
//                                       (docs1?[i]['folder']['description'])
//                                           as String,
//                                       style: TextStyle(
//                                           fontSize: MediaQuery.of(context)
//                                                   .size
//                                                   .width /
//                                               360 *
//                                               12,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     onTap: () {
//                                       Route _createRoute() {
//                                         return PageRouteBuilder(
//                                           settings: RouteSettings(arguments: {
//                                             'folder_id': docs1?[i]['folderId'],
//                                             'userId': docs1?[i]['userId'],
//                                           }),
//                                           pageBuilder: (context, animation,
//                                                   secondaryAnimation) =>
//                                               FameRepositoryScreen(),
//                                           transitionsBuilder: (context,
//                                               animation,
//                                               secondaryAnimation,
//                                               child) {
//                                             const begin = Offset(0.0, 1.0);
//                                             const end = Offset.zero;
//                                             const curve = Curves.ease;

//                                             var tween = Tween(
//                                                     begin: begin, end: end)
//                                                 .chain(
//                                                     CurveTween(curve: curve));

//                                             return SlideTransition(
//                                               position: animation.drive(tween),
//                                               child: child,
//                                             );
//                                           },
//                                         );
//                                       }

//                                       Navigator.of(context)
//                                           .push(_createRoute());
//                                     },
//                                     trailing: Text(
//                                       '${timeago.format(docs1?[i]['created_at'].toDate())}',
//                                       style: TextStyle(
//                                         fontSize:
//                                             MediaQuery.of(context).size.width /
//                                                 360 *
//                                                 14,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         });
//                   });
//             }),

  @override
  Widget build(BuildContext context) {
    var customSnapshot = _isChecked
        ? FirebaseFirestore.instance
            .collection('fame_repository')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots()
        : FirebaseFirestore.instance
            .collection('fame_repository')
            .orderBy('created_at', descending: true)
            .snapshots();
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width / 360 * 16,
          bottom: MediaQuery.of(context).size.width / 360 * 16),
      child: Container(
        height: MediaQuery.of(context).size.width / 360 * 134,
        width: double.infinity,
        child: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return StreamBuilder(
                  stream: customSnapshot,
                  builder: (ctx, snapshot1) {
                    if (snapshot1.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Container(
                          color: Colors.white,
                        ),
                      );
                    }
                    final docs1 = snapshot1.data?.docs;
                    return ListView.builder(
                      padding: EdgeInsets.only(
                          top: 0,
                          bottom: 0,
                          right: MediaQuery.of(context).size.width / 360 * 16,
                          left: MediaQuery.of(context).size.width / 360 * 16),
                      itemCount: docs1?.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, i) {
                        final int count =
                            docs1!.length > 10 ? 10 : docs1.length;
                        final Animation<double> animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: animationController!,
                                    curve: Interval((1 / count) * i, 1.0,
                                        curve: Curves.fastOutSlowIn)));
                        animationController?.forward();

                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .where('uid', isEqualTo: docs1[i]['userId'])
                                .snapshots(),
                            builder: (ctx, snapshot2) {
                              if (snapshot2.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                );
                              }
                              final docs2 = snapshot2.data?.docs;
                              return CategoryView(
                                fameInfo: docs1[i],
                                image: docs2!.first.data()['thumbnail'],
                                animation: animation,
                                animationController: animationController,
                              );
                            });
                      },
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({
    Key? key,
    this.image,
    this.fameInfo,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final String? image;
  final fameInfo;

  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    String CategoryWord(String selectedCategory) {
      if (selectedCategory == 'Kind.Reading') {
        return '독서';
      } else if (selectedCategory == 'Kind.Exercise') {
        return '운동';
      } else if (selectedCategory == 'Kind.Language') {
        return '언어';
      } else if (selectedCategory == 'Kind.Study') {
        return '공부';
      } else {
        return '기타';
      }
    }

    Widget CategoryIcon(String selectedCategory) {
      if (selectedCategory == 'Kind.Reading') {
        return Container(
            width: MediaQuery.of(context).size.width / 360 * 30,
            height: MediaQuery.of(context).size.width / 360 * 30,
            child: Image.asset(
              'assets/icons/reading.png',
              color: DesignCourseAppTheme.nearlyWhite,
            ));
      } else if (selectedCategory == 'Kind.Exercise') {
        return Container(
            width: MediaQuery.of(context).size.width / 360 * 30,
            height: MediaQuery.of(context).size.width / 360 * 30,
            child: Image.asset(
              'assets/icons/exercise.png',
              color: DesignCourseAppTheme.nearlyWhite,
            ));
      } else if (selectedCategory == 'Kind.Language') {
        return Container(
            width: MediaQuery.of(context).size.width / 360 * 30,
            height: MediaQuery.of(context).size.width / 360 * 30,
            child: Image.asset(
              'assets/icons/language.png',
              color: DesignCourseAppTheme.nearlyWhite,
            ));
      } else if (selectedCategory == 'Kind.Study') {
        return Container(
            width: MediaQuery.of(context).size.width / 360 * 30,
            height: MediaQuery.of(context).size.width / 360 * 30,
            child: Image.asset(
              'assets/icons/study.png',
              color: DesignCourseAppTheme.nearlyWhite,
            ));
      } else {
        return Container(
            width: MediaQuery.of(context).size.width / 360 * 30,
            height: MediaQuery.of(context).size.width / 360 * 30,
            child: Image.asset(
              'assets/icons/etc.png',
              color: DesignCourseAppTheme.nearlyWhite,
            ));
      }
    }

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context)
                    .pushNamed(FameRepositoryScreen.routeName, arguments: {
                  'folder_id': fameInfo!['folderId'],
                  'userId': fameInfo!['userId'],
                });
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 360 * 280,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 360 * 48,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: HexColor('#F8FAFB'),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    MediaQuery.of(context).size.width /
                                        360 *
                                        16.0)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        360 *
                                        72,
                                  ),
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
                                                    16),
                                            child: Text(
                                              fameInfo!['folder']['title'],
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
                                          const Expanded(
                                            child: SizedBox(),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  '${fameInfo!['folder']['description']}',
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
                                                        '${(fameInfo['fameData'] as List).length}일',
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
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            360 *
                                                            20,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            360 *
                                                            20,
                                                        child: Image.asset(
                                                            'assets/icons/trophy.png'),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    360 *
                                                    16,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    360 *
                                                    16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  CategoryWord(
                                                      fameInfo['folder']
                                                          ['category']),
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            360 *
                                                            18,
                                                    letterSpacing:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            360 *
                                                            0.27,
                                                    color: DesignCourseAppTheme
                                                        .nearlyBlue,
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: DesignCourseAppTheme
                                                        .nearlyBlue,
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                360 *
                                                                8.0)),
                                                  ),
                                                  child: Padding(
                                                      padding: EdgeInsets.all(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              360 *
                                                              4.0),
                                                      child: CategoryIcon(
                                                          fameInfo['folder']
                                                              ['category'])),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width / 360 * 24,
                            bottom:
                                MediaQuery.of(context).size.width / 360 * 24,
                            left: MediaQuery.of(context).size.width / 360 * 16),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16.0)),
                              child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: Image.network(image!)),
                            )
                          ],
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
