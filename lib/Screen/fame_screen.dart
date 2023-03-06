import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habbit/Screen/fame_repository_screen.dart';
import 'package:habbit/Screen/repository_screen.dart';
import 'package:habbit/colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class FameScreen extends StatefulWidget {
  @override
  State<FameScreen> createState() => _FameScreenState();
}

class _FameScreenState extends State<FameScreen> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    var customSnapshot = _isChecked
        ? FirebaseFirestore.instance
            .collection('fame_repository')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots()
        : FirebaseFirestore.instance
            .collection('fame_repository')
            .orderBy('created_at', descending: true)
            .snapshots();
    return Column(
      children: [
        Switch(
          value: _isChecked,
          onChanged: (value) {
            setState(() {
              _isChecked = value;
            });
          },
        ),
        StreamBuilder(
            stream: customSnapshot,
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
                  itemBuilder: (ctx, i) {
                    print(docs1?[i]['folderId']);
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('uid', isEqualTo: docs1?[i]['userId'])
                            .snapshots(),
                        builder: (ctx, snapshot2) {
                          if (snapshot2.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: const CircularProgressIndicator(),
                            );
                          }
                          final docs2 = snapshot2.data?.docs;

                          return Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: mainColor,
                                backgroundImage: NetworkImage(
                                    docs2!.first.data()['thumbnail']),
                              ),
                              title: Text(docs1?[i]['folder']['title']),
                              subtitle: Text((docs1?[i]['folder']
                                  ['description']) as String),
                              onTap: () {
                                Route _createRoute() {
                                  return PageRouteBuilder(
                                    settings: RouteSettings(arguments: {
                                      'folder_id': docs1?[i]
                                          ['folderId'],
                                      'userId': docs1?[i]['userId'],
                                    }),
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        FameRepositoryScreen(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
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
                              trailing: Text(
                                  '${timeago.format(docs1?[i]['created_at'].toDate())}'),
                            ),
                          );
                        });
                  });
            }),
      ],
    );
  }
}
