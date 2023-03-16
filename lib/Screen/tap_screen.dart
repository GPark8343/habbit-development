import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habbit/Screen/ban_screen.dart';
import 'package:habbit/Screen/challenge_screen.dart';
import 'package:habbit/Screen/explain_screen.dart';
import 'package:habbit/Screen/folder_screen.dart';
import 'package:habbit/Screen/insta_screen.dart';
import 'package:habbit/Screen/fame_screen.dart';
import 'package:habbit/design_course/course_info_screen.dart';
import 'package:habbit/design_course/home_design_course.dart';
import 'package:habbit/test/test_screen.dart';
import 'package:habbit/Screen/tutorial_screen.dart';
import 'package:habbit/Screen/repository_screen.dart';
import 'package:flutter/material.dart';
import 'package:habbit/Screen/profile_screen.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/fitness_app/fitness_app_theme.dart';
import 'package:habbit/fitness_app/models/tabIcon_data.dart';
import 'package:habbit/fitness_app/my_diary/my_diary_screen.dart';
import 'package:habbit/introduction_animation/tutorial_screen.dart';
import 'package:habbit/providers/category_manage.dart';
import 'package:habbit/widgets/buttons/add_folder_button.dart';

import 'package:habbit/widgets/buttons/signout-button.dart';
import 'package:habbit/widgets/buttons/upload_button.dart';
import 'package:provider/provider.dart';

class TapScreen extends StatefulWidget {
  const TapScreen({super.key});
  static const routeName = '/tap';
  @override
  State<TapScreen> createState() => _TapScreenState();
}

class _TapScreenState extends State<TapScreen> with TickerProviderStateMixin {
  AnimationController? animationController;

  Widget tabBody = Container(
    color: FitnessAppTheme.background,
  );

  late List<Map<String, Object>> _pages; //
  int _selectedPageIndex = 2;

