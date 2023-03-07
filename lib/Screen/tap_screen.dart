import 'dart:async';
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habbit/Screen/challenge_screen.dart';
import 'package:habbit/Screen/folder_screen.dart';
import 'package:habbit/Screen/insta_screen.dart';
import 'package:habbit/Screen/fame_screen.dart';
import 'package:habbit/Screen/repository_screen.dart';
import 'package:flutter/material.dart';
import 'package:habbit/Screen/profile_screen.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/widgets/buttons/add_folder_button.dart';
import 'package:habbit/widgets/buttons/add_story_button.dart';
import 'package:habbit/widgets/buttons/signout-button.dart';
import 'package:habbit/widgets/buttons/upload_button.dart';

class TapScreen extends StatefulWidget {
  const TapScreen({super.key});
  static const routeName = '/tap';
  @override
  State<TapScreen> createState() => _TapScreenState();
}

class _TapScreenState extends State<TapScreen> {
  late List<Map<String, Object>> _pages; //
  int _selectedPageIndex = 2;
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
      {'page': ProfileScreen(), 'title': 'Profile'},
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

  List actionWidget(int chosenPageIndex) {
    if (chosenPageIndex == 0) {
      return [
        PopupMenuButton(
          itemBuilder: (_) => [
            PopupMenuItem(
              child: SignOutButton(),
            ),
          ],
          icon: Icon(Icons.settings),
        )
      ];
    } else if (chosenPageIndex == 1) {
      return [];
    } else if (chosenPageIndex == 2) {
      return [];
    } else if (chosenPageIndex == 3) {
      return [AddFolderButton()];
    } else if (chosenPageIndex == 4) {
      return [];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: mainColor,
      appBar: AppBar(
        // actions: [SignOutButton()],
        actions: [...actionWidget(_selectedPageIndex)],
        iconTheme: IconThemeData(color: mainColor),
        title: Row(
          children: [
            Image.asset('assets/logos/header_logo.png',
                width: MediaQuery.of(context).size.width / 360 * 45,
                height: MediaQuery.of(context).size.width / 360 * 45),
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
          backgroundColor: Colors.white,
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
          ]),
    );
  }
}
