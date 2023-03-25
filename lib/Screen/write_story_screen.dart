import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:habbit/widgets/image_input.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

//addstorybutton 함부로 꺼내면 ㅈ됨 ancestor widget 어쩌구 에러남
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:habbit/Screen/story_detail_screen.dart';

import 'package:habbit/design_course/course_info_screen.dart';

import 'package:habbit/models/folder.dart';
import 'package:habbit/models/story.dart';
import 'package:habbit/providers/fame_repository_manage.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class WriteStoryScreen extends StatefulWidget {
  static const routeName = '/write-story';

  const WriteStoryScreen({super.key});

  @override
  State<WriteStoryScreen> createState() => _WriteStoryScreenState();
}

class _WriteStoryScreenState extends State<WriteStoryScreen> {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final _descriptionController = TextEditingController(); //이거 빌드 전에 설정해놓아야 함
  void onAdLoaded(InterstitialAd ad) {
    _interstitialAd = ad;
    _isAdLoaded = true;

    _interstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
      _interstitialAd?.dispose();
    }, onAdFailedToShowFullScreenContent: (ad, error) {
      _interstitialAd?.dispose();
    });
  }

  void loadInterstitial() async {
    InterstitialAd.load(
      adUnitId:
          // 'ca-app-pub-3940256099942544/1033173712',
          'ca-app-pub-7806371932663728/1349927845',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: (LoadAdError error) {
          // nothing to do
        },
      ),
    );
  }

  void showInterstitial() {
    if (_isAdLoaded) {
      _interstitialAd?.show();
    }
  }

  @override
  void initState() {
    loadInterstitial();
    super.initState();
  }

  File? _pickedImage;
  @override
  Widget build(BuildContext context) {
    final stories = ((ModalRoute.of(context)?.settings.arguments
        as Map)['stories'] as List<Story>);
    final folder = ((ModalRoute.of(context)?.settings.arguments
        as Map)['folder'] as Folder);
    final category =
        (ModalRoute.of(context)?.settings.arguments as Map)['category'];

    void _selectImage(File pickedImage) {
      _pickedImage = pickedImage;
    }

    void _saveStory() async {
      if (_pickedImage == null || _descriptionController.text.isEmpty) {
        // 빈 스토리는 작성 못하게 해야 함
        return;
      }

      await Provider.of<StoryManage>(context, listen: false)
          .fetchAndSetStories();
      await Provider.of<FolderManage>(context, listen: false)
          .fetchAndSetFolders();

      int numberOfStories = stories
          .where((element) => element.folderId == folder.id)
          .toList()
          .length;
      await Provider.of<StoryManage>(context, listen: false).addStories(
          '${numberOfStories + 1}일차',
          _pickedImage!,
          _descriptionController.text,
          category,
          folder.id);
      // Provider.of<FolderManage>(context, listen: false)
      //     .plusOneDay(findedFolder);
      Navigator.of(context).pop();
    }

    @override
    void dispose() {
      _priceFocusNode.dispose();
      _descriptionFocusNode.dispose();
      super.dispose();
    }

    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(
              color: mainColor, //색변경
            ),
            title: Text(
              '스토리 수정',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 360 * 25,
                  color: mainColor,
                  fontWeight: FontWeight.bold),
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width / 360 * 10.0),
            child: Column(
              children: [
                Text('오늘의 스토리',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 360 * 15,
                        color: mainColor,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 360 * 10,
                ),
                ImageInput(_selectImage),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 360 * 10,
                ),
                //  TextFormField(
                //       focusNode: _descriptionFocusNode,
                //       validator: (value) {
                //         if (value!.isEmpty) {
                //           return 'Please enter a description.';
                //         }
                //         if (value.length < 10) {
                //           return 'Should be  at least 10 characters long.';
                //         }
                //         return null;
                //       },
                //       controller: _descriptionController,
                //       decoration: InputDecoration(
                //           hintText: '운동 1일차 오늘도 성공!',
                //           label: Row(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Icon(Icons.edit_note),
                //               Padding(
                //                 padding: EdgeInsets.only(
                //                     left: MediaQuery.of(context).size.width /
                //                         360 *
                //                         8),
                //                 child: Text('스토리 내용 작성'),
                //               )
                //             ],
                //           )),
                //       maxLines: 8,
                //       keyboardType: TextInputType.multiline,
                //     ),

                Stack(
                  children: [
                    for (int i = 0; i < 3; i++)
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width /
                              360 *
                              (4 + (i + 1) * 28),
                          left: MediaQuery.of(context).size.width / 360 * 15,
                          right: MediaQuery.of(context).size.width / 360 * 15,
                        ),
                        height: MediaQuery.of(context).size.width / 360 * 1,
                        color: Colors.black,
                      ),
                    Stack(
                      children: [
                        for (int i = 0; i < 3; i++)
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width /
                                  360 *
                                  (4 + (i + 1) * 28),
                              left:
                                  MediaQuery.of(context).size.width / 360 * 15,
                              right:
                                  MediaQuery.of(context).size.width / 360 * 15,
                            ),
                            height: MediaQuery.of(context).size.width / 360 * 1,
                            color: Colors.black,
                          ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 360 * 96,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width /
                                    360 *
                                    15),
                            child: TextField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '운동 10일차 오늘도 성공!',
                              ),
                              cursorHeight:
                                  MediaQuery.of(context).size.width / 360 * 22,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width /
                                    360 *
                                    20.0,
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 360 * 30,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: Colors.white,
                      backgroundColor: mainColor),
                  onPressed: () {
                    _saveStory();
                    (_pickedImage == null ||
                            _descriptionController.text.isEmpty)
                        ? null
                        : Navigator.of(context).pop();

                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: SingleChildScrollView(
                              child: Column(children: [
                                _pickedImage == null
                                    ? Text('스토리에 올릴 사진을 올려주세요.')
                                    : (_descriptionController.text.isEmpty
                                        ? Text('스토리에 대한 설명을 적어주세요.')
                                        : Text('스토리 업로드가 완료되었습니다.'))
                              ]),
                            ),
                          );
                        });
                    (_pickedImage == null ||
                            _descriptionController.text.isEmpty)
                        ? null
                        : showInterstitial();
                  },
                  icon: Icon(Icons.add),
                  label: Text('스토리 추가하기 '),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 360 * 30,
                ),
                Text('스토리 작성 시 다음과 같은 이용약관에 동의하는 것으로 간주합니다.',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 360 * 15,
                        color: mainColor,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 360 * 10,
                ),
                Text.rich(
                  TextSpan(
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                      //make link blue and underline
                      text: "https://sites.google.com/view/habbit-terms-of-use",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          //on tap code here, you can navigate to other page or URL
                          String url =
                              "https://sites.google.com/view/habbit-terms-of-use";
                          var urllaunchable = await canLaunch(
                              url); //canLaunch is from url_launcher package
                          if (urllaunchable) {
                            await launch(
                                url); //launch is from url_launcher package to launch URL
                          } else {}
                        }),
                ),
              ],
            ),
          ),
        ));
  }
}
