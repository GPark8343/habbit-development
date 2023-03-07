import 'dart:io';
//addstorybutton 함부로 꺼내면 ㅈ됨 ancestor widget 어쩌구 에러남
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habbit/Screen/story_detail_screen.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/models/folder.dart';
import 'package:habbit/models/story.dart';
import 'package:habbit/providers/fame_repository_manage.dart';
import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:habbit/widgets/buttons/add_story_button.dart';
import 'package:habbit/widgets/image_input.dart';
import 'package:provider/provider.dart';

class RepositoryScreen extends StatefulWidget {
  static const routeName = '/repository';
  const RepositoryScreen({super.key});

  @override
  State<RepositoryScreen> createState() => _RepositoryScreenState();
}

class _RepositoryScreenState extends State<RepositoryScreen> {
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
    final stories = Provider.of<StoryManage>(context, listen: false).items;
    Future first() async {
      await Provider.of<StoryManage>(context, listen: false)
          .fetchAndSetStories();
      await Provider.of<FolderManage>(context, listen: false)
          .fetchAndSetFolders();
      folder = await Provider.of<FolderManage>(context, listen: false)
          .findById(folderId);
      int numberOfStories = stories
          .where((element) => element.folderId == folder?.id)
          .toList()
          .length;
      isFame = numberOfStories >= 60;
      await FirebaseFirestore.instance
          .collection('fame_repository')
          .where('folderId', isEqualTo: folderId)
          .get()
          .then((value) => isRegistered = value.docs.isNotEmpty);
      print(isFame);
      print(isRegistered);
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
      return ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: mainColor),
          child: Text('add your story'),
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
                                  Text('write your story'),
                                 
                                  ImageInput(_selectImage),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width /
                                        360 *
                                        10,
                                  ),
                                  TextFormField(
                                    controller: _descriptionController,
                                    decoration: InputDecoration(
                                        labelText: 'Description'),
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
                          // Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.add),
                        label: Text('Add Story'),
                      )
                    ],
                  );
                });
          });
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
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        !(isRegistered ?? true) && (isFame ?? false)
                            ? mainColor
                            : Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                  !(isRegistered ?? true) && (isFame ?? false)
                      ? Provider.of<FameRepositoryManage>(context,
                              listen: false)
                          .registerFameStories(folder!, stories)
                      : print('');
                },
                child: Text((isRegistered ?? true) ? '이미 등록됨' : '명예의 전당 등록'))
          ],
        ),
        body: snapshot.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<StoryManage>(
                child: Center(
                    child: Column(
                  children: [
                    AddStoryButton(),
                    const Text('Got no stories yet, start adding some!'),
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
                        ? AddStoryButton()
                        : Text('오늘 스토리를 업로드하였습니다.');
                  }

                  return storiesOfFoler.length <= 0
                      ? ch!
                      : SingleChildScrollView(
                        child: Column(
                            children: [
                              isSameDate(),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: storiesOfFoler.length,
                                itemBuilder: (ctx, i) => Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          FileImage(storiesOfFoler[i].image),
                                    ),
                                    title: Text(storiesOfFoler[i].title),
                                    subtitle: Text((storiesOfFoler[i].description)
                                        as String),
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
                                        '${storiesOfFoler[i].category} 업로드 ? ${storiesOfFoler[i].isUploaded == 0 ? false : true}'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      );
                }),
      ),
    );
  }
}
