import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:habbit/Screen/fame_detail_screen.dart';
import 'package:habbit/colors.dart';

class FameRepositoryScreen extends StatelessWidget {
  const FameRepositoryScreen({super.key});
  static const routeName = '/fame-repository';
  @override
  Widget build(BuildContext context) {
    final folderId =
        (ModalRoute.of(context)?.settings.arguments as Map)['folder_id'];
    final userId =
        (ModalRoute.of(context)?.settings.arguments as Map)['userId'];
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: mainColor, //색변경
          ),
          title: Text(
            '명예의 전당 스토리',
            style: TextStyle(color: mainColor),
          )),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('fame_repository')
              .where('folderId', isEqualTo: folderId)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: const CircularProgressIndicator(),
              );
            }
            final data = snapshot.data?.docs.first.data()['fameData'];
            return GridView.builder(
              shrinkWrap: true,
              itemCount: data?.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Route _createRoute() {
                      return PageRouteBuilder(
                        settings: RouteSettings(arguments: {
                          'userId': userId,
                          'created_at': data[index]['created_at'],
                          'title': data[index]['title'],
                          'description': data[index]['description'],
                          'category': data[index]['category'],
                          'image': data[index]['image']
                        }),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            FameDetailScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      );
                    }

                    Navigator.of(context).push(_createRoute());
                  },
                  child: Image.network(
                    data[index]['image'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }),
    );
  }
}
