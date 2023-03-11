import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habbit/Screen/splash_screen.dart';
import 'package:habbit/Screen/tutorial_screen.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/providers/upload.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

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
                      Text.rich(TextSpan(
                        children: [
                          TextSpan(text: "Habbit의 개인정보처리방침"),
                          TextSpan(
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                              //make link blue and underline
                              text:
                                  "https://sites.google.com/view/habbit-privacy-policy",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  //on tap code here, you can navigate to other page or URL
                                  String url =
                                      "https://sites.google.com/view/habbit-privacy-policy";
                                  var urllaunchable = await canLaunch(
                                      url); //canLaunch is from url_launcher package
                                  if (urllaunchable) {
                                    await launch(
                                        url); //launch is from url_launcher package to launch URL
                                  } else {
                                    print("URL can't be launched.");
                                  }
                                }),
                        ],
                      )),
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
      print(data.docs.length);
      if (data.docs.length == 0) {
        upload.registerUser();
        Navigator.of(context).pushNamed(TutorialScreen.routeName);
      }

      // 오류남-> splash screen으로 가려야 함
    } catch (error) {
      print(error);
    }
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
                                onTap: () {
                                  _signInWithGoogle(context);
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