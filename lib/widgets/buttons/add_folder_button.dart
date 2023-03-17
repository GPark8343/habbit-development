import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/widgets/category/category_list.dart';


class AddFolderButton extends StatefulWidget {

  
  @override
  State<AddFolderButton> createState() => _AddFolderButtonState();
}

class _AddFolderButtonState extends State<AddFolderButton> {
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(backgroundColor: mainColor),
      icon: Icon(Icons.edit),
      onPressed: () {
        showDialog<bool>(
            context: context,
            builder: (ctx) {
              return CategoryList();
            });
      },
    );
  }
}
