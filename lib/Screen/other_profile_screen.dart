import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:habbit/Screen/edit_profile_screen.dart';
import 'package:habbit/Screen/other_post_detail_screen.dart';
import 'package:habbit/Screen/post_detail_screen.dart';
import 'package:habbit/Screen/story_detail_screen.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:habbit/widgets/avatar_widget.dart';
import 'package:habbit/widgets/buttons/signout-button.dart';
import 'package:habbit/widgets/deco.dart';
import 'package:habbit/widgets/image_frame.dart';
import 'package:habbit/widgets/user_card.dart';
import 'package:provider/provider.dart';

class OtherProfileScreen extends StatefulWidget {
  static const routeName = '/other-profile';
  const OtherProfileScreen({super.key});

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final uid = (ModalRoute.of(context)?.settings.arguments as Map)['uid'];

    Widget _statisticsOne(String title, int value) {
      return Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 360 * 20,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 360 * 15,
              color: textColor,
            ),
          ),
        ],
      );
    }

    Widget _title() {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: uid)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  color: Colors.white,
                ),
              );
            }
            final docs = snapshot.data?.docs;

            return Text(
              docs!.first.data()['nickname'],
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 360 * 25,
                  color: mainColor,
                  fontWeight: FontWeight.bold),
            );
          });
    }

    Widget _information() {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: uid)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  color: Colors.white,
                ),
              );
            }
            final docs = snapshot.data?.docs;

            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 360 * 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AvatarWidget(
                        type: AvatarType.TYPE3,
                        thumbPath: docs!.first.data()['thumbnail'], //
                        size: MediaQuery.of(context).size.width / 360 * 80,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 360 * 10),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(child: _statisticsOne('Level', 1)),
                            Expanded(child: _statisticsOne('Followers', 0)),
                            Expanded(child: _statisticsOne('Following', 0)),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.width / 360 * 10),
                ],
              ),
            );
          });
    }

    Widget _tabView() {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .where('userId', isEqualTo: uid)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  color: Colors.white,
                ),
              );
            }
            final docs = snapshot.data?.docs;
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: docs?.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    await Provider.of<StoryManage>(context, listen: false)
                        .fetchAndSetStories(); // update db information
                    Route _createRoute2() {
                      return PageRouteBuilder(
                        settings: RouteSettings(arguments: {
                          'story_id': docs[index]['uid'],
                          'created_at': docs[index]['created_at'],
                          'title': docs[index]['title'],
                          'image': docs[index]['thumbnail'],
                          'description': docs[index]['description'],
                          'category': docs[index]['category'],
                        }),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            OtherPostDetailScreen(),
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

                    await Navigator.of(context).push(_createRoute2());
                  },
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: docs![index]['thumbnail'],
                    placeholder: (context, url) => Center(
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: mainColor, //색변경
          ),
          title: _title()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.width / 360 * 10),
            _information(),
            SizedBox(height: MediaQuery.of(context).size.width / 360 * 20),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width / 360 * 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width / 360 * 3),
                border: Border.all(
                  color: const Color(0xffdedede),
                ),
              ),
              child: Text(
                '포스트',
                style: TextStyle(
                  color: textColor,
                  fontSize: MediaQuery.of(context).size.width / 360 * 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width / 360 * 5),
            Divider(
                color: backgroundColor,
                thickness: MediaQuery.of(context).size.width / 360 * 2.0),
            SizedBox(height: MediaQuery.of(context).size.width / 360 * 5),
            _tabView(),
          ],
        ),
      ),
    );
  }
}


// Column(
//       children: [
//         CategoryFilter(),
//         Container(
//           color: Colors.green,
//           height: 2,
//         ),
//         SelectedCategories()
//       ],
//     );