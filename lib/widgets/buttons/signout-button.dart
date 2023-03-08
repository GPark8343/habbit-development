import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habbit/colors.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

 

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,

          
          child: Text(
            '로그아웃',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 360 * 15,
                color: mainColor,
                fontWeight: FontWeight.bold),
          ),
      
      ),
    );
  }
}
