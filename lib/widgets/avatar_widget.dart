import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum AvatarType { TYPE1, TYPE2, TYPE3 }

class AvatarWidget extends StatelessWidget {
  bool? hasStory;
  String thumbPath;
  String? nickname;
  AvatarType type;
  double? size;

  AvatarWidget({
    Key? key,
    required this.type,
    required this.thumbPath,
    this.hasStory,
    this.nickname,
    this.size = 65,
  }) : super(key: key);

 

  @override
  Widget build(BuildContext context) {
     Widget type2Widget() {
    return Container(
      padding:  EdgeInsets.all(MediaQuery.of(context).size.width/360*2),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size!),
        child: SizedBox(
          width: size,
          height: size,
          child: CachedNetworkImage(
                    imageUrl:
                       thumbPath,
                    fit: BoxFit.cover,
                  ),
        ),
      ),
    );
  }
    Widget type1Widget() {
    return Container(
      margin:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/360*5),
      padding:  EdgeInsets.all(MediaQuery.of(context).size.width/360*2),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.purple,
            Colors.orange,
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: type2Widget(),
    );
  }

 

  Widget type3Widget() {
    return Row(
      children: [
        type1Widget(),
        Text(
          nickname ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:MediaQuery.of(context).size.width/360* 16,
          ),
        ),
      ],
    );
  }

    switch (type) {
      case AvatarType.TYPE1:
        return type1Widget();
      case AvatarType.TYPE2:
        return type2Widget();
      case AvatarType.TYPE3:
        return type3Widget();
    }
  }
}
