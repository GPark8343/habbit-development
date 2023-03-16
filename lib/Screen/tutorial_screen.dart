// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:habbit/Screen/tap_screen.dart';
// import 'package:habbit/colors.dart';
// import 'package:introduction_screen/introduction_screen.dart';

// class TutorialScreen extends StatelessWidget {
//   const TutorialScreen({super.key});
//   static const routeName = '/tutorial';

//   @override
//   Widget build(BuildContext context) {
//     return IntroductionScreen(
//       pages: [
//         PageViewModel(
//             title: '앱 튜토리얼: Habbit 앱 사용법',
//             bodyWidget: Padding(
//               padding: EdgeInsets.only(
//                   top: MediaQuery.of(context).size.width / 360 * 25),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '앱을 설치해주셔서 감사합니다!',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                       color: mainColor,
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.width / 360 * 15,
//                   ),
//                   Text(
//                     '이 앱은 습관을 형성하고 유지하는 데 도움을 주는 앱입니다.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                       color: mainColor,
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.width / 360 * 15,
//                   ),
//                   Text(
//                     '이제부터 간단한 튜토리얼을 통해 앱의 기능을 알려드리겠습니다.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                       color: mainColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             image: Image.asset('assets/logos/logo.png'),
//             decoration: getPageDecoration(context)),
//         PageViewModel(
//             title: '폴더',
//             bodyWidget: Padding(
//               padding: EdgeInsets.only(
//                   top: MediaQuery.of(context).size.width / 360 * 25),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '앞으로 습관을 형성할 저장공간입니다.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                       color: mainColor,
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.width / 360 * 15,
//                   ),
//                   Text(
//                     '이 공간에 앞으로 형성할 습관의 카테고리와 설명을 기록할 수 있습니다.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                       color: mainColor,
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.width / 360 * 15,
//                   ),
//                   Text(
//                     '첼린지 폴더(파란색)와 일반 폴더(하얀색)는 색상으로 구분됩니다.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                       color: mainColor,
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.width / 360 * 15,
//                   ),
//                   Text(
//                     '폴더를 지우려면 폴더를 왼쪽이나 오른쪽으로 밀면 삭제할 수 있습니다.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                       color: mainColor,
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.width / 360 * 15,
//                   ),
//                   Text(
//                     '하지만 그 폴더 안의 스토리는 영구적으로 삭제됩니다.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                       color: mainColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             image: Image.asset('assets/icons/tutorial1.png'),
//             decoration: getPageDecoration(context)),
//         PageViewModel(
//             bodyWidget: Padding(
//               padding: EdgeInsets.only(
//                   top: MediaQuery.of(context).size.width / 360 * 25),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '폴더 안에 습관 형성의 기록을 남길 수 있는 파일입니다.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                       color: mainColor,
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.width / 360 * 15,
//                   ),
//                   Text(
//                     ' 하루에 1개의 스토리만 올릴 수 있으며 당일 올린 스토리만 삭제 가능합니다.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                       color: mainColor,
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.width / 360 * 15,
//                   ),
//                   Text(
//                     '자신의 스토리를 게시판에 올릴 수 있습니다.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                       color: mainColor,
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.width / 360 * 15,
//                   ),
//                   Text(
//                     '그 게시물의 단위를 포스트라 합니다.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                       color: mainColor,
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.width / 360 * 15,
//                   ),
//                   Text(
//                     '포스트를 올리려면 스토리 저장소 화면의 각 스토리를 터치하면 업로드 버튼이 나옵니다.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                       color: mainColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             title: '스토리',
//             image: Image.asset('assets/icons/tutorial3.png'),
//             decoration: getPageDecoration(context)),
//         PageViewModel(
//             title: '명예의 전당',
//             bodyWidget: Padding(
//               padding: EdgeInsets.only(
//                   top: MediaQuery.of(context).size.width / 360 * 25),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '첼린지 폴더에 60개 이상의 스토리를 올려야 등록이 가능합니다.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                       color: mainColor,
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.width / 360 * 15,
//                   ),
//                   Text(
//                     '명예의 전당에 등록하면 누구나 해당 스토리를 볼 수 있습니다.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                       color: mainColor,
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.width / 360 * 15,
//                   ),
//                   Text(
//                     '앱을 삭제할 시 모든 폴더와 스토리가 동시에 삭제됩니다.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                       color: Colors.red,
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.width / 360 * 15,
//                   ),
//                   Text(
//                     '하지만 명예의 전당에 등록한 경우 앱 삭제 여부와 상관없이 명예의 전당 스크린에서 데이터가 영구 보존됩니다.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: MediaQuery.of(context).size.width / 360 * 15,
//                       color: mainColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             image: Image.asset('assets/icons/tutorial4.png'),
//             decoration: getPageDecoration(context)),
//         PageViewModel(
//             body: '',
//             titleWidget: Padding(
//               padding: EdgeInsets.only(
//                   top: MediaQuery.of(context).size.width / 360 * 100),
//               child: Text(
//                 '60일 동안 첼린지를 성공하여 자신의 습관 형성 스토리를 뽐내보세요.',
//                 style: TextStyle(
//                     fontSize: MediaQuery.of(context).size.width / 360 * 25,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//             image: Container(
//                 width: MediaQuery.of(context).size.width / 360 * 200,
//                 height: MediaQuery.of(context).size.width / 360 * 200,
//                 child: Image.asset('assets/icons/big_trophy.png')),
//             decoration: getPageDecoration(context)),
//       ],
//       done: const Text('앱 시작하기'),
//       onDone: () {
//         Navigator.of(context).pop();
//       },
//       showBackButton: true,
//       showDoneButton: true,
//       showNextButton: true,
//       // showSkipButton: true,
//       next: const Icon(Icons.arrow_forward),
//       back: const Icon(Icons.arrow_back),
//       dotsDecorator: DotsDecorator(
//           color: mainColor,
//           size: Size(MediaQuery.of(context).size.width / 360 * 5,
//               MediaQuery.of(context).size.width / 360 * 5),
//           activeSize: Size(MediaQuery.of(context).size.width / 360 * 18,
//               MediaQuery.of(context).size.width / 360 * 11),
//           activeShape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(
//                   MediaQuery.of(context).size.width / 360 * 24))),
//       curve: Curves.fastOutSlowIn,
//     );
//   }

//   PageDecoration getPageDecoration(ctx) {
//     return PageDecoration(
//       titleTextStyle: TextStyle(
//           fontSize: MediaQuery.of(ctx).size.width / 360 * 25,
//           fontWeight: FontWeight.bold),
//       bodyTextStyle: TextStyle(
//         fontSize: 20,
//         color: mainColor,
//       ),
//       imagePadding:
//           EdgeInsets.only(top: MediaQuery.of(ctx).size.width / 360 * 100),
//       pageColor: Colors.white,
//     );
//   }
// }
