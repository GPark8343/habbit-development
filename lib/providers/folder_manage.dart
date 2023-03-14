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
    return _folders.firstWhere((folder) => folder.id == id,
        orElse: () => Folder(
            id: 'id',
            title: 'title',
            description: 'description',
            createdAt: 'createdAt',
            category: 'category',
            days: 0));
  }

  Future<void> addFolders(String pickedTitle, String pickedDescription,
      String pickedCategory) async {
    final newFolder = Folder(
        id: Uuid().v1(),
        title: pickedTitle,
        description: pickedDescription,
        createdAt: DateTime.now().toString(),
        category: pickedCategory,
        days: 1);
    _folders.add(newFolder);
    notifyListeners();
    DBHelper.insertFolder('iuser_folder', {
      'id': newFolder.id,
      'title': newFolder.title,
      'description': newFolder.description,
      'created_at': newFolder.createdAt,
      'category': newFolder.category,
      'days': 1,
    });
  }

  Future<void> fetchAndSetFolders() async {
    final datalist = await DBHelper.getFolderData('iuser_folder');
    _folders = datalist
        .map((item) => Folder(
            id: item['id'],
            title: item['title'],
            description: item['description'],
            createdAt: item['created_at'],
            category: item['category'],
            days: item['days']))
        .toList();
   
    notifyListeners();
  }

  Future<void> deleteFolders(String id) async {
    DBHelper.deleteFolder('iuser_folder', id);
  }

  void plusOneDay(Folder findedFolder) {
    Folder updatedFolder = findedFolder.copyWith(
      days: findedFolder.days + 1,
    );
    DBHelper.updateFolder('iuser_folder', updatedFolder);
  }

  void minusOneDay(Folder findedFolder) {
    Folder updatedFolder = findedFolder.copyWith(
      days: findedFolder.days - 1,
    );
    DBHelper.updateFolder('iuser_folder', updatedFolder);
  }

  void controlDay(Folder findedFolder, int allDifferenceTypeOfDay) {
    Folder updatedFolder = findedFolder.copyWith(
      days: allDifferenceTypeOfDay + 1,
    );
    DBHelper.updateFolder('iuser_folder', updatedFolder);
  }
}
