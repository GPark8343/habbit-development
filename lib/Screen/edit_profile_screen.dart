import 'dart:io';
import 'package:habbit/colors.dart';
import 'package:habbit/providers/upload.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _storedImage;
  File? _pickedImage;

  Future<void> _takeGallery() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: MediaQuery.of(context).size.width / 360 * 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path as String);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path as String);
    final savedImage = await _storedImage?.copy('${appDir.path}/$fileName');
    final upload = Provider.of<Upload>(context, listen: false);
    upload.uploadThumbnail(savedImage!);
    _pickedImage = savedImage;
  }

  Future<void> _changeName(String selectedName) async {
    final upload = Provider.of<Upload>(context, listen: false);
    upload.uploadNickname(selectedName);
  }

  final _priceFocusNode = FocusNode();
  final _titleController = TextEditingController();
  @override
  void dispose() {
    _priceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: const CircularProgressIndicator(),
                );
              }
              final docData = snapshot.data?.docs.first.data();
              return Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        docData!['thumbnail'],
                      ),
                      backgroundColor: mainColor,
                      radius: 100,
                    ),
                    TextButton(
                        onPressed: _takeGallery,
                        child: Text(
                          '사진 수정',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width / 360 * 15,
                              color: mainColor,
                              fontWeight: FontWeight.bold),
                        )),
                    Center(
                      child: Container(
                        width: double.infinity,
                        child: Card(color: backgroundColor,
                          child: Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width / 360 * 15),
                            child: Center(
                              child: Text(
                                docData['nickname'],
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            360 *
                                            30,
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
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          MediaQuery.of(context).size.width /
                                              360 *
                                              30),
                                  child: Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.width /
                                        360 *
                                        400,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              360 *
                                              10,
                                        ),
                                        TextFormField(
                                          controller: _titleController,
                                          decoration: InputDecoration(
                                              labelText: 'Nickname'),
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
                                        TextButton(
                                            onPressed: () {
                                              if (_titleController
                                                  .text.isEmpty) {
                                                Navigator.of(context)
                                                    .pop(); // 빈 스토리는 작성 못하게 해야 함
                                                return;
                                              }
                                              _changeName(
                                                  _titleController.text);
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
                          '이름 변경',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width / 360 * 15,
                              color: mainColor,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
