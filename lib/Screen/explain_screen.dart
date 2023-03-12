import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habbit/Screen/other_profile_screen.dart';
import 'package:habbit/colors.dart';

class ExplainScreen extends StatelessWidget {
  const ExplainScreen({super.key});
  static const routeName = '/explain';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: mainColor, //색변경
          ),
          title: Text(
            '60일 첼린지 유의사항',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 360 * 25,
                color: mainColor,
                fontWeight: FontWeight.bold),
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Text(
                  '60일 첼린지 유의 사항:\n\n1. 환급 혜택을 얻기 위해서 앱의 사용자는 habbit 커뮤니티에 가입해야 합니다.\n\n2. 환급 조건은 다음과 같습니다.\n\n- 60일 첼린지 성공과 동시에 명예의 전당에 등록하여야 합니다.\n- 환급의 악용을 막기 위해서 1달에 각 이메일 당 1개의 폴더만 환급이 가능합니다.\n- 첼린지 폴더와 자신의 명예의 전당 스토리를 스크린샷하여 커뮤니티에 올려야 심사가 진행됩니다.\n\n3. 환급을 악용하는 유저는 모든 계정과 서비스가 차단됩니다.\n\n**자세한 사항은 habbit 커뮤니티(오픈 준비 중) 주소를 참고하세요.**'),
            ),
          ],
        ),
      ),
    );
  }
}