  late String admobBannerId;
  BannerAd? banner;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    admobBannerId = "ca-app-pub-3940256099942544/6300978111";
    banner = BannerAd(
      size: AdSize.banner,
      adUnitId: admobBannerId,
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) {},
        onAdLoaded: (_) {},
      ),
      request: AdRequest(),
    )..load();
    _pages = [
      {'page': ProfileScreen(), 'title': 'Profile'},
      {'page': FameScreen(), 'title': 'Hall of Fame'},
      {'page': InstaScreen(), 'title': 'upload'},
      {'page': FolderScreen(), 'title': 'folder'},
      {'page': ChallengeScreen(), 'title': 'challenge'},
      {'page': DesignCourseHomeScreen(), 'title': 'test'},
    ];

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    // var pickedCategory =
    //     Provider.of<CategoryManage>(context, listen: false).category;
    // changeCategory(String selectedCategory) {
    //   Provider.of<CategoryManage>(context, listen: false)
    //       .changeCategory(selectedCategory);
    // }

    void _signOut() {
      FirebaseAuth.instance.signOut();
      GoogleSignIn().signOut();
    }

    List actionWidget(int chosenPageIndex) {
      if (chosenPageIndex == 0) {
        return [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog<bool>(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            content: Text('앱을 종료할까요?'),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: mainColor),
                                child: Text('아니오.'),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: mainColor),
                                child: Text('네. 종료합니다.'),
                                onPressed: () {
                                  Navigator.of(context).pop(true);

                                  _signOut();

                                  // 화면 업데이트 추가
                                },
                              ),
                            ],
                          );
                        });
                  });
                },
                child: SignOutButton(),
              ),
            ],
            icon: Icon(Icons.settings),
          ),
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushNamed(BanScreen.routeName);
                    });
                  },
                  child: Center(
                    child: Container(
                      color: Colors.white,
                      child: Text(
                        '차단 리스트',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width / 360 * 15,
                            color: mainColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ];
      } else if (chosenPageIndex == 1) {
        return [];
      } else if (chosenPageIndex == 2) {
        return [
          // PopupMenuButton(
          //   itemBuilder: (_) => [
          //     PopupMenuItem(
          //       child: GestureDetector(
          //         child: Text(
          //           '전부',
          //           style: TextStyle(
          //               fontSize: MediaQuery.of(context).size.width / 360 * 15,
          //               color: mainColor,
          //               fontWeight: FontWeight.bold),
          //         ),
          //         onTap: () {
          //           changeCategory('all');
          //           print(pickedCategory);
          //         },
          //       ),
          //     ),
          //     PopupMenuItem(
          //       child: GestureDetector(
          //         child: Text(
          //           '독서',
          //           style: TextStyle(
          //               fontSize: MediaQuery.of(context).size.width / 360 * 15,
          //               color: mainColor,
          //               fontWeight: FontWeight.bold),
          //         ),
          //         onTap: () {
          //           changeCategory('reading');
          //           print(pickedCategory);
          //         },
          //       ),
          //     ),
          //     PopupMenuItem(
          //       child: GestureDetector(
          //         child: Text(
          //           '운동',
          //           style: TextStyle(
          //               fontSize: MediaQuery.of(context).size.width / 360 * 15,
          //               color: mainColor,
          //               fontWeight: FontWeight.bold),
          //         ),
          //         onTap: () {
          //           changeCategory('exercise');
          //           print(pickedCategory);
          //         },
          //       ),
          //     ),
          //     PopupMenuItem(
          //       child: GestureDetector(
          //         child: Text(
          //           '언어',
          //           style: TextStyle(
          //               fontSize: MediaQuery.of(context).size.width / 360 * 15,
          //               color: mainColor,
          //               fontWeight: FontWeight.bold),
          //         ),
          //         onTap: () {
          //           changeCategory('language');
          //           print(pickedCategory);
          //         },
          //       ),
          //     ),
          //     PopupMenuItem(
          //       child: GestureDetector(
          //         child: Text(
          //           '공부',
          //           style: TextStyle(
          //               fontSize: MediaQuery.of(context).size.width / 360 * 15,
          //               color: mainColor,
          //               fontWeight: FontWeight.bold),
          //         ),
          //         onTap: () {
          //           changeCategory('study');
          //           print(pickedCategory);
          //         },
          //       ),
          //     ),
          //     PopupMenuItem(
          //       child: GestureDetector(
          //         child: Text(
          //           '기타',
          //           style: TextStyle(
          //               fontSize: MediaQuery.of(context).size.width / 360 * 15,
          //               color: mainColor,
          //               fontWeight: FontWeight.bold),
          //         ),
          //         onTap: () {
          //           changeCategory('etc');
          //           print(pickedCategory);
          //         },
          //       ),
          //     ),
          //   ],
          //   icon: Container(
          //       width: MediaQuery.of(context).size.width / 360 * 20,
          //       height: MediaQuery.of(context).size.width / 360 * 20,
          //       child: Image.asset('assets/icons/category.png')),
          // ),
          PopupMenuButton(
            itemBuilder: (ctx) => [
              PopupMenuItem(
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushNamed(TutorialScreen.routeName);
                    });
                  },
                  child: Center(
                    child: Container(
                      color: Colors.white,
                      child: Text(
                        '튜토리얼',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width / 360 * 15,
                            color: mainColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
              // PopupMenuItem(
              // onTap: () {
              //   WidgetsBinding.instance.addPostFrameCallback((_) {
              //     Navigator.of(context).pushNamed(ExplainScreen.routeName);
              //   });
              // },
              // child: Center(
              //   child: Container(
              //     color: Colors.white,
              //     child: Text(
              //       '첼린지 유의사항',
              //       style: TextStyle(
              //           fontSize:
              //               MediaQuery.of(context).size.width / 360 * 15,
              //           color: mainColor,
              //           fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // )),
            ],
            icon: Icon(Icons.help_outline_sharp),
          )
        ];
      } else if (chosenPageIndex == 3) {
        return [AddFolderButton()];
      } else if (chosenPageIndex == 4) {
        return [];
      } else {
        return [];
      }
    }

    return Scaffold(
      drawerScrimColor: FitnessAppTheme.background,
      appBar: AppBar(
        // actions: [SignOutButton()],
        actions: [...actionWidget(_selectedPageIndex)],
        iconTheme: IconThemeData(color: mainColor),
        title: Row(
          children: [
            // Image.asset('assets/logos/header_logo.png',
            //     width: MediaQuery.of(context).size.width / 360 * 45,
            //     height: MediaQuery.of(context).size.width / 360 * 45),
            SizedBox(width: MediaQuery.of(context).size.width / 360 * 15),
            Text(
              'Habbit',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 360 * 25,
                  color: mainColor,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: _pages[_selectedPageIndex]['page'] as Widget,
        // AdWidget(ad: banner!)
      ),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: mainColor,
          onTap: _selectPage,
          backgroundColor: FitnessAppTheme.background,
          unselectedItemColor: blackColor,
          currentIndex: _selectedPageIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.person_2_outlined),
                label: 'Profile'),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.aspect_ratio_rounded),
                label: 'Fame'),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.upload_file),
                label: 'upload'),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.folder_open_rounded),
                label: 'folder'),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.calendar_today),
                label: 'challenge'),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.ten_mp_sharp),
                label: 'test'),
          ]),
    );
  }
}
