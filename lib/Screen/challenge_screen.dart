import 'package:flutter/material.dart';
import 'package:habbit/widgets/calendar.dart';
import 'package:habbit/widgets/hout_timer.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child:  SingleChildScrollView(
        child: Column(
            children: [
              Calendar(),
              SizedBox(height: 50,),
              HourTimer(),
            ],
          ),
      ),
      
    );
  }
}