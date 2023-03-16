import 'package:habbit/Screen/auth_screen.dart';
import 'package:habbit/introduction_animation/components/center_next_button2.dart';

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

class TutorialScreen extends StatefulWidget {
  static const routeName = '/tutorial';
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  _TutorialScreenState createState() =>
      _TutorialScreenState();
}

class _TutorialScreenState
    extends State<TutorialScreen> with TickerProviderStateMixin {
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

  
  @override
  Widget build(BuildContext context) {

  
          return Scaffold(
            backgroundColor: Color(0xffF7EBE1),
            body: ClipRect(
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
                  CenterNextButton2(
                    animationController: _animationController!,
                    onNextClick: _onNextClick,
                  ),
                ],
              ),
            ),
          );
      
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
    Navigator.of(context).pop();
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
        Navigator.of(context).pushNamed(TutorialScreen.routeName);
      }

      // 오류남-> splash screen으로 가려야 함
    } catch (error) {}
  }
}
