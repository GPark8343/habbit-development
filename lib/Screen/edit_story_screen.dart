import 'dart:io';
import 'package:habbit/colors.dart';
import 'package:habbit/models/story.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:habbit/providers/upload.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditStoryScreen extends StatefulWidget {
  static const routeName = '/edit-story';

  @override
  State<EditStoryScreen> createState() => _EditStoryScreenState();
}

class _EditStoryScreenState extends State<EditStoryScreen> {
  File? _storedImage;
  File? _pickedImage;

  final _priceFocusNode = FocusNode();
  final _descriptionController = TextEditingController();
  @override
  void dispose() {
    _priceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final findedStory =
        (ModalRoute.of(context)?.settings.arguments as Map)['story'];
    Future<void> _takeGallery() async {
      final picker = ImagePicker();
      final imageFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: MediaQuery.of(context).size.width / 360 * 600,
      );
      if (imageFile == null) {
        return;
      }
      if (mounted) {
        setState(() {
          _storedImage = File(imageFile.path as String);
        });
      }
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(imageFile.path as String);
      final savedImage = await _storedImage?.copy('${appDir.path}/$fileName');
      final storyManage = Provider.of<StoryManage>(context, listen: false);
      // upload.uploadThumbnail(savedImage!);
      storyManage.changeImage(findedStory, savedImage!);
      _pickedImage = savedImage;
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }

    Future<void> _changeDescription(String selectedDescription) async {
      final upload = Provider.of<Upload>(context, listen: false);
      final storyManage = Provider.of<StoryManage>(context, listen: false);

      storyManage.changeDescription(findedStory, selectedDescription);
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: mainColor, //색변경
          ),
          title: Text(
            'edit profile',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 360 * 25,
                color: mainColor,
                fontWeight: FontWeight.bold),
          )),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Container(
              height: 200,
              child: Image.file(
                (findedStory as Story).image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            TextButton(
                onPressed: _takeGallery,
                child: Text(
                  '사진 수정',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 360 * 15,
                      color: mainColor,
                      fontWeight: FontWeight.bold),
                )),
            Center(
              child: Container(
                width: double.infinity,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width / 360 * 15),
                    child: Center(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 7,
                        (findedStory as Story).description,
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width / 360 * 30,
                            color: textColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0))),
                      context: context,
                      builder: (ctx) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  MediaQuery.of(context).size.width / 360 * 30),
                          child: Container(
                            width: double.infinity,
                            height:
                                MediaQuery.of(context).size.width / 360 * 300,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.width /
                                      360 *
                                      10,
                                ),
                                TextFormField(
                                  maxLines: 10,
                                  controller: _descriptionController,
                                  decoration: InputDecoration(
                                      hintText:
                                          (findedStory as Story).description),
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
                                TextButton(
                                    onPressed: () {
                                      if (_descriptionController.text.isEmpty) {
                                        Navigator.of(context)
                                            .pop(); // 빈 스토리는 작성 못하게 해야 함
                                        return;
                                      }
                                      _changeDescription(
                                          _descriptionController.text);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('변경 완료'))
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Text(
                  '내용 수정',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 360 * 15,
                      color: mainColor,
                      fontWeight: FontWeight.bold),
                )),
          ],
        ),
      )),
    );
  }
}
