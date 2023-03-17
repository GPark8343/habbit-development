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
  int _selectedPageIndex = 0;

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
      {'page': DesignCourseHomeScreen(), 'title': 'test'},
      {'page': InstaScreen(), 'title': 'upload'},
      {'page': ChallengeScreen(), 'title': 'challenge'},
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

  void _signOut() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
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

    List actionWidget(int chosenPageIndex) {
      if (chosenPageIndex == 0) {
        return [];
      } else if (chosenPageIndex == 1) {
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
      } else {
        return [];
      }
    }

    return Scaffold(
      drawerScrimColor: FitnessAppTheme.background,
      appBar: _selectedPageIndex == 0
          ? null
          : AppBar(
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
                icon: Icon(Icons.ten_mp_sharp),
                label: 'test'),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.upload_file),
                label: 'upload'),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.calendar_today),
                label: 'challenge'),
          ]),
    );
  }
}
