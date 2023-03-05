import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habbit/models/folder.dart';
import 'package:habbit/models/story.dart';

class FameRepositoryManage extends ChangeNotifier {
  registerFameStories(Folder folder, List<Story> stories) async {
    
      List<Map> fameData = stories
          .where((element) => element.folderId == folder.id)
          .toList()
          .map((story) => story.toMap())
          .toList();

      FirebaseFirestore.instance.collection('fame_repository').add({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'fameData': fameData,
        'folder': folder.toMap(),
        'folderId':folder.id
      });
    

  }
}
