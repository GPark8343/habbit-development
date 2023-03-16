import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habbit/Screen/fame_repository_screen.dart';
import 'package:habbit/design_course/design_course_app_theme.dart';
import 'package:habbit/design_course/models/category.dart';
import 'package:habbit/main.dart';
import 'package:habbit/models/folder.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({Key? key, this.callBack}) : super(key: key);

  final Function()? callBack;
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
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        height: 134,
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
                      padding: const EdgeInsets.only(
                          top: 0, bottom: 0, right: 16, left: 16),
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
                                category: Category.categoryList[i],
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
  const CategoryView(
      {Key? key,
      this.image,
      this.category,
      this.fameInfo,
      this.animationController,
      this.animation,
     })
      : super(key: key);

 
  final Category? category;
  final String? image;
  final  fameInfo;

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
                width: 280,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 48,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: HexColor('#F8FAFB'),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 48 + 24.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: Text(
                                              fameInfo!['folder']['title'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.27,
                                                color: DesignCourseAppTheme
                                                    .darkerText,
                                              ),
                                            ),
                                          ),
                                          const Expanded(
                                            child: SizedBox(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16, bottom: 8),
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
                                                    fontSize: 12,
                                                    letterSpacing: 0.27,
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
                                                          fontSize: 18,
                                                          letterSpacing: 0.27,
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
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16, right: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '\$${category!.money}',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme
                                                        .nearlyBlue,
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: DesignCourseAppTheme
                                                        .nearlyBlue,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                8.0)),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Icon(
                                                      Icons.add,
                                                      color:
                                                          DesignCourseAppTheme
                                                              .nearlyWhite,
                                                    ),
                                                  ),
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
                        padding: const EdgeInsets.only(
                            top: 24, bottom: 24, left: 16),
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
