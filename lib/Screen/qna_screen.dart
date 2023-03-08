import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habbit/Screen/tap_screen.dart';
import 'package:habbit/colors.dart';

class QnaScreen extends StatelessWidget {
  const QnaScreen({super.key});
  static const routeName = '/qna';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: mainColor, //색변경
        ),
        title: Text(
          'QNA',
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 360 * 25,
              color: mainColor,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    '1. 어떻게 하면 폴더를 지우나요?',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 360 * 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ': 폴더를 왼쪽이나 오른쪽으로 밀면 삭제할 수 있습니다. 단 그 폴더 안의 스토리는 영구적으로 삭제됩니다.',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 360 * 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 360 * 15,
              ),
              Column(
                children: [
                  Text(
                    '2. 어떻게 하면 포스트를 올리나요?',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 360 * 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ': 프로필 화면이나 스토리 저장소 화면의 각 스토리를 터치하면 업로드 버튼이 나옵니다.',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 360 * 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 360 * 15,
              ),
              Column(
                children: [
                  Text(
                    '3. 어제 올린 스토리가 안 지워져요',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 360 * 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ': 당일 올린 스토리만 삭제 가능합니다. 단, 포스트는 언제든지 삭제 가능합니다.',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 360 * 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 360 * 15,
              ),
              Column(
                children: [
                  Text(
                    '4. 명예의 전당은 뭔가요?',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 360 * 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ': 명예의 전당은 한 폴더에 60개 이상의 스토리를 올려야 등록이 가능합니다. 게시하면 누구나 볼 수 있습니다.',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 360 * 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 360 * 15,
              ),
              Column(
                children: [
                  Text(
                    '**주의점**',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: MediaQuery.of(context).size.width / 360 * 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ': 앱을 삭제할 시 모든 폴더와 스토리가 동시에 삭제됩니다. 단 명예의 전당 등록 시 앱을 삭제하여도 그 계정으로 다시 불러올 수 있습니다. 따라서 60일 동안 첼린지를 성공하여 자신의 습관 형성 스토리를 영구 보존해보세요',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: MediaQuery.of(context).size.width / 360 * 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
