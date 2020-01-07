import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:quiver/async.dart';

class TimerButton extends StatefulWidget {
  @override
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {

  int _start = 13;
  String display = '13';

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {


        if((_start - duration.elapsed.inSeconds) <10)
        {
          setState(() {
          display = (_start - duration.elapsed.inSeconds).toString().padLeft(2, '0');
          });
        }else{
          setState(() {
            display = (_start - duration.elapsed.inSeconds).toString();
          });
        }

      });


    sub.onDone(() {
      print("Done");
      sub.cancel();
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Timer test")),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              startTimer();
            },
            child: Text("start"),
          ),
          SizedBox(height: 10.0,),
          Center(child: Text("0:$display",style: TextStyle(
            fontSize: 30.0
         ),
         )
         )
        ],
      ),
    );
  }
}