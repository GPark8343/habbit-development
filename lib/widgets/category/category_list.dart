import 'package:flutter/material.dart';
import 'package:habbit/colors.dart';
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
        RadioListTile(activeColor: mainColor,
          //ListTile - title에는 내용,
          //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
          title: Text('Reading',
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
        RadioListTile(activeColor: mainColor,
          title: Text('Exercise',
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
        RadioListTile(activeColor: mainColor,
          title: Text('Language',
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
        RadioListTile(activeColor: mainColor,
          title: Text('Etc',
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
    );
  }
}
