import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:habbit/widgets/category/category_list.dart';
import 'package:provider/provider.dart';

enum Fruit { Apple, Grapes, Pear, Lemon }

class AddFolderButton extends StatefulWidget {
  @override
  State<AddFolderButton> createState() => _AddFolderButtonState();
}

class _AddFolderButtonState extends State<AddFolderButton> {
  @override
  Widget build(BuildContext context) {
    final _priceFocusNode = FocusNode();
    final _descriptionFocusNode = FocusNode();
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();

    String? _pickedCategory;
    Fruit? _fruit = Fruit.Apple;

    void _selectCategory(Fruit pickedCategory) {
      _pickedCategory = pickedCategory.toString();
      print(_pickedCategory);
    }

    void _saveFolder() {
      if (_titleController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _pickedCategory == null) {
        Navigator.of(context).pop(); // 빈 스토리는 작성 못하게 해야 함
        return;
      }
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Provider.of<FolderManage>(context, listen: false).addFolders(
          _titleController.text, _descriptionController.text, _pickedCategory!);
    }

    @override
    void dispose() {
      _priceFocusNode.dispose();
      _descriptionFocusNode.dispose();
      super.dispose();
    }

    return ElevatedButton(
      child: Text('add your folder'),
      onPressed: () {
        showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('카테고리를 선택하세요'),
                actions: <Widget>[
                  CategoryList(),
                  // Container(
                  //   child: Consumer<CategoryList>(
                  //       builder: (context, categoryList, child) {
                  //     return Flexible(
                  //       child: ListView.builder(
                  //           shrinkWrap: true,
                  //           itemCount: categoryList.categories.length,
                  //           itemBuilder: (BuildContext context, int index) {
                  //             return CheckboxListTile(
                  //               value: categoryList.selectedCategories
                  //                   .contains(categoryList.categories[index]),
                  //               onChanged: (bool? selected) {
                  //                 var categoriesModel =
                  //                     context.read<CategoryList>();
                  //                 categoriesModel
                  //                     .toggle(categoryList.categories[index]);
                  //               },
                  //               title: Text(categoryList.categories[index]),
                  //             );
                  //           }),
                  //     );
                  //   }),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: Text('취소'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      ElevatedButton(
                        child: Text('선택 완료'),
                        onPressed: () {
                          _selectCategory(_fruit);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                    'write your file information'),
                                                TextFormField(
                                                  controller: _titleController,
                                                  decoration: InputDecoration(
                                                      labelText: 'Title'),
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  onFieldSubmitted: (_) {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            _priceFocusNode);
                                                  },
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please provide a value.';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      _descriptionController,
                                                  decoration: InputDecoration(
                                                      labelText: 'Description'),
                                                  maxLines: 3,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  focusNode:
                                                      _descriptionFocusNode,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please enter a description.';
                                                    }
                                                    if (value.length < 10) {
                                                      return 'Should be  at least 10 characters long.';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        
                                          foregroundColor: Colors.black),
                                      onPressed: () {
                                        _saveFolder();
                                        // Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.add),
                                      label: Text('Add Story'),
                                    )
                                  ],
                                );
                              });

                          // Navigator.of(context).pushNamed(
                          //   UploadScreen.routeName,
                          //   // arguments:
                          // );
                        },
                      ),
                    ],
                  )
                ],
              );
            });
      },
    );
  }
}
