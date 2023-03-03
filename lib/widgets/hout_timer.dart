
import 'package:flutter/material.dart';
import 'package:habbit/providers/time_manage.dart';
import 'package:provider/provider.dart';
class HourTimer extends StatelessWidget {
  const HourTimer({super.key});

  @override
  Widget build(BuildContext context) {
     var timer = Provider.of<TimeManage>(context);
    var seconds = timer.seconds;
    var isRunning = timer.isRunning;
    void startTimer() {
          timer.startTimer();
    }

    void stopTimer() {
         timer.stopTimer();
    }

    void resetTimer() {
       timer.resetTimer();
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('$seconds', style: TextStyle(fontSize: 72)),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: isRunning ? null : startTimer,
                child: Text('Start'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: isRunning ? stopTimer : null,
                child: Text('Stop'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: resetTimer,
                child: Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}