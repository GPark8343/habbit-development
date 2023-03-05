import 'package:flutter/material.dart';
import 'package:habbit/widgets/avatar_widget.dart';

class UserCard extends StatelessWidget {
  final String userId;
  final String description;
  const UserCard({
    Key? key,
    required this.userId,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/360*3),
      width: MediaQuery.of(context).size.width / 360 * 150,
      height: MediaQuery.of(context).size.width / 360 * 220,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width / 360 * 5),
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 15,
            right: 15,
            top: 0,
            bottom: 0,
            child: Column(
              children: [
                 SizedBox(height: MediaQuery.of(context).size.width/360*10),
                AvatarWidget(
                  type: AvatarType.TYPE2,
                  thumbPath:
                      'https://thumbs.dreamstime.com/b/photo-portrait-cheerful-cool-swag-trend-trendy-guy-leaving-his-feedback-social-media-network-using-smart-phone-photo-145377495.jpg',
                size:MediaQuery.of(context).size.width/360*80,  
                ),
               SizedBox(height: MediaQuery.of(context).size.width/360*10),
                Text(
                  userId,
                  style:  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width/360*13,
                  ),
                ),
                Text(
                  description,
                  style:  TextStyle(
                    fontSize: MediaQuery.of(context).size.width/360*13,
                  ),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(onPressed: () {}, child: const Text('Follow'))
              ],
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.close,
                size: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
