// import 'package:flutter/material.dart';
// import 'package:habbit/providers/category_list.dart';
// import 'package:provider/provider.dart';

// class CategoryFilter extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<CategoryList>(builder: (context, categoryList, child) {
//       return Flexible(
//         child: ListView.builder(
//             itemCount: categoryList.categories.length,
//             itemBuilder: (BuildContext context, int index) {
//               return CheckboxListTile(
//                 value: categoryList.selectedCategories
//                     .contains(categoryList.categories[index]),
//                 onChanged: (bool? selected) {
//                   var categoriesModel = context.read<CategoryList>();
//                   categoriesModel.toggle(categoryList.categories[index]);
//                 },
//                 title: Text(categoryList.categories[index]),
//               );
//             }),
//       );
//     });
//   }
// }