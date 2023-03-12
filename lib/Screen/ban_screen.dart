import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habbit/Screen/other_profile_screen.dart';
import 'package:habbit/colors.dart';

class BanScreen extends StatelessWidget {
  const BanScreen({super.key});
  static const routeName = '/ban';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: mainColor, //색변경
          ),
          title: Text(
            '차단 리스트',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 360 * 25,
                color: mainColor,
                fontWeight: FontWeight.bold),
          )),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('friends')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection(FirebaseAuth.instance.currentUser?.uid ?? 'error')
                .snapshots(),
            builder: (ctx, friendSnapshot) {
              if (friendSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: const CircularProgressIndicator(),
                );
              }
              final friendDocs = friendSnapshot.data?.docs;
              final banDocs = friendDocs
                  ?.where((element) => element['isBan'] == true)
                  .toList();

              return Padding(
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width / 360 * 10.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: banDocs?.length,
                    itemBuilder: (context, index) {
                      var isBan = banDocs?[index]['isBan'];
                      var uid = banDocs?[index]['uid'];
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('uid', isEqualTo: uid)
                              .snapshots(),
                          builder: (context, streamSnapshot) {
                            if (streamSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: const CircularProgressIndicator(),
                              );
                            }
                            final docData =
                                streamSnapshot.data?.docs.first.data();
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        OtherProfileScreen.routeName,
                                        arguments: {
                                          'uid': uid,
                                        });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: ListTile(
                                        title: Text(
                                          docData!['nickname'],
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                360 *
                                                18,
                                          ),
                                        ),
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            docData['thumbnail'],
                                          ),
                                          radius: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              360 *
                                              25,
                                        ),
                                        trailing: isBan!
                                            ? Text(
                                                '차단됨',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          360 *
                                                          13,
                                                ),
                                              )
                                            : null),
                                  ),
                                ),
                                Divider(
                                    indent: MediaQuery.of(context).size.width /
                                        360 *
                                        85),
                              ],
                            );
                          });
                    }),
              );
            },
          ),
        ],
      ),
    );
  }
}
