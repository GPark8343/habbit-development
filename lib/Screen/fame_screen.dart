import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habbit/widgets/buttons/upload_button.dart';
import 'package:habbit/widgets/calendar/calendar.dart';
import 'package:habbit/widgets/hout_timer.dart';

class FameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('fame')
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
          final docs = snapshot.data?.docs;
          return Container();
        });
  }
}
