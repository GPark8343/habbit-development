import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Kind { Reading, Exercise, Language, Etc }
 

class CategoryList extends StatefulWidget {

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
   Kind? _kind = Kind.Reading;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile(
          //ListTile - title에는 내용,
          //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
          title: const Text('Reading'),

          value: Kind.Reading,
          groupValue: _kind,
          onChanged: (Kind? value) {
            setState(() {
              _kind = value;
            });
          },
        ),
        RadioListTile(
          title: const Text('Exercise'),
          value: Kind.Exercise,
          groupValue: _kind,
          onChanged: (Kind? value) {
            setState(() {
              _kind = value;
            });
          },
        ),
        RadioListTile(
          title: const Text('Language'),
          value: Kind.Language,
          groupValue: _kind,
          onChanged: (Kind? value) {
            setState(() {
              _kind = value;
            });
          },
        ),
        RadioListTile(
          title: const Text('Etc'),
          value: Kind.Etc,
          groupValue: _kind,
          onChanged: (Kind? value) {
            setState(() {
              _kind = value;
            });
          },
        ),
      ],
    );
  }
}
