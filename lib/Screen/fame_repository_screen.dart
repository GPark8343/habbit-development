import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:habbit/Screen/fame_detail_screen.dart';

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
      appBar: AppBar(title: Text('명예의 전당 스토리')),
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
              physics: const NeverScrollableScrollPhysics(),
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
                    Navigator.of(context)
                        .pushNamed(FameDetailScreen.routeName, arguments: {
                      'userId': userId,
                    
                      'created_at': data[index]['created_at'],
                      'title': data[index]['title'],
                      'description': data[index]['description'],
                      'category': data[index]['category'],
                      'image': data[index]['image']
                    });
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
