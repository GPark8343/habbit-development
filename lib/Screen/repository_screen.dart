import 'dart:io';
//addstorybutton 함부로 꺼내면 ㅈ됨 ancestor widget 어쩌구 에러남
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:habbit/Screen/story_detail_screen.dart';
import 'package:habbit/Screen/write_story_screen.dart';

import 'package:habbit/colors.dart';
import 'package:habbit/design_course/course_info_screen.dart';

import 'package:habbit/models/folder.dart';
import 'package:habbit/models/story.dart';
import 'package:habbit/providers/fame_repository_manage.dart';
import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habbit/widgets/image_input.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RepositoryScreen extends StatefulWidget {
  final Function? selectPage;
  RepositoryScreen({this.selectPage});
  static const routeName = '/repository';

  @override
  State<RepositoryScreen> createState() => _RepositoryScreenState();
}

class _RepositoryScreenState extends State<RepositoryScreen> {
  // final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  // List<ProductDetails> view = [];
  // Future fetch() async {
  //   final folderTitle =
  //       (ModalRoute.of(context)?.settings.arguments as Map)['folder_title'];
  //   final folderId =
  //       (ModalRoute.of(context)?.settings.arguments as Map)['folder_id'];
  //   final bool available = await _inAppPurchase.isAvailable();
  //   if (available) {
  //     Set<String> ids = Set<String>.from([
  //       "60challenge_registration_service",
  //     ]);
  //     ProductDetailsResponse res =
  //         await _inAppPurchase.queryProductDetails(ids);
  //     this.view = res.productDetails;

  //     /// 📌 소모 및 비소모 둘 다
  //     _inAppPurchase.purchaseStream.listen((List<PurchaseDetails> event) {
  //       PurchaseDetails e = event[0];

  //       /// 구매 여부 pendingCompletePurchase - 승인 true / 취소 false
  //       if (e.pendingCompletePurchase) {
  //         if (!mounted) return;
  //         FirebaseFirestore.instance.collection('fame_folder').add({
  //           'folder_title': folderTitle,
  //           'folderId': folderId,
  //           'consumerEmail': FirebaseAuth.instance.currentUser!.email,
  //         });

  //         Navigator.of(context)
  //             .push(MaterialPageRoute(builder: (context) => ThankPage()));
  //       }
  //     });
  //   }
  //   if (!mounted) return;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  // @override
  // void initState() {
  //   Future(this.fetch);
  //   loadInterstitial();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState>? scaffoldKey = GlobalKey<ScaffoldState>();
    Folder? folder;
    bool? isFame;
    bool? isRegistered;

    final folderId =
        (ModalRoute.of(context)?.settings.arguments as Map)['folder_id'];
    final category =
        (ModalRoute.of(context)?.settings.arguments as Map)['category'];
    var stories = Provider.of<StoryManage>(context, listen: false).items;
    Future first() async {
      //

//
      await Provider.of<StoryManage>(context, listen: false)
          .fetchAndSetStories();
      await Provider.of<FolderManage>(context, listen: false)
          .fetchAndSetFolders();
      folder = await Provider.of<FolderManage>(context, listen: false)
          .findById(folderId);
      stories = Provider.of<StoryManage>(context, listen: false).items;
      int numberOfStories = stories
          .where((element) => element.folderId == folderId)
          .toList()
          .length;

      isFame = numberOfStories >= 60;

      await FirebaseFirestore.instance
          .collection('fame_repository')
          .where('folderId', isEqualTo: folderId)
          .get()
          .then((value) => isRegistered = value.docs.isNotEmpty);
    }

    Folder findedFolder =
        Provider.of<FolderManage>(context, listen: false).findById(folderId);

