import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BanManage extends ChangeNotifier {
  List _banList = [];

  List get banList {
    return [..._banList];
  }

  Future<void> fetchAndSetBanUser() async {
    final datalist = await FirebaseFirestore.instance
        .collection('friends')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(FirebaseAuth.instance.currentUser?.uid ?? 'error')
        .where('isBan', isEqualTo: true)
        .get();
    _banList = datalist.docs.map((item) => item.data()['uid']).toList();
    print(banList);
    notifyListeners();
  }

  banUser(String uid) async {
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(FirebaseAuth.instance.currentUser?.uid ?? 'error')
        .doc(uid)
        .set({'uid': uid, 'isBan': true});
  }

  unlockUser(String uid) async {
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(FirebaseAuth.instance.currentUser?.uid ?? 'error')
        .doc(uid)
        .set({'uid': uid, 'isBan': false});
  }
}
