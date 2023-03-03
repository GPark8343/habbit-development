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
        folderId: pickedFolderId);
    _items.add(newStory);
    notifyListeners();
    DBHelper.insertStory('users_story', {
      'id': newStory.id,
      'title': newStory.title,
      'image': newStory.image.path,
      'description': newStory.description,
      'created_at': newStory.createdAt,
      'category': newStory.category,
      'folder_id': newStory.folderId,
    });
  }

  Future<void> fetchAndSetStories() async {
    final datalist = await DBHelper.getStoryData('users_story');
    _items = datalist
        .map((item) => Story(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            description: item['description'],
            createdAt: item['created_at'],
            category: item['category'],
            folderId: item['folder_id']))
        .toList();
    print(items);
    notifyListeners();
  }

  Future<void> deleteStories(String id) async {
    DBHelper.deleteStory('users_story', id);
  }
}
