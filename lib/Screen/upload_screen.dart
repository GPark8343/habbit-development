// import 'package:flutter/material.dart';
// import 'package:habbit/providers/story_manage.dart';
// import 'package:habbit/widgets/image_input.dart';
// import 'package:provider/provider.dart';
// import 'dart:io';

// class UploadScreen extends StatefulWidget {
//   static const routeName = '/upload-story';
//   @override
//   State<UploadScreen> createState() => _UploadScreenState();
// }

// class _UploadScreenState extends State<UploadScreen> {
//   final _priceFocusNode = FocusNode();
//   final _descriptionFocusNode = FocusNode();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   File? _pickedImage;

//   void _selectImage(File pickedImage) {
//     _pickedImage = pickedImage;
//   }

//   void _saveStory() {
//     if (_titleController.text.isEmpty ||
//         _pickedImage == null ||
//         _descriptionController.text.isEmpty) {
//       return;
//     }
//     Provider.of<StoryManage>(context, listen: false).addStories(
//         _titleController.text, _pickedImage!, _descriptionController.text);
//     Navigator.of(context).pop();
//   }

//   @override
//   void dispose() {
//     _priceFocusNode.dispose();
//     _descriptionFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(appBar: AppBar(title: Text('upload your story')),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//                 child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: _titleController,
//                       decoration: InputDecoration(labelText: 'Title'),
//                       textInputAction: TextInputAction.next,
//                       onFieldSubmitted: (_) {
//                         FocusScope.of(context).requestFocus(_priceFocusNode);
//                       },
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please provide a value.';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     ImageInput(_selectImage),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     TextFormField(
//                       controller: _descriptionController,
//                       decoration: InputDecoration(labelText: 'Description'),
//                       maxLines: 3,
//                       keyboardType: TextInputType.multiline,
//                       focusNode: _descriptionFocusNode,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter a description.';
//                         }
//                         if (value.length < 10) {
//                           return 'Should be  at least 10 characters long.';
//                         }
//                         return null;
//                       },
//                     ),
//                     ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                           elevation: 0,
//                           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                           backgroundColor: Theme.of(context).accentColor,
//                           foregroundColor: Colors.black),
//                       onPressed: _saveStory,
//                       icon: Icon(Icons.add),
//                       label: Text('Add Story'),
//                     )
//                   ],
//                 ),
//               ),
//             )),
//           ],
//         ),
//       ),
//     );
//   }
// }
