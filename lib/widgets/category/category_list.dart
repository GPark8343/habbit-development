import 'package:flutter/material.dart';
import 'package:habbit/providers/category_list.dart';
import 'package:provider/provider.dart';

enum Fruit { Apple, Grapes, Pear, Lemon }
 

class CategoryList extends StatefulWidget {

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
   Fruit? _fruit = Fruit.Apple;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile(
          //ListTile - title에는 내용,
          //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
          title: const Text('Apple'),

          value: Fruit.Apple,
          groupValue: _fruit,
          onChanged: (Fruit? value) {
            setState(() {
              _fruit = value;
            });
          },
        ),
        RadioListTile(
          title: const Text('Grapes'),
          value: Fruit.Grapes,
          groupValue: _fruit,
          onChanged: (Fruit? value) {
            setState(() {
              _fruit = value;
            });
          },
        ),
        RadioListTile(
          title: const Text('Pear'),
          value: Fruit.Pear,
          groupValue: _fruit,
          onChanged: (Fruit? value) {
            setState(() {
              _fruit = value;
            });
          },
        ),
        RadioListTile(
          title: const Text('Lemon'),
          value: Fruit.Lemon,
          groupValue: _fruit,
          onChanged: (Fruit? value) {
            setState(() {
              _fruit = value;
            });
          },
        ),
      ],
    );
  }
}
