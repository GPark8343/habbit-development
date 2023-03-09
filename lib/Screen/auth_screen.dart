import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:habbit/Screen/splash_screen.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/providers/upload.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  Future<void> signInWithGoogle(context) async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signIn().catchError((onError) => print(onError));
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
      }

      // 오류남-> splash screen으로 가려야 함
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width / 360 * 130),
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
                            width:
                                MediaQuery.of(context).size.width / 360 * 300,
                            height:
                                MediaQuery.of(context).size.width / 360 * 300,
                          ),
                        ),
                        GestureDetector(
                          child: Card(color: mainColor,
                            child: Image.asset(
                              'assets/logos/btn_google_signin_light_normal_web.png',
                              width:
                                  MediaQuery.of(context).size.width / 360 * 200,
                              height:
                                  MediaQuery.of(context).size.width / 360 * 50,fit: BoxFit.contain,
                            ),
                          ),
                          onTap: () {
                            signInWithGoogle(context);
                          },
                        ),
                      ],
                    )),
              ),
            )),
      ),
    );
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