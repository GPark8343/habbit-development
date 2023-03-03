import 'dart:io';
import 'package:flutter/material.dart';
import 'package:habbit/helper/db_helper.dart';
import 'package:habbit/models/story.dart';
import 'package:uuid/uuid.dart';

class StoryManage extends ChangeNotifier {
  List<Story> _items = [];

  List<Story> get items {
    return [..._items];
  }

  Story findById(String id) {
    return _items.firstWhere((story) => story.id == id);
  }

  List<Story> findByFolderId(String folderId) {
    return _items.where((story) => story.folderId == folderId).toList();
  }

  Future<void> addStories(
      String pickedTitle,
      File pickedImage,
      String pickedDescription,
      String pickedCategory,
      String pickedFolderId) async {
    final newStory = Story(
        id: Uuid().v1(),
        title: pickedTitle,
        description: pickedDescription,
        image: pickedImage,
        createdAt: DateTime.now().toString(),
        category: pickedCategory,
        folderId: pickedFolderId,
        isUploaded: 0);
    _items.add(newStory);
    notifyListeners();
    DBHelper.insertStory('i_user_stories', {
      'id': newStory.id,
      'title': newStory.title,
      'image': newStory.image.path,
      'description': newStory.description,
      'created_at': newStory.createdAt,
      'category': newStory.category,
      'folder_id': newStory.folderId,
      'is_uploaded': newStory.isUploaded,
    });
  }

  Future<void> fetchAndSetStories() async {
    final datalist = await DBHelper.getStoryData('i_user_stories');
    _items = datalist
        .map((item) => Story(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            description: item['description'],
            createdAt: item['created_at'],
            category: item['category'],
            folderId: item['folder_id'],
            isUploaded: item['is_uploaded']))
        .toList();
    print(items);
    notifyListeners();
  }

  void changeIsUploaded(Story findedStory) {
    Story updatedStory = findedStory.copyWith(
      isUploaded: findedStory.isUploaded == 0 ? 1 : 0,
    );
    DBHelper.updateStory('i_user_stories', updatedStory);
  }

  Future<void> deleteStories(String id) async {
    DBHelper.deleteStory('i_user_stories', id);
  }
}
