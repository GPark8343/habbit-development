import 'dart:io';
//addstorybutton 함부로 꺼내면 ㅈ됨 ancestor widget 어쩌구 에러남
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habbit/Screen/story_detail_screen.dart';

import 'package:habbit/colors.dart';
import 'package:habbit/models/folder.dart';
import 'package:habbit/models/story.dart';
import 'package:habbit/providers/fame_repository_manage.dart';
import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/story_manage.dart';

import 'package:habbit/widgets/image_input.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

class RepositoryScreen extends StatefulWidget {
  static const routeName = '/repository';
  const RepositoryScreen({super.key});

  @override
  State<RepositoryScreen> createState() => _RepositoryScreenState();
}

class _RepositoryScreenState extends State<RepositoryScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> view = [];
  Future fetch() async {
    final folderId =
        (ModalRoute.of(context)?.settings.arguments as Map)['folder_id'];
    final bool available = await _inAppPurchase.isAvailable();
    if (available) {
      Set<String> ids = Set<String>.from([
        "challenge_registration_service",
      ]);
      ProductDetailsResponse res =
          await _inAppPurchase.queryProductDetails(ids);
      this.view = res.productDetails;

      /// 📌 소모 및 비소모 둘 다
      _inAppPurchase.purchaseStream.listen((List<PurchaseDetails> event) {
        PurchaseDetails e = event[0];
        print(
            "📌 EVENT $e ${e.status} ${e.productID} ${e.pendingCompletePurchase}");

        /// 구매 여부 pendingCompletePurchase - 승인 true / 취소 false
        if (e.pendingCompletePurchase) {
          if (!mounted) return;
          FirebaseFirestore.instance
              .collection('fame_folder')
              .add({'folderId': folderId});

          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ThankPage()));
        }
      });
    }
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    Future(this.fetch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState>? scaffoldKey = GlobalKey<ScaffoldState>();
    Folder? folder;
    bool? isFame;
    bool? isRegistered;
    bool? isFameFolder;
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
      await FirebaseFirestore.instance
          .collection('fame_folder')
          .where('folderId', isEqualTo: folderId)
          .get()
          .then((value) => isFameFolder = value.docs.isNotEmpty);
      print(folderId);
      print(stories);

      print('${isFame}isFame');
      print('${numberOfStories}numberOfStories');
      print('${isRegistered}isRegistered');
    }

    final _priceFocusNode = FocusNode();
    final _descriptionFocusNode = FocusNode();

    final _descriptionController = TextEditingController();

    File? _pickedImage;
    Folder findedFolder =
        Provider.of<FolderManage>(context, listen: false).findById(folderId);

    void _selectImage(File pickedImage) {
      _pickedImage = pickedImage;
    }

    void _saveStory() async {
      if (_pickedImage == null || _descriptionController.text.isEmpty) {
        Navigator.of(context).pop(); // 빈 스토리는 작성 못하게 해야 함
        return;
      }
      await Provider.of<StoryManage>(context, listen: false)
          .fetchAndSetStories();
      await Provider.of<FolderManage>(context, listen: false)
          .fetchAndSetFolders();
      int numberOfStories = stories
          .where((element) => element.folderId == folder?.id)
          .toList()
          .length;
      await Provider.of<StoryManage>(context, listen: false).addStories(
          '${numberOfStories + 1}일차',
          _pickedImage!,
          _descriptionController.text,
          category,
          folderId);
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

    Widget AddStoryButton() {
      return IconButton(
          style: IconButton.styleFrom(backgroundColor: mainColor),
          icon: Icon(Icons.edit),
          onPressed: () {
            showDialog(
                context: scaffoldKey!.currentContext!,
                builder: (context) {
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width /
                                      360 *
                                      10.0),
                              child: Column(
                                children: [
                                  Text('스토리를 작성하세요',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              360 *
                                              15,
                                          color: mainColor,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width /
                                        360 *
                                        10,
                                  ),
                                  ImageInput(_selectImage),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width /
                                        360 *
                                        10,
                                  ),
                                  TextFormField(
                                    controller: _descriptionController,
                                    decoration:
                                        InputDecoration(labelText: '설명'),
                                    maxLines: 3,
                                    keyboardType: TextInputType.multiline,
                                    focusNode: _descriptionFocusNode,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter a description.';
                                      }
                                      if (value.length < 10) {
                                        return 'Should be  at least 10 characters long.';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: Colors.white,
                            backgroundColor: mainColor),
                        onPressed: () {
                          _saveStory();
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                    child: Column(
                                        children: [Text('스토리 업로드가 완료되었습니다.')]),
                                  ),
                                );
                              });
                        },
                        icon: Icon(Icons.add),
                        label: Text('스토리 추가하기 '),
                      )
                    ],
                  );
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
      return (isFameFolder ?? false)
          ? IconButton(
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
                                    ? Text('등록하는데 1분이 걸립니다. 앱을 종료하지 마세요')
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
                  : Icon(Icons.highlight_off))
          : IconButton(
              onPressed: () async {
                final PurchaseParam purchaseParam =
                    PurchaseParam(productDetails: this.view[0]);
                await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("60일 첼린지 시작"),
                          content: SingleChildScrollView(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('  혜택:'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('1. 첼린지 스크린이 활성화됩니다'),
                              Text('2. 60일을 달성할 시 명예의 전당 등록 권한을 얻게 됩니다.'),
                              Text('3. 혜택 더 추가 예정'),
                            ],
                          )),
                          actions: [
                            TextButton(
                              child: Text(
                                "첼린지 폴더로 업그레이드",
                                style: TextStyle(
                                    color: mainColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                bool c = await _inAppPurchase.buyConsumable(
                                    purchaseParam: purchaseParam);

                                /// popup 나타나는 여부
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(
                                "닫기",
                                style: TextStyle(
                                    color: mainColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async =>
                                  Navigator.of(context).pop(),
                            )
                          ],
                        ));
              },
              icon: Icon(Icons.app_registration));
    }

    return FutureBuilder(
      //  FutureBuilder는 서버에서 데이터를 모두 받아오기전 화면을 그려줄수 있게 되는 장점을 가진다.
      future: first(),
      builder: (ctx, snapshot) => Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: mainColor, //색변경
          ),
          title: Text(
            'repository',
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
                              fontSize:
                                  MediaQuery.of(context).size.width / 360 * 15,
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
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                360 *
                                                15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    (storiesOfFoler[i].description) as String,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                360 *
                                                12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    Route _createRoute() {
                                      return PageRouteBuilder(
                                        settings: RouteSettings(arguments: {
                                          'story_id': storiesOfFoler[i].id,
                                        }),
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            StoryDetailScreen(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(0.0, 1.0);
                                          const end = Offset.zero;
                                          const curve = Curves.ease;

                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));

                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                      );
                                    }

                                    Navigator.of(context).push(_createRoute());
                                  },
                                  trailing: Text(
                                    '업로드 ? ${storiesOfFoler[i].isUploaded == 0 ? false : true}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                    }),
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
        body: Center(
          child: Text(
            "첼린지 폴더로 업그레이드 완료🍭",
            style: TextStyle(
              color: mainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }
}
