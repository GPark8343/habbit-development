import 'package:flutter/material.dart';
import 'package:habbit/helper/db_helper.dart';
import 'package:habbit/models/folder.dart';
import 'package:uuid/uuid.dart';

class FolderManage extends ChangeNotifier {
  List<Folder> _folders = [];

  List<Folder> get folders {
    return [..._folders];
  }

  Folder findById(String id) {
    return _folders.firstWhere((folder) => folder.id == id);
  }

  Future<void> addFolders(String pickedTitle, String pickedDescription,
      String pickedCategory) async {
    final newFolder = Folder(
        id: Uuid().v1(),
        title: pickedTitle,
        description: pickedDescription,
        createdAt: DateTime.now().toString(),
        category: pickedCategory,
        days: 0);
    _folders.add(newFolder);
    notifyListeners();
    DBHelper.insertFolder('user_folder', {
      'id': newFolder.id,
      'title': newFolder.title,
      'description': newFolder.description,
      'created_at': newFolder.createdAt,
      'category': newFolder.category,
      'days': 0,
    });
  }

  Future<void> fetchAndSetFolders() async {
    final datalist = await DBHelper.getFolderData('user_folder');
    _folders = datalist
        .map((item) => Folder(
            id: item['id'],
            title: item['title'],
            description: item['description'],
            createdAt: item['created_at'],
            category: item['category'],
            days: item['days']))
        .toList();
    print(folders);
    notifyListeners();
  }

  Future<void> deleteFolders(String id) async {
    DBHelper.deleteFolder('user_folder', id);
  }

  void plusOneDay(Folder findedFolder) {
    Folder updatedFolder = findedFolder.copyWith(
      days: findedFolder.days + 1,
    );
    DBHelper.updateFolder('user_folder', updatedFolder);
  }

  void minusOneDay(Folder findedFolder) {
    Folder updatedFolder = findedFolder.copyWith(
      days: findedFolder.days - 1,
    );
    DBHelper.updateFolder('user_folder', updatedFolder);
    
  }
}
