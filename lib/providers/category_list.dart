// import 'package:flutter/material.dart';

// class CategoryList extends ChangeNotifier {
//   CategoryList(List<String> categories) {
//     categories.forEach((value) {
//       _categories.putIfAbsent(value, () => false);
//     });
//   }

//   final Map<String, bool> _categories = Map();

//   List<String> get categories => _categories.keys.toList();

//   List<String> get selectedCategories =>
//       _categories.entries.where((e) => e.value).map((e) => e.key).toList();

//   void toggle(String item) {
    
//     notifyListeners();
//   }
// }