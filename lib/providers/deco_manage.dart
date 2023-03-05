import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DecoManage extends ChangeNotifier {

  
  updateReward(List rewardList) async {
    await FirebaseFirestore.instance
      ..collection('users')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get()
          .then((value) => value.docs.first.reference
              .update({'number_of_reward': rewardList}));
  }


}
