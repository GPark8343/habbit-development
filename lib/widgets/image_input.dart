import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.camera,
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
    widget.onSelectImage(savedImage);
  }

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
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: MediaQuery.of(context).size.width / 360 * 150,
        height: MediaQuery.of(context).size.width / 360 * 100,
        decoration: BoxDecoration(
            border: Border.all(
                width: MediaQuery.of(context).size.width / 360,
                color: Colors.grey)),
        child: _storedImage != null
            ? Image.file(
                _storedImage!,
                fit: BoxFit.cover,
                width: double.infinity,
              )
            : Text(
                'No Image Taken',
                textAlign: TextAlign.center,
              ),
        alignment: Alignment.center,
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width / 360 * 10,
        height: MediaQuery.of(context).size.width / 360 * 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 360 * 100,
            height: MediaQuery.of(context).size.width / 360 * 50,
            child: TextButton.icon(
              onPressed: _takePicture,
              icon: Icon(Icons.camera),
              label: Text('Take Picture'),
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.white),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 360 * 100,
            height: MediaQuery.of(context).size.width / 360 * 50,
            child: TextButton.icon(
              onPressed: _takeGallery,
              icon: Icon(Icons.browse_gallery),
              label: Text('Take Gallery'),
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.white),
            ),
          )
        ],
      ),

      // Expanded(
      //    )
    ]);
  }
}
