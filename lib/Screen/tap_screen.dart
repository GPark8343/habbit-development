import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habbit/Screen/challenge_screen.dart';
import 'package:habbit/Screen/folder_screen.dart';
import 'package:habbit/Screen/insta_screen.dart';
import 'package:habbit/Screen/fame_screen.dart';
import 'package:habbit/Screen/repository_screen.dart';
import 'package:flutter/material.dart';
import 'package:habbit/Screen/test_screen.dart';
import 'package:habbit/widgets/buttons/add_story_button.dart';
import 'package:habbit/widgets/buttons/signout-button.dart';
import 'package:habbit/widgets/buttons/upload_button.dart';

class TapScreen extends StatefulWidget {
  const TapScreen({super.key});

  @override
  State<TapScreen> createState() => _TapScreenState();
}

class _TapScreenState extends State<TapScreen> {
  late List<Map<String, Object>> _pages; //
  int _selectedPageIndex = 0;
  late String admobBannerId;
  BannerAd? banner;
  @override
  void initState() {
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
      {'page': TestScreen(), 'title': 'Profile'},
      {'page': FameScreen(), 'title': 'Hall of Fame'},
      {'page': InstaScreen(), 'title': 'upload'},
      {'page': FolderScreen(), 'title': 'folder'},
      {'page': ChallengeScreen(), 'title': 'challenge'},
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  String title(int index) {
    if (index == 0) {
      return 'profile';
    }
    if (index == 1) {
      return 'hall of fame';
    }
    if (index == 2) {
      return 'upload';
    }
    if (index == 3) {
      return 'folder';
    }
    if (index == 4) {
      return 'challenge';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        children: [
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          SignOutButton(),
          Center(child: Text('*주의')),
          Text('단, 앱을 삭제하면 지금까지 모은 모든 폴더와 스토리가 삭제됩니다.'),
          Text('60일을 달성하면 해당 구글 계정에서 앱을 지워도 그 폴더의 데이터는 영구 보존됩니다.'),
          Text('(이 경우는 앱을 삭제하고 어느 기기든 다시 설치하면 해당 폴더와 스토리 복구)'),
        ],
      )),
      appBar: AppBar(
        title: Text(title(_selectedPageIndex)),
      ),
      body: SafeArea(
        child: _pages[_selectedPageIndex]['page'] as Widget,
        // AdWidget(ad: banner!)
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.white,
          currentIndex: _selectedPageIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.aspect_ratio_rounded),
                label: 'Profile'),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.aspect_ratio_rounded),
                label: 'Hall of Fame'),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.upload_file),
                label: 'upload'),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.category),
                label: 'folder'),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.fit_screen_outlined),
                label: 'challenge'),
          ]),
    );
  }
}
