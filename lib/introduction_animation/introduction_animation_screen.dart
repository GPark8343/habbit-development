import 'package:habbit/Screen/auth_screen.dart';

import './components/care_view.dart';
import './components/center_next_button.dart';
import './components/mood_diary_vew.dart';
import './components/relax_view.dart';
import './components/splash_view.dart';
import './components/top_back_skip_view.dart';
import './components/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habbit/Screen/service_screen.dart';
import 'package:habbit/Screen/splash_screen.dart';
import 'package:habbit/Screen/tutorial_screen.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/providers/upload.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class IntroductionAnimationScreen extends StatefulWidget {
  static const routeName = '/intro';
  const IntroductionAnimationScreen({Key? key}) : super(key: key);

  @override
  _IntroductionAnimationScreenState createState() =>
      _IntroductionAnimationScreenState();
}

class _IntroductionAnimationScreenState
    extends State<IntroductionAnimationScreen> with TickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 8));
    _animationController?.animateTo(0.0);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    print(_animationController?.value);
    return FutureBuilder(
        future: first(context),
        builder: (context, futureSnapshot) {
          return Scaffold(
            backgroundColor: Color(0xffF7EBE1),
            body: SafeArea(
              child: ClipRect(
                child: Stack(
                  children: [
                    SplashView(
                      animationController: _animationController!,
                    ),
                    RelaxView(
                      animationController: _animationController!,
                    ),
                    CareView(
                      animationController: _animationController!,
                    ),
                    MoodDiaryVew(
                      animationController: _animationController!,
                    ),
                    WelcomeView(
                      animationController: _animationController!,
                    ),
                    TopBackSkipView(
                      onBackClick: _onBackClick,
                      onSkipClick: _onSkipClick,
                      animationController: _animationController!,
                    ),
                    CenterNextButton(
                      animationController: _animationController!,
                      onNextClick: _onNextClick,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _onSkipClick() {
    _animationController?.animateTo(0.8,
        duration: Duration(milliseconds: 1200));
  }

  void _onBackClick() {
    if (_animationController!.value >= 0 &&
        _animationController!.value <= 0.2) {
      _animationController?.animateTo(0.0);
    } else if (_animationController!.value > 0.2 &&
        _animationController!.value <= 0.4) {
      _animationController?.animateTo(0.2);
    } else if (_animationController!.value > 0.4 &&
        _animationController!.value <= 0.6) {
      _animationController?.animateTo(0.4);
    } else if (_animationController!.value > 0.6 &&
        _animationController!.value <= 0.8) {
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value > 0.8 &&
        _animationController!.value <= 1.0) {
      _animationController?.animateTo(0.8);
    }
  }

  void _onNextClick() {
    if (_animationController!.value >= 0 &&
        _animationController!.value <= 0.2) {
      _animationController?.animateTo(0.4);
    } else if (_animationController!.value > 0.2 &&
        _animationController!.value <= 0.4) {
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value > 0.4 &&
        _animationController!.value <= 0.6) {
      _animationController?.animateTo(0.8);
    } else if (_animationController!.value > 0.6 &&
        _animationController!.value <= 0.8) {
      _signUpClick();
    }
  }

  void _signUpClick() {
    _signInWithGoogle(context);
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
}
