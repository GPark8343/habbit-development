import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habbit/Screen/fame_repository_screen.dart';
import 'package:habbit/Screen/repository_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class FameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('fame_repository')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (ctx, snapshot1) {
          if (snapshot1.connectionState == ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
          final docs1 = snapshot1.data?.docs;
          return ListView.builder(
              shrinkWrap: true,
              itemCount: docs1?.length,
              itemBuilder: (ctx, i) => StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('uid', isEqualTo: docs1?[i]['userId'])
                      .snapshots(),
                  builder: (ctx, snapshot2) {
                    if (snapshot2.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: const CircularProgressIndicator(),
                      );
                    }
                    final docs2 = snapshot2.data?.docs;

                    return Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(docs2!.first.data()['thumbnail']),
                          ),
                          title: Text(docs1?[i]['folder']['title']),
                          subtitle: Text(
                              (docs1?[i]['folder']['description']) as String),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                FameRepositoryScreen.routeName,
                                arguments: {
                                  'folder_id': docs1?[i]['folder']['folderId'],
                                  'userId': docs1?[i]['userId'],
                                });
                          },
                          trailing: Text(
                              '${timeago.format(docs1?[i]['created_at'].toDate())}'),
                        ),
                      ),
                    );
                  }));
        });
  }
}
