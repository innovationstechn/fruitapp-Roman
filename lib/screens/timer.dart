import 'package:flutter/material.dart';
import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';

class TimerApp extends StatefulWidget {
  static String time;

  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  static const duration = const Duration(seconds: 1);

  int secondsPassed = 0;
  bool isActive = false;

  Timer timer;

  void handleTick() {
    if (isActive && mounted) {
      setState(() {
        secondsPassed = secondsPassed + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (timer == null) {
      timer = Timer.periodic(duration, (Timer t) {
        handleTick();
      });
    }
    int seconds = secondsPassed % 60;
    int minutes = secondsPassed ~/ 60;
    int hours = secondsPassed ~/ (60 * 60);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    color: Colors.blue,
                    height: 30,
                    width: 130,
                    child: Center(
                        child: Text(
                      hours.toString().padLeft(2, '0') +
                          ":" +
                          minutes.toString().padLeft(2, '0') +
                          ":" +
                          seconds.toString().padLeft(2, '0'),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ))),
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
                child: Text(isActive ? 'PAUSE' : 'START'),
                onPressed: () {
                  setState(() {
                    isActive = !isActive;
                  });
                }),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
                child: Text("STOP"),
                onPressed: () {
                  setState(() {
                    secondsPassed = 0;
                    isActive = false;
                    TimerApp.time = hours.toString().padLeft(2, '0') +
                        ":" +
                        minutes.toString().padLeft(2, '0') +
                        ":" +
                        seconds.toString().padLeft(2, '0');
                    Fluttertoast.showToast(msg: "End Time:" + TimerApp.time);
                  });
                }),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
                child: Text("RESTART"),
                onPressed: () {
                  setState(() {
                    secondsPassed = 0;
                    isActive = true;
                  });
                }),
          ],
        )
      ],
    );
  }
}
