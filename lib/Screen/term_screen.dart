// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:habbit/Screen/tap_screen.dart';
// import 'package:habbit/colors.dart';

// class TutorialScreen extends StatelessWidget {
//   const TutorialScreen({super.key});
//   static const routeName = '/tutorial';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: mainColor, //색변경
//         ),
//         title: Text(
//           'Tutorial',
//           style: TextStyle(
//               fontSize: MediaQuery.of(context).size.width / 360 * 25,
//               color: mainColor,
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Column(
//                 children: [
//                   Text(
//                     '앱 튜토리얼: 습관 동기부여 앱 사용법',
//                     style: TextStyle(
//                         fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     '앱을 설치해주셔서 감사합니다! 이 앱은 습관을 형성하고 유지하는 데 도움을 주는 도구입니다. 이제부터 간단한 튜토리얼을 통해 앱의 기능을 알려드리겠습니다.',
//                     style: TextStyle(
//                         fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.width / 360 * 15,
//               ),
//               Column(
//                 children: [
//                   Text(
//                     '폴더',
//                     style: TextStyle(
//                         fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     '앞으로 습관을 형성할 저장공간입니다. 이 공간에 앞으로 형성할 습관의 카테고리와 설명을 기록할 수 있습니다. 폴더를 지우려면 폴더를 왼쪽이나 오른쪽으로 밀면 삭제할 수 있습니다. 하지만 그 폴더 안의 스토리는 영구적으로 삭제됩니다.',
//                     style: TextStyle(
//                         fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.width / 360 * 15,
//               ),
//               Column(
//                 children: [
//                   Text(
//                     '스토리',
//                     style: TextStyle(
//                         fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     '폴더 안에 습관 형성의 기록을 남길 수 있는 파일입니다. 하루에 1개의 스토리만 올릴 수 있으며 당일 올린 스토리만 삭제 가능합니다. 자신의 스토리를 게시판에 올릴 수 있습니다. 그 게시물의 단위를 포스트라 합니다. 스토리를 올리려면 프로필 화면이나 스토리 저장소 화면의 각 스토리를 터치하면 업로드 버튼이 나옵니다.',
//                     style: TextStyle(
//                         fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.width / 360 * 15,
//               ),
//               Column(
//                 children: [
//                   Text(
//                     '명예의 전당',
//                     style: TextStyle(
//                         fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     '한 폴더에 60개 이상의 스토리를 올려야 등록이 가능합니다. 명예의 전당에 등록하면 누구나 해당 스토리를 볼 수 있습니다. 앱을 삭제할 시 모든 폴더와 스토리가 동시에 삭제됩니다. 하지만 명예의 전당에 등록한 경우에는 그 계정으로 다시 불러올 수 있습니다. 따라서 60일 동안 첼린지를 성공하여 자신의 습관 형성 스토리를 영구 보존해보세요.',
//                     style: TextStyle(
//                         fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.width / 360 * 15,
//               ),
//               Column(
//                 children: [
//                   Text(
//                     '이제부터 당신도 습관 형성의 달인이 될 수 있습니다! 더 많은 질문이나 궁금한 사항이 있으시면 언제든지 문의해주세요.',
//                     style: TextStyle(
//                         color: mainColor,
//                         fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                         fontWeight: FontWeight.bold),
//                   ),
                 
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
