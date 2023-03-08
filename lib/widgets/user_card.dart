import 'package:flutter/material.dart';
import 'package:habbit/colors.dart';
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
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 360 * 3),
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
            left: MediaQuery.of(context).size.width / 360 * 15,
            right: MediaQuery.of(context).size.width / 360 * 15,
            top: 0,
            bottom: 0,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.width / 360 * 10),
                AvatarWidget(
                  type: AvatarType.TYPE2,
                  thumbPath:
                      'https://thumbs.dreamstime.com/b/photo-portrait-cheerful-cool-swag-trend-trendy-guy-leaving-his-feedback-social-media-network-using-smart-phone-photo-145377495.jpg',
                  size: MediaQuery.of(context).size.width / 360 * 80,
                ),
                SizedBox(height: MediaQuery.of(context).size.width / 360 * 10),
                Text(
                  userId,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width / 360 * 13,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 360 * 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                    onPressed: () {},
                    child: const Text('Follow'))
              ],
            ),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width / 360 * 5,
            top: MediaQuery.of(context).size.width / 360 * 5,
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.close,
                size: MediaQuery.of(context).size.width / 360 * 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
