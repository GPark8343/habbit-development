import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habbit/Screen/tap_screen.dart';
import 'package:habbit/colors.dart';

class TermScreen extends StatelessWidget {
  const TermScreen({super.key});
  static const routeName = '/term';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: mainColor, //색변경
        ),
        title: Text(
          '용어 설명',
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 360 * 25,
              color: mainColor,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  '1. 폴더',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 360 * 15,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  ': 폴더란 앞으로 습관을 형성할 저장공간입니다. 이 공간에 앞으로 형성할 습관의 카테고리와 설명을 기록할 수 있습니다.',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 360 * 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '2. 스토리',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 360 * 15,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  ': 폴더 안에 습관 형성의 기록을 남길 수 있는 파일입니다. 하루에 1개의 스토리만 올릴 수 있으며 당일 올린 스토리만 삭제 가능합니다.',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 360 * 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '3. 포스트',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 360 * 15,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  ': 자신의 스토리를 게시판에 올릴 수 있습니다. 그 게시물의 단위를 포스트라 합니다',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 360 * 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
