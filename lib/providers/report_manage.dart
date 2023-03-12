import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habbit/models/post.dart';

class ReportManage extends ChangeNotifier {
  reportPost(Post reportedPost, String reportingUserEmail) async {
    await FirebaseFirestore.instance
        .collection('reportsPost')
        .doc('${reportedPost.uid}${reportingUserEmail}')
        .set({...reportedPost.toMap(), 'reporting_user': reportingUserEmail});
  }

  reportUser(String reportedUserEmail, String reportingUserEmail) async {
    await FirebaseFirestore.instance
        .collection('reportsUser')
        .doc('${reportedUserEmail}${reportingUserEmail}')
        .set({
      'reported_user': reportedUserEmail,
      'reporting_user': reportingUserEmail
    });
  }
}
