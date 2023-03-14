import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:habbit/models/folder.dart';
import 'package:habbit/models/post.dart';
import 'package:habbit/models/story.dart';

class FameRepositoryManage extends ChangeNotifier {
  // UploadTask _uploadFameFile(File file, String filename) {
  //   var ref = FirebaseStorage.instance.ref().child('fame').child(filename);
  //   final metadata = SettableMetadata(
  //       contentType: 'image/jpeg',
  //       customMetadata: {'picked-file-path': file.path});
  //   return ref.putFile(file, metadata);
  // }

  // Future _uploadFame(List<Story> fameData1) async {
  //   print('${fameData1.length}wqfqfqfwe');
  //   for (int i = 0; i < fameData1.length; i++) {
  //     {
  //       var filename =
  //           '${FirebaseAuth.instance.currentUser?.uid ?? 'noUser'}/${fameData1[i].id}.jpg';
  //       var task = _uploadFameFile((fameData1[i] as Story).image, filename);
  //       if (task != null) {
  //         task.snapshotEvents.listen((event) async {
  //           if (event.bytesTransferred == event.totalBytes &&
  //               event.state == TaskState.success) {
  //             //   var downloadUrl = await event.ref.getDownloadURL();
  //             // var updatedPost = post.copyWith(
  //             //   thumbnail: downloadUrl,
  //             // );
  //             // await FirebaseFirestore.instance
  //             //     .collection('posts')
  //             //     .add(updatedPost.toMap());
  //             print('object');
  //             var url = await event.ref.getDownloadURL();

  //             await FirebaseFirestore.instance
  //                 .collection('fame_image')
  //                 .doc(FirebaseAuth.instance.currentUser!.uid)
  //                 .collection('images')
  //                 .add({
  //               'userId': FirebaseAuth.instance.currentUser!.uid,
  //               'image_url': url,
  //               'story_id': fameData1[i].id
  //             });

  //             notifyListeners();
  //           }
  //         });
  //       }
  //     }
  //   }
  // }

  registerFameStories(Folder folder, List<Story> stories) async {
    List<Story> fameData1 =
        stories.where((element) => element.folderId == folder.id).toList();
   
    List fameData2 = [];
  

    // await _uploadFame(fameData1);

    // await Future.delayed(Duration(seconds: 60)); // 사진 업로드하는 시간
    var snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('folderId', isEqualTo: folder.id)
        .get();
    var isEmpty = snapshot.docs.isEmpty;

    if (isEmpty) {
     
      return;
    } else {
 
      await FirebaseFirestore.instance
          .collection('posts')
          .where('folderId', isEqualTo: folder.id)
          .get()
          .then((value) {
        var docs = value.docs;
        for (int i = 0; i < fameData1.length; i++) {
          fameData2
              .add((fameData1[i] as Story).toMapImageUrl(docs[i]['thumbnail']));
        }
  
        FirebaseFirestore.instance.collection('fame_repository').add({
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'fameData': fameData2,
          'folder': folder.toMap(),
          'folderId': folder.id,
          'created_at': DateTime.now()
        });
      });
    }
  }
}
