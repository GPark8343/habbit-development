import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habbit/Screen/profile_screen.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/design_course/category_list_view.dart';
import 'package:habbit/design_course/course_info_screen.dart';
import 'package:habbit/design_course/popular_course_list_view.dart';
import 'package:habbit/main.dart';
import 'package:habbit/widgets/buttons/add_folder_button.dart';
import 'design_course_app_theme.dart';

class DesignCourseHomeScreen extends StatefulWidget {
  @override
  _DesignCourseHomeScreenState createState() => _DesignCourseHomeScreenState();
}

class _DesignCourseHomeScreenState extends State<DesignCourseHomeScreen> {
  CategoryType categoryType = CategoryType.Reading;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      // decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //           colors: [const Color(0xFF543CBA),const Color(0xFF3FA5B1)],
      //           begin: Alignment.topCenter,
      //           end: Alignment.bottomCenter,
      //           stops: [0.0, 1.0])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      // getSearchBarUI(),
                      getCategoryUI(),
                      Flexible(
                        child: getPopularCourseUI(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCategoryUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width / 360 * 8.0,
              left: MediaQuery.of(context).size.width / 360 * 18,
              right: MediaQuery.of(context).size.width / 360 * 16),
          child: Text(
            '명예의 전당',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: MediaQuery.of(context).size.width / 360 * 22,
              letterSpacing: MediaQuery.of(context).size.width / 360 * 0.27,
              color: DesignCourseAppTheme.darkerText,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width / 360 * 16,
        ),
        // Padding(
        //   padding: EdgeInsets.only(
        //       left: MediaQuery.of(context).size.width / 360 * 16,
        //       right: MediaQuery.of(context).size.width / 360 * 16),
        //   child: Row(
        //     children: <Widget>[
        //       getButtonUI(
        //           CategoryType.Reading, categoryType == CategoryType.Reading),
        //       SizedBox(
        //         width: MediaQuery.of(context).size.width / 360 * 16,
        //       ),
        //       getButtonUI(
        //           CategoryType.Exercise, categoryType == CategoryType.Exercise),
        //       SizedBox(
        //         width: MediaQuery.of(context).size.width / 360 * 16,
        //       ),
        //       getButtonUI(
        //           CategoryType.Language, categoryType == CategoryType.Language),
        //       getButtonUI(
        //           CategoryType.Study, categoryType == CategoryType.Study),
        //       getButtonUI(CategoryType.Etc, categoryType == CategoryType.Etc),
        //     ],
        //   ),
        // ),
        // SizedBox(
        //   height: MediaQuery.of(context).size.width / 360 * 16,
        // ),
        CategoryListView(),
      ],
    );
  }

  Widget getPopularCourseUI() {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width / 360 * 8.0,
          left: MediaQuery.of(context).size.width / 360 * 18,
          right: MediaQuery.of(context).size.width / 360 * 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '폴더 목록',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.width / 360 * 22,
                  letterSpacing: MediaQuery.of(context).size.width / 360 * 0.27,
                  color: DesignCourseAppTheme.darkerText,
                ),
              ),
              AddFolderButton()
            ],
          ),
          Flexible(
            child: PopularCourseListView(),
          )
        ],
      ),
    );
  }

  void moveTo() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => CourseInfoScreen(),
      ),
    );
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    String txt = '';
    if (CategoryType.Reading == categoryTypeData) {
      txt = '독서';
    } else if (CategoryType.Exercise == categoryTypeData) {
      txt = '운동';
    } else if (CategoryType.Language == categoryTypeData) {
      txt = '언어';
    } else if (CategoryType.Study == categoryTypeData) {
      txt = '공부';
    } else if (CategoryType.Etc == categoryTypeData) {
      txt = '기타';
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? DesignCourseAppTheme.nearlyBlue
                : DesignCourseAppTheme.nearlyWhite,
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width / 360 * 24.0)),
            border: Border.all(color: DesignCourseAppTheme.nearlyBlue)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width / 360 * 24.0)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width / 360 * 12,
                  bottom: MediaQuery.of(context).size.width / 360 * 12,
                  left: MediaQuery.of(context).size.width / 360 * 18,
                  right: MediaQuery.of(context).size.width / 360 * 18),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.width / 360 * 12,
                    letterSpacing:
                        MediaQuery.of(context).size.width / 360 * 0.27,
                    color: isSelected
                        ? DesignCourseAppTheme.nearlyWhite
                        : DesignCourseAppTheme.nearlyBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width / 360 * 8.0,
          left: MediaQuery.of(context).size.width / 360 * 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.width / 360 * 64,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width / 360 * 8,
                  bottom: MediaQuery.of(context).size.width / 360 * 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor('#F8FAFB'),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(
                        MediaQuery.of(context).size.width / 360 * 13.0),
                    bottomLeft: Radius.circular(
                        MediaQuery.of(context).size.width / 360 * 13.0),
                    topLeft: Radius.circular(
                        MediaQuery.of(context).size.width / 360 * 13.0),
                    topRight: Radius.circular(
                        MediaQuery.of(context).size.width / 360 * 13.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 360 * 16,
                            right:
                                MediaQuery.of(context).size.width / 360 * 16),
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.width / 360 * 16,
                            color: DesignCourseAppTheme.nearlyBlue,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Search for habit',
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width / 360 * 16,
                              color: HexColor('#B9BABC'),
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width / 360 * 16,
                              letterSpacing:
                                  MediaQuery.of(context).size.width / 360 * 0.2,
                              color: HexColor('#B9BABC'),
                            ),
                          ),
                          onEditingComplete: () {},
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 360 * 60,
                      height: MediaQuery.of(context).size.width / 360 * 60,
                      child: Icon(Icons.search, color: HexColor('#B9BABC')),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width / 360 * 8.0,
          left: MediaQuery.of(context).size.width / 360 * 18,
          right: MediaQuery.of(context).size.width / 360 * 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Make your',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.width / 360 * 14,
                    letterSpacing:
                        MediaQuery.of(context).size.width / 360 * 0.2,
                    color: DesignCourseAppTheme.grey,
                  ),
                ),
                Text(
                  'Habbit',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width / 360 * 22,
                    letterSpacing:
                        MediaQuery.of(context).size.width / 360 * 0.27,
                    color: DesignCourseAppTheme.darkerText,
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
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
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(ProfileScreen.routeName);
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width / 360 * 60,
                      height: MediaQuery.of(context).size.width / 360 * 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(
                            MediaQuery.of(context).size.width / 360 * 16.0)),
                        child: AspectRatio(
                            aspectRatio: 1.0,
                            child:
                                Image.network(docs!.first.data()['thumbnail'])),
                      )),
                );
              })
        ],
      ),
    );
  }
}

enum CategoryType { Reading, Exercise, Language, Study, Etc }
