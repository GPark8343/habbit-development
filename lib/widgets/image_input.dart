import 'package:flutter/material.dart';
import 'package:habbit/colors.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _requestCameraPermission() async {
    final serviceStatus = await Permission.camera.isGranted;

    bool isCameraOn = serviceStatus == ServiceStatus.enabled;

    final status = await Permission.camera.request();

    if (status == PermissionStatus.granted) {
      _takePicture();
    } else if (status == PermissionStatus.denied) {
      
    } else if (status == PermissionStatus.permanentlyDenied) {
    
      await openAppSettings();
    }
  }

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

  Future<void> _requestGalleryPermission() async {
    final serviceStatus = await Permission.storage.isGranted;

    bool isStorageOn = serviceStatus == ServiceStatus.enabled;

    final status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      _takeGallery();
    } else if (status == PermissionStatus.denied) {
   
    } else if (status == PermissionStatus.permanentlyDenied) {

      await openAppSettings();
    }
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
                '이미지를 선택해주세요',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 360 * 15),
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
              onPressed: _requestCameraPermission,
              icon: Icon(Icons.camera),
              label: Text(
                '카메라',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 360 * 15),
                textAlign: TextAlign.center,
              ),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: mainColor),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 360 * 100,
            height: MediaQuery.of(context).size.width / 360 * 50,
            child: TextButton.icon(
              onPressed: _requestGalleryPermission,
              icon: Icon(Icons.browse_gallery),
              label: Text(
                '갤러리',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 360 * 15),
                textAlign: TextAlign.center,
              ),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: mainColor),
            ),
          )
        ],
      ),

      // Expanded(
      //    )
    ]);
  }
}
