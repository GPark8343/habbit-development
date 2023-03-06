import 'dart:io';
import 'package:flutter/material.dart';
import 'package:habbit/models/folder.dart';
import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:habbit/widgets/image_input.dart';
import 'package:provider/provider.dart';

class AddStoryButton extends StatefulWidget {
  final String folderId;
  final String category;

  AddStoryButton(this.folderId, this.category);

  @override
  State<AddStoryButton> createState() => _AddStoryButtonState();
}

class _AddStoryButtonState extends State<AddStoryButton> {
  @override
  Widget build(BuildContext context) {
    final _priceFocusNode = FocusNode();
    final _descriptionFocusNode = FocusNode();
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();

    File? _pickedImage;
    Folder findedFolder = Provider.of<FolderManage>(context, listen: false)
        .findById(widget.folderId);

    void _selectImage(File pickedImage) {
      _pickedImage = pickedImage;
    }

    void _saveStory() {
      if (_titleController.text.isEmpty ||
          _pickedImage == null ||
          _descriptionController.text.isEmpty) {
        Navigator.of(context).pop(); // 빈 스토리는 작성 못하게 해야 함
        return;
      }
      Provider.of<StoryManage>(context, listen: false).addStories(
          _titleController.text,
          _pickedImage!,
          _descriptionController.text,
          widget.category,
          widget.folderId);
      // Provider.of<FolderManage>(context, listen: false)
      //     .plusOneDay(findedFolder);
      Navigator.of(context).pop();
    }

    @override
    void dispose() {
      _priceFocusNode.dispose();
      _descriptionFocusNode.dispose();
      super.dispose();
    }

    return ElevatedButton(
        child: Text('add your story'),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding:  EdgeInsets.all(MediaQuery.of(context).size.width/360*10.0),
                            child: Column(
                              children: [
                                Text('write your story'),
                                TextFormField(
                                  controller: _titleController,
                                  decoration:
                                      InputDecoration(labelText: 'Title'),
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
                                  height:MediaQuery.of(context).size.width/360*10,
                                ),
                                ImageInput(_selectImage),
                                SizedBox(
                                  height: MediaQuery.of(context).size.width/360*10,
                                ),
                                TextFormField(
                                  controller: _descriptionController,
                                  decoration:
                                      InputDecoration(labelText: 'Description'),
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
                          foregroundColor: Colors.black),
                      onPressed: () {
                        _saveStory();
                        // Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.add),
                      label: Text('Add Story'),
                    )
                  ],
                );
              });
        });
  }
}