    Widget AddStoryButton() {
      return IconButton(
          style: IconButton.styleFrom(backgroundColor: mainColor),
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.of(context).pushNamed(WriteStoryScreen.routeName,
                arguments: {
                  'folder': folder,
                  'stories': stories,
                  'category': category
                });
          });
    }

    Widget NotAbleButton() {
      return IconButton(
          style: IconButton.styleFrom(backgroundColor: Colors.grey),
          icon: Icon(Icons.highlight_off),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: Column(children: [Text('오늘 스토리를 업로드하였습니다.')]),
                    ),
                  );
                });
          });
    }

    Widget ActionButton1() {
      List<Story> storiesOfFoler =
          Provider.of<StoryManage>(context, listen: false)
              .items
              .where((element) => element.folderId == folderId)
              .toList();
      return storiesOfFoler
                  .where((element) {
                    DateTime now = DateTime.now();
                    DateTime dateTime = DateTime.parse(element.createdAt);
                    return DateTime.utc(
                            dateTime.year, dateTime.month, dateTime.day) ==
                        DateTime.utc(now.year, now.month, now.day);
                  })
                  .toList()
                  .length ==
              0
          ? AddStoryButton()
          : NotAbleButton();
    }

    Widget ActionButton2() {
      return IconButton(
          style: IconButton.styleFrom(
              backgroundColor: !(isRegistered ?? true) && (isFame ?? false)
                  ? mainColor
                  : Colors.grey),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: Column(children: [
                        !(isFame ?? false)
                            ? Text('명예의 전당에 올리려면 60일을 채워야 합니다.')
                            : (!(isRegistered ?? true)
                                ? Text('명예의 전당 등록이 완료되었습니다')
                                : Text('이미 등록되었습니다.'))
                      ]),
                    ),
                  );
                });
            !(isRegistered ?? true) && (isFame ?? false)
                ? Provider.of<FameRepositoryManage>(context, listen: false)
                    .registerFameStories(folder!, stories)
                : print('');
          },
          icon: !(isRegistered ?? true)
              ? Container(
                  width: MediaQuery.of(context).size.width / 360 * 20,
                  height: MediaQuery.of(context).size.width / 360 * 20,
                  child: Image.asset('assets/icons/trophy.png'))
              : Icon(Icons.highlight_off));
    }

    return Container(
      color: Color(0xFFF2F3F8),
      child: FutureBuilder(
        //  FutureBuilder는 서버에서 데이터를 모두 받아오기전 화면을 그려줄수 있게 되는 장점을 가진다.
        future: first(),
        builder: (ctx, snapshot) => Scaffold(
          backgroundColor: Colors.transparent,
          key: scaffoldKey,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: mainColor, //색변경
            ),
            title: Text(
              '습관 기록',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 360 * 25,
                  color: mainColor,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              ActionButton1(),
              ActionButton2(),
            ],
          ),
          body: snapshot.connectionState == ConnectionState.waiting
              ? SafeArea(
                  child: Center(
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                )
              : SafeArea(
                  child: Consumer<StoryManage>(
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '아직 스토리가 없습니다. 지금 만들어보세요',
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width /
                                    360 *
                                    15,
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                      builder: (ctx, greatStories, ch) {
                        List<Story> storiesOfFoler = greatStories.items
                            .where((element) => element.folderId == folderId)
                            .toList();
                        Widget isSameDate() {
                          return storiesOfFoler
                                      .where((element) {
                                        DateTime now = DateTime.now();
                                        DateTime dateTime =
                                            DateTime.parse(element.createdAt);
                                        return DateTime.utc(dateTime.year,
                                                dateTime.month, dateTime.day) ==
                                            DateTime.utc(
                                                now.year, now.month, now.day);
                                      })
                                      .toList()
                                      .length ==
                                  0
                              ? Container()
                              : Text('오늘 스토리를 업로드하였습니다.');
                        }

                        return storiesOfFoler.length <= 0
                            ? ch!
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: storiesOfFoler.length,
                                itemBuilder: (ctx, i) => Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          FileImage(storiesOfFoler[i].image),
                                    ),
                                    title: Text(
                                      storiesOfFoler[i].title,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              360 *
                                              15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                360 *
                                                1),
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.width /
                                                360 *
                                                1),
                                      ),
                                      child: ExpandableText(
                                        (storiesOfFoler[i].description)
                                            as String,
                                        prefixStyle: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        expandText: '더보기',
                                        collapseText: '접기',
                                        maxLines: 2,
                                        expandOnTextTap: true,
                                        collapseOnTextTap: true,
                                        linkColor: Colors.grey,
                                      ),
                                    ),
                                    // Text(
                                    //   maxLines: 1,
                                    //   overflow: TextOverflow.clip,
                                    //   (storiesOfFoler[i].description) as String,
                                    //   style: TextStyle(
                                    //       fontSize: MediaQuery.of(context)
                                    //               .size
                                    //               .width /
                                    //           360 *
                                    //           12,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    onTap: () {
                                      Route _createRoute() {
                                        return PageRouteBuilder(
                                          settings: RouteSettings(arguments: {
                                            'story_id': storiesOfFoler[i].id,
                                          }),
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              CourseInfoScreen(
                                                  selectPage:
                                                      widget.selectPage),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            const begin = Offset(0.0, 1.0);
                                            const end = Offset.zero;
                                            const curve = Curves.ease;

                                            var tween = Tween(
                                                    begin: begin, end: end)
                                                .chain(
                                                    CurveTween(curve: curve));

                                            return SlideTransition(
                                              position: animation.drive(tween),
                                              child: child,
                                            );
                                          },
                                        );
                                      }

                                      Navigator.of(context)
                                          .push(_createRoute());
                                    },
                                    trailing: Text(
                                      '자세히 보기',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              );
                      }),
                ),
        ),
      ),
    );
  }
}

class ThankPage extends StatelessWidget {
  const ThankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '감사합니다!',
            style: TextStyle(
              color: mainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: IconThemeData(
            color: mainColor, //색변경
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Text(
              "첼린지 폴더로 업그레이드 완료🍭",
              style: TextStyle(
                color: mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }
}
