import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habbit/Screen/service_screen.dart';
import 'package:habbit/Screen/splash_screen.dart';
import 'package:habbit/Screen/tutorial_screen.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/providers/upload.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  Future first(context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (ctx) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: const Text('개인 정보 동의'),
                content: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text("회원가입 및 Habbit의 이용약관 및 개인정보처리방침에 동의하시겠습니까?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ServiceScreen.routeName);
                        },
                        child: Card(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('서비스 이용약관 확인하기'),
                            Icon(Icons.arrow_right_alt_rounded)
                          ],
                        )),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 360 * 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(PrivacyScreen.routeName);
                        },
                        child: Card(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('개인정보처리방침 확인하기'),
                            Icon(Icons.arrow_right_alt_rounded)
                          ],
                        )),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 360 * 20,
                      ),
                      Text('또한 아래와 같은 권한이 필요합니다.(앱 사용에 있어 필수는 아닙니다.)'),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 360 * 10,
                      ),
                      Card(
                        child: Text('1. 저장공간(사진 또는 프로필 이미지 첨부 목적)'),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 360 * 10,
                      ),
                      Card(
                        child: Text('2. 카메라(사진 업로드 목적)'),
                      ),
                    ])),
                actions: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                    onPressed: () {},
                    child: const Text('동의하지 않습니다.'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('동의합니다'),
                  ),
                ],
              ),
            );
          });
    });
  }

  Future<void> _signInWithGoogle(context) async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: [
        'profile',
        'email',
      ]).signIn().catchError((onError) => print(onError));
      if (googleUser == null) return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential

      final authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = authResult.user;
      final upload = Provider.of<Upload>(context, listen: false);

      var data = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user!.uid)
          .get();

      if (data.docs.length == 0) {
        upload.registerUser();
      }

      // 오류남-> splash screen으로 가려야 함
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: first(context),
        builder: (context, futureSnapshot) {
          return Scaffold(
            backgroundColor: mainColor,
            body: SafeArea(
              child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.width / 360 * 50),
                  child: Center(
                    child: Card(
                      child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width / 360 * 8.0),
                          child: Column(
                            children: [
                              Container(
                                child: Image.asset(
                                  'assets/logos/logo.png',
                                  width: MediaQuery.of(context).size.width /
                                      360 *
                                      300,
                                  height: MediaQuery.of(context).size.width /
                                      360 *
                                      300,
                                ),
                              ),
                              GestureDetector(
                                child: Card(
                                  color: mainColor,
                                  child: Image.asset(
                                    'assets/logos/btn_google_signin_light_normal_web.png',
                                    width: MediaQuery.of(context).size.width /
                                        360 *
                                        200,
                                    height: MediaQuery.of(context).size.width /
                                        360 *
                                        50,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                onTap: _isLoading
                                    ? () => {}
                                    : () {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        _signInWithGoogle(context);
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      },
                              ),
                            ],
                          )),
                    ),
                  )),
            ),
          );
        });
  }
}
// GestureDetector(
//                     onTap: () {
//                       signInWithGoogle(context);
//                     },
//                     child: Container(
//                       child: Text(
//                         'google login',
//                         style: TextStyle(
//                             fontSize:
//                                 MediaQuery.of(context).size.width / 360 * 25,
//                             color: mainColor,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       width: MediaQuery.of(context).size.width / 360 * 200,
//                       height: MediaQuery.of(context).size.width / 360 * 50,
//                       // decoration: BoxDecoration(
//                       //     image: DecorationImage(
//                       //         image: AssetImage(
//                       //             'assets/images/google_sign_in_button.png'),
//                       //         fit: BoxFit.cover)),
//                     ),
//                   ),

class PrivacyScreen extends StatelessWidget {
  static const routeName = '/privacy';
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget PrivacyWidget2(int law) {
      return Container(child: Image.asset('assets/icons/privacy${law}.png'));
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: mainColor, //색변경
        ),
        title: Text(
          '개인정보처리방침',
          style: TextStyle(color: mainColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Text(
                  '< geniusPark >은(는) 「개인정보 보호법」 제30조에 따라 정보주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다.'),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrivacyWidget2(1),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 360 * 20,
                  ),
                  PrivacyWidget2(2),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 360 * 20,
                  ),
                  PrivacyWidget2(3),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 360 * 20,
                  ),
                  PrivacyWidget2(4),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 360 * 20,
                  ),
                  PrivacyWidget2(5),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 360 * 20,
                  ),
                  PrivacyWidget2(6),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 360 * 20,
                  ),
                  PrivacyWidget2(7),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 360 * 20,
                  ),
                  PrivacyWidget2(8),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 360 * 20,
                  ),
                  PrivacyWidget2(9),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 360 * 20,
                  ),
                  PrivacyWidget2(10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


    // SizedBox(
    //                 height: 20,
    //               ),
    //               PrivacyWidget('제1조(개인정보의 처리목적)'),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               PrivacyWidget('제2조(처리하는 개인정보의 항목)'),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               PrivacyWidget('제3조(개인정보의 파기절차 및 파기방법)'),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               PrivacyWidget('제4조(정보주체와 법정대리인의 권리·의무 및 그 행사방법에 관한 사항)'),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               PrivacyWidget('제5조(개인정보의 안전성 확보조치에 관한 사항)'),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               PrivacyWidget('제6조(개인정보를 자동으로 수집하는 장치의 설치·운영 및 그 거부에 관한 사항)'),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               PrivacyWidget('제7조 (개인정보 보호책임자에 관한 사항)'),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               PrivacyWidget('제8조(개인정보의 열람청구를 접수·처리하는 부서)'),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               PrivacyWidget('제9조(정보주체의 권익침해에 대한 구제방법)'),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               PrivacyWidget('제10조(개인정보 처리방침 변경)'),