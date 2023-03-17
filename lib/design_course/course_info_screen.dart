import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/models/folder.dart';
import 'package:habbit/models/i_user.dart';
import 'package:habbit/models/post.dart';
import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:habbit/providers/upload.dart';
import 'package:provider/provider.dart';
import 'design_course_app_theme.dart';

class CourseInfoScreen extends StatefulWidget {
  static const routeName = '/course-info';
  @override
  _CourseInfoScreenState createState() => _CourseInfoScreenState();
}

class _CourseInfoScreenState extends State<CourseInfoScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
  }

  @override
  dispose() {
    animationController?.dispose(); // you need this
    super.dispose();
  }

  Future<void> setData() async {
    animationController?.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double infoHeight = MediaQuery.of(context).size.width / 360 * 360;
    final storyId =
        (ModalRoute.of(context)?.settings.arguments as Map)['story_id'];

    final upload = Provider.of<Upload>(context, listen: false);
    final selectedStory =
        Provider.of<StoryManage>(context, listen: false).findById(storyId);
    var isUploaded = selectedStory.isUploaded;

    DateTime now = DateTime.now();
    DateTime dateTime = DateTime.parse(selectedStory.createdAt == 'createdAt'
        ? DateTime.now().toString()
        : selectedStory.createdAt);
    var isToday = DateTime.utc(dateTime.year, dateTime.month, dateTime.day) ==
        DateTime.utc(now.year, now.month, now.day);

    fetchAndSetStories() {
      Provider.of<StoryManage>(context, listen: false).fetchAndSetStories();
    }

    deletePost(String selectedStoryId) {
      if (selectedStory.id == 'no_found') {
        Provider.of<Upload>(context, listen: false).deletePost(selectedStoryId);
      } else {
        Provider.of<StoryManage>(context, listen: false)
            .changeIsUploaded(selectedStory);
        Provider.of<Upload>(context, listen: false).deletePost(selectedStoryId);
      }
    }

    deleteStory(String selectedStoryId) {
      Folder findedFolder = Provider.of<FolderManage>(context, listen: false)
          .findById(selectedStory.folderId);
      Provider.of<StoryManage>(context, listen: false)
          .deleteStories(selectedStoryId);
      Provider.of<StoryManage>(context, listen: false).fetchAndSetStories();
      // Provider.of<FolderManage>(context, listen: false)
      //     .minusOneDay(findedFolder);
    }

    deleteStoryAndPost(String selectedStoryId) {
      Provider.of<Upload>(context, listen: false).deletePost(selectedStoryId);
      Folder findedFolder = Provider.of<FolderManage>(context, listen: false)
          .findById(selectedStory.folderId);
      Provider.of<StoryManage>(context, listen: false)
          .deleteStories(selectedStoryId);
      // Provider.of<FolderManage>(context, listen: false)
      //     .minusOneDay(findedFolder);
    }

    _uploadPost() async {
      IUser? userInfo =
          await upload.loadUserByUid(FirebaseAuth.instance.currentUser!.uid);
      upload.uploadPost(
          Post(
              title: selectedStory.title,
              userId: FirebaseAuth.instance.currentUser!.uid,
              userInfo: userInfo,
              description: selectedStory.description,
              uid: selectedStory.id,
              createdAt: DateTime.now(),
              category: selectedStory.category),
          selectedStory.image,
          selectedStory.folderId);
      await Provider.of<StoryManage>(context, listen: false)
          .changeIsUploaded(selectedStory);
      await fetchAndSetStories();
    }

    String CategoryWord(String selectedCategory) {
      if (selectedCategory == 'Kind.Reading') {
        return '독서';
      } else if (selectedCategory == 'Kind.Exercise') {
        return '운동';
      } else if (selectedCategory == 'Kind.Language') {
        return '언어';
      } else if (selectedCategory == 'Kind.Study') {
        return '공부';
      } else {
        return '기타';
      }
    }

    final GlobalKey<ScaffoldState>? _scaffoldKey = GlobalKey<ScaffoldState>();
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    return FutureBuilder(
        future: Provider.of<StoryManage>(context, listen: false)
            .fetchAndSetStories(),
        builder: (context, futureSnapshot) {
          return Container(
            color: DesignCourseAppTheme.nearlyWhite,
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.transparent,
              body: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.2,
                        child: Image.file(selectedStory.image),
                      ),
                    ],
                  ),
                  Positioned(
                    top: (MediaQuery.of(context).size.width / 1.2) -
                        MediaQuery.of(context).size.width / 360 * 24.0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: DesignCourseAppTheme.nearlyWhite,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                MediaQuery.of(context).size.width / 360 * 32.0),
                            topRight: Radius.circular(
                                MediaQuery.of(context).size.width /
                                    360 *
                                    32.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: DesignCourseAppTheme.grey.withOpacity(0.2),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 360 * 8,
                            right: MediaQuery.of(context).size.width / 360 * 8),
                        child: SingleChildScrollView(
                          child: Container(
                            constraints: BoxConstraints(
                                minHeight: infoHeight,
                                maxHeight: tempHeight > infoHeight
                                    ? tempHeight
                                    : infoHeight),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.width /
                                          360 *
                                          32.0,
                                      left: MediaQuery.of(context).size.width /
                                          360 *
                                          18,
                                      right: MediaQuery.of(context).size.width /
                                          360 *
                                          16),
                                  child: Text(
                                    selectedStory.title,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              360 *
                                              22,
                                      letterSpacing:
                                          MediaQuery.of(context).size.width /
                                              360 *
                                              0.27,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width /
                                          360 *
                                          16,
                                      right: MediaQuery.of(context).size.width /
                                          360 *
                                          16,
                                      bottom:
                                          MediaQuery.of(context).size.width /
                                              360 *
                                              8,
                                      top: MediaQuery.of(context).size.width /
                                          360 *
                                          16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '${DateTime.parse(selectedStory.createdAt).year}년 ${DateTime.parse(selectedStory.createdAt).month}월 ${DateTime.parse(selectedStory.createdAt).day}일',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              360 *
                                              22,
                                          letterSpacing: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              360 *
                                              0.27,
                                          color:
                                              DesignCourseAppTheme.nearlyBlue,
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              selectedStory.title,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    360 *
                                                    22,
                                                letterSpacing:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        360 *
                                                        0.27,
                                                color:
                                                    DesignCourseAppTheme.grey,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  360 *
                                                  10,
                                            ),
                                            Icon(
                                              Icons.check,
                                              color: DesignCourseAppTheme
                                                  .nearlyBlue,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  360 *
                                                  24,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: opacity1,
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width /
                                            360 *
                                            8),
                                    child: Row(
                                      children: <Widget>[
                                        getTimeBoxUI(
                                            CategoryWord(
                                                selectedStory.category),
                                            '카테고리'),
                                        getTimeBoxUI(
                                            isUploaded == 0 ? '업로드 X' : '업로드 O',
                                            '상태'),
                                        getTimeBoxUI('0', '좋아요'),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 500),
                                    opacity: opacity2,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              360 *
                                              16,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              360 *
                                              16,
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              360 *
                                              8,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              360 *
                                              8),
                                      child: Text(
                                        selectedStory.description,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              360 *
                                              14,
                                          letterSpacing: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              360 *
                                              0.27,
                                          color:
                                              DesignCourseAppTheme.darkerText,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: opacity3,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width /
                                                360 *
                                                16,
                                        bottom:
                                            MediaQuery.of(context).size.width /
                                                360 *
                                                16,
                                        right:
                                            MediaQuery.of(context).size.width /
                                                360 *
                                                16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              360 *
                                              48,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              360 *
                                              48,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: DesignCourseAppTheme
                                                  .nearlyWhite,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        360 *
                                                        16.0),
                                              ),
                                              border: Border.all(
                                                  color: DesignCourseAppTheme
                                                      .grey
                                                      .withOpacity(0.2)),
                                            ),
                                            child: IconButton(
                                              icon: Icon(Icons.delete,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      360 *
                                                      28,
                                                  color: isToday
                                                      ? DesignCourseAppTheme
                                                          .nearlyBlue
                                                      : Colors.grey),
                                              onPressed: () {
                                                isToday
                                                    ? showDialog<bool>(
                                                        context: _scaffoldKey!
                                                            .currentContext!,
                                                        builder: (ctx) {
                                                          return AlertDialog(
                                                            content: Text(
                                                                '스토리를 내릴까요?'),
                                                            actions: <Widget>[
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        backgroundColor:
                                                                            mainColor),
                                                                child: Text(
                                                                    '아니오.'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          false);
                                                                },
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        backgroundColor:
                                                                            mainColor),
                                                                child: Text(
                                                                    '네. 삭제합니다.'),
                                                                onPressed: () {
                                                                  isUploaded ==
                                                                          0
                                                                      ? deleteStory(
                                                                          storyId)
                                                                      : deleteStoryAndPost(
                                                                          storyId);
                                                                  fetchAndSetStories();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  // 화면 업데이트 추가
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        })
                                                    : showDialog<bool>(
                                                        context: _scaffoldKey!
                                                            .currentContext!,
                                                        builder: (ctx) {
                                                          return AlertDialog(
                                                            content: Text(
                                                                '오늘 올리지 않은 스토리는 삭제할 수 없습니다.'),
                                                            actions: <Widget>[],
                                                          );
                                                        });
                                              },
                                              color: DesignCourseAppTheme
                                                  .nearlyBlue,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              360 *
                                              16,
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                360 *
                                                48,
                                            decoration: BoxDecoration(
                                              color: isUploaded == 0
                                                  ? DesignCourseAppTheme
                                                      .nearlyBlue
                                                  : Colors.grey,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        360 *
                                                        16.0),
                                              ),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: DesignCourseAppTheme
                                                        .nearlyBlue
                                                        .withOpacity(0.5),
                                                    offset:
                                                        const Offset(1.1, 1.1),
                                                    blurRadius:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            360 *
                                                            10.0),
                                              ],
                                            ),
                                            child: isUploaded == 0
                                                ? InkWell(
                                                    onTap: () {
                                                      showDialog<bool>(
                                                          context: _scaffoldKey!
                                                              .currentContext!,
                                                          builder: (ctx) {
                                                            return AlertDialog(
                                                              content: Text(
                                                                  '포스트를 업로드할까요?'),
                                                              actions: <Widget>[
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                          backgroundColor:
                                                                              mainColor),
                                                                  child: Text(
                                                                      '아니오.'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            false);
                                                                  },
                                                                ),
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                          backgroundColor:
                                                                              mainColor),
                                                                  child: Text(
                                                                      '네. 업로드합니다.'),
                                                                  onPressed:
                                                                      () async {
                                                                    await _uploadPost();
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    child: Center(
                                                      child: Text(
                                                        '업로드하기',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              360 *
                                                              18,
                                                          letterSpacing: 0.0,
                                                          color:
                                                              DesignCourseAppTheme
                                                                  .nearlyWhite,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      deletePost(storyId);
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Center(
                                                      child: Text(
                                                        '업로드 내리기',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              360 *
                                                              18,
                                                          letterSpacing: 0.0,
                                                          color:
                                                              DesignCourseAppTheme
                                                                  .nearlyWhite,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).padding.bottom,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: (MediaQuery.of(context).size.width / 1.2) -
                        MediaQuery.of(context).size.width / 360 * 24.0 -
                        MediaQuery.of(context).size.width / 360 * 35,
                    right: MediaQuery.of(context).size.width / 360 * 35,
                    child: ScaleTransition(
                      alignment: Alignment.center,
                      scale: CurvedAnimation(
                          parent: animationController!,
                          curve: Curves.fastOutSlowIn),
                      child: Card(
                        color: DesignCourseAppTheme.nearlyBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width /
                                    360 *
                                    50.0)),
                        elevation: 10.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 360 * 60,
                          height: MediaQuery.of(context).size.width / 360 * 60,
                          child: Center(
                              child: CategoryIcon(selectedStory.category)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: SizedBox(
                      width: AppBar().preferredSize.height,
                      height: AppBar().preferredSize.height,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                              AppBar().preferredSize.height),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: DesignCourseAppTheme.nearlyBlack,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget CategoryIcon(String selectedCategory) {
    if (selectedCategory == 'Kind.Reading') {
      return Container(
          width: MediaQuery.of(context).size.width / 360 * 30,
          height: MediaQuery.of(context).size.width / 360 * 30,
          child: Image.asset(
            'assets/icons/reading.png',
            color: DesignCourseAppTheme.nearlyWhite,
          ));
    } else if (selectedCategory == 'Kind.Exercise') {
      return Container(
          width: MediaQuery.of(context).size.width / 360 * 30,
          height: MediaQuery.of(context).size.width / 360 * 30,
          child: Image.asset(
            'assets/icons/exercise.png',
            color: DesignCourseAppTheme.nearlyWhite,
          ));
    } else if (selectedCategory == 'Kind.Language') {
      return Container(
          width: MediaQuery.of(context).size.width / 360 * 30,
          height: MediaQuery.of(context).size.width / 360 * 30,
          child: Image.asset(
            'assets/icons/language.png',
            color: DesignCourseAppTheme.nearlyWhite,
          ));
    } else if (selectedCategory == 'Kind.Study') {
      return Container(
          width: MediaQuery.of(context).size.width / 360 * 30,
          height: MediaQuery.of(context).size.width / 360 * 30,
          child: Image.asset(
            'assets/icons/study.png',
            color: DesignCourseAppTheme.nearlyWhite,
          ));
    } else {
      return Container(
          width: MediaQuery.of(context).size.width / 360 * 30,
          height: MediaQuery.of(context).size.width / 360 * 30,
          child: Image.asset(
            'assets/icons/etc.png',
            color: DesignCourseAppTheme.nearlyWhite,
          ));
    }
  }

  Widget getTimeBoxUI(String text1, String txt2) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width / 360 * 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: DesignCourseAppTheme.nearlyWhite,
          borderRadius: BorderRadius.all(
              Radius.circular(MediaQuery.of(context).size.width / 360 * 16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: DesignCourseAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: MediaQuery.of(context).size.width / 360 * 8.0),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 360 * 18.0,
              right: MediaQuery.of(context).size.width / 360 * 18.0,
              top: MediaQuery.of(context).size.width / 360 * 12.0,
              bottom: MediaQuery.of(context).size.width / 360 * 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.width / 360 * 14,
                  letterSpacing: MediaQuery.of(context).size.width / 360 * 0.27,
                  color: DesignCourseAppTheme.nearlyBlue,
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: MediaQuery.of(context).size.width / 360 * 14,
                  letterSpacing: MediaQuery.of(context).size.width / 360 * 0.27,
                  color: DesignCourseAppTheme.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
