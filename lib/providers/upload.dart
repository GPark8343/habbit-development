import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:habbit/models/i_user.dart';
import 'package:habbit/models/post.dart';

class Upload with ChangeNotifier {
  var postList = [];

  Future<IUser?> loadUserByUid(String uid) async {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();

    if (data.size == 0) {
      return null;
    } else {
      return IUser.fromJson(data.docs.first.data());
    }
  }

  Future<bool> registerUser() async {
    try {
      IUser user = IUser(
          uid: FirebaseAuth.instance.currentUser!.uid,
          nickname: FirebaseAuth.instance.currentUser!.displayName,
          thumbnail: FirebaseAuth.instance.currentUser!.photoURL,
          description: FirebaseAuth.instance.currentUser!.email, // 이 부분은 수정 필요
          numberOfReward: [],
          );
      await FirebaseFirestore.instance.collection('users').add(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  // static Future<List<Post>> loadFeedList() async {
  //   var document = FirebaseFirestore.instance
  //       .collection('posts')
  //       .orderBy('createdAt', descending: true)
  //       .limit(10);
  //   var data = await document.get();
  //   return data.docs.map<Post>((e) => Post.fromJson(e.id, e.data())).toList();
  // }
  // Future<void> addPostList() async {
  //   var document = FirebaseFirestore.instance
  //       .collection('posts')
  //       // .orderBy('createdAt', descending: true)
  //       .limit(10);
  //   var data = await document.get();
  //    print(data.docs.first.data());
  //   var feedList =
  //       data.docs.map<Post>((e) => Post.fromJson(e.id, e.data())).toList();
  //   postList.addAll(feedList);
  //   print(feedList);
  // }

  // Future<void> addPostList() async {
  //   var feedList = await loadFeedList();
  //   postList.addAll(feedList);
  //   print(feedList.length);
  // }

  _uploadPostFile(File file, String filename) {
    var ref = FirebaseStorage.instance.ref().child('posts').child(filename);
    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});
    return ref.putFile(file, metadata);
  }

  void uploadPost(Post post, File file) {
    var filename = '/${post.uid}.jpg';
    var task = _uploadPostFile(file, filename);
    if (task != null) {
      task.snapshotEvents.listen(
        (event) async {
          if (event.bytesTransferred == event.totalBytes &&
              event.state == TaskState.success) {
            var downloadUrl = await event.ref.getDownloadURL();
            var updatedPost = post.copyWith(
              thumbnail: downloadUrl,
            );
            await FirebaseFirestore.instance
                .collection('posts')
                .add(updatedPost.toMap());
          }
        },
      );
    }
  }



  _deleteFile(String id) async {
// Create a reference to the file to delete
    final ref = FirebaseStorage.instance.ref().child("posts/${id}.jpg");
// Delete the file
    await ref.delete();
  }

  deletePost(String id) async {
    var deleteObject = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: id);
    deleteObject.get().then((value) => value.docs.forEach((element) {
          element.reference.delete();
        }));
    _deleteFile(id);
  }

  _uploadThumbnailFile(File file, String filename) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var ref = FirebaseStorage.instance
        .ref()
        .child('thumbnails')
        .child(uid)
        .child(filename);
    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});
    return ref.putFile(file, metadata);
  }

  void uploadThumbnail(File file) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var filename = '/${DateTime.now().toString()}.jpg';
    var task = _uploadThumbnailFile(file, filename);
    if (task != null) {
      task.snapshotEvents.listen(
        (event) async {
          if (event.bytesTransferred == event.totalBytes &&
              event.state == TaskState.success) {
            var downloadUrl = await event.ref.getDownloadURL();
            var userData = await FirebaseFirestore.instance
                .collection('users')
                .where('uid', isEqualTo: uid)
                .get()
                .then((value) => value.docs.first.reference
                    .update({'thumbnail': downloadUrl}));
          }
        },
      );
    }
  }
}
