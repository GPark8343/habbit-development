import 'package:flutter/material.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/widgets/buttons/add_folder_button.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:habbit/widgets/category/category_list.dart';

enum Kind { Reading, Exercise, Language, Study, Etc }

class CategoryList extends StatefulWidget {
  @override
  State<CategoryList> createState() => _CategoryListState();
}

Kind? _kind = Kind.Reading;

class _CategoryListState extends State<CategoryList> {
  Kind? _kind = Kind.Reading;
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? _pickedCategory;

    void _selectCategory(Kind pickedCategory) {
      _pickedCategory = pickedCategory.toString();
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
      Provider.of<FolderManage>(context, listen: false).fetchAndSetFolders();
    }

    return AlertDialog(
      content: Column(
        children: [
          Text('폴더 만들기(1단계)'),
          SizedBox(
            height: 20,
          ),
          Text('만들 습관의 카테고리를 선택하세요'),
          Column(
            children: [
              RadioListTile(
                activeColor: mainColor,
                //ListTile - title에는 내용,
                //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
                title: Text('독서',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 360 * 17,
                        color: mainColor,
                        fontWeight: FontWeight.bold)),

                value: Kind.Reading,
                groupValue: _kind,
                onChanged: (Kind? value) {
                  setState(() {
                    _kind = value;
                  });
                },
              ),
              RadioListTile(
                activeColor: mainColor,
                title: Text('운동',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 360 * 17,
                        color: mainColor,
                        fontWeight: FontWeight.bold)),
                value: Kind.Exercise,
                groupValue: _kind,
                onChanged: (Kind? value) {
                  setState(() {
                    _kind = value;
                  });
                },
              ),
              RadioListTile(
                activeColor: mainColor,
                title: Text('언어',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 360 * 17,
                        color: mainColor,
                        fontWeight: FontWeight.bold)),
                value: Kind.Language,
                groupValue: _kind,
                onChanged: (Kind? value) {
                  setState(() {
                    _kind = value;
                  });
                },
              ),
              RadioListTile(
                activeColor: mainColor,
                title: Text('공부',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 360 * 17,
                        color: mainColor,
                        fontWeight: FontWeight.bold)),
                value: Kind.Study,
                groupValue: _kind,
                onChanged: (Kind? value) {
                  setState(() {
                    _kind = value;
                  });
                },
              ),
              RadioListTile(
                activeColor: mainColor,
                title: Text('기타',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 360 * 17,
                        color: mainColor,
                        fontWeight: FontWeight.bold)),
                value: Kind.Etc,
                groupValue: _kind,
                onChanged: (Kind? value) {
                  setState(() {
                    _kind = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
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
              style: ElevatedButton.styleFrom(backgroundColor: mainColor),
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: mainColor),
              child: Text('선택 완료'),
              onPressed: () {
                _selectCategory(_kind!);
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width /
                                          360 *
                                          10.0),
                                  child: Column(
                                    children: [
                                      Text('폴더 만들기(2단계)'),
                                      Text('폴더 정보를 입력하세요'),
                                      TextFormField(
                                        controller: _titleController,
                                        decoration:
                                            InputDecoration(labelText: '폴더 제목'),
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(context)
                                              .requestFocus(_priceFocusNode);
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please provide a value.';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width /
                                                360 *
                                                10,
                                      ),
                                      TextFormField(
                                        controller: _descriptionController,
                                        decoration: InputDecoration(
                                            labelText: '폴더에 대한 간략한 설명'),
                                        maxLines: 3,
                                        keyboardType: TextInputType.multiline,
                                        focusNode: _descriptionFocusNode,
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
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                foregroundColor: Colors.white,
                                backgroundColor: mainColor),
                            onPressed: () {
                              _saveFolder();
                              // Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.add),
                            label: Text('폴더 추가하기'),
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
  }
}
