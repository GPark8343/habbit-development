import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _signOut() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      Text('profile'),
      TextButton(
          onPressed: () {
            showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('앱을 종료할까요?'),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text('아니오.'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      ElevatedButton(
                        child: Text('네. 종료합니다.'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          _signOut();
                          // 화면 업데이트 추가
                        },
                      ),
                    ],
                  );
                });
          },
          child: Text('로그아웃')),
      CircleAvatar(
        backgroundImage: NetworkImage(
        FirebaseAuth.instance.currentUser!.photoURL!,
        ),
      )
    ]));
  }
}
