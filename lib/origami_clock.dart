import 'dart:async';

import 'package:clock_app/number_animation.dart';
import "package:flutter/material.dart";
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

/// Clock developed for the Flutter Clock challenge.
///
/// This submission utilizes the Flare animation library to provide
/// custom made origami animations to transition from one digit to another.
///
/// @author: Calvin Lam
class OrigamiClock extends StatefulWidget {
  const OrigamiClock(this.model);

  final ClockModel model;

  @override
  _OrigamiClockState createState() => _OrigamiClockState();
}

class _OrigamiClockState extends State<OrigamiClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(OrigamiClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        // Update once per second, but make sure to do it at the beginning of each
        // new second, so that the clock is accurate.
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  String _formatHour(DateTime time) {
    return DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(time);
  }

  String _formatMinute(DateTime time) {
    return DateFormat('mm').format(time);
  }

  String _formatSecond(DateTime time) {
    return DateFormat('ss').format(time);
  }

  Row _renderClockUI(double clockWidth, double clockHeight) {
    var colonImage = Image.asset("assets/colon.png", height: 40, width: 40);
    const smallSpacing = 40.0; // width spacing for colon and seconds

    // Format each digit of HH:mm:ss time from last render and current.
    var previousTime = _dateTime.subtract(Duration(seconds: 1));
    final previousHour = _formatHour(previousTime);
    final currentHour = _formatHour(_dateTime);
    final previousMinute = _formatMinute(previousTime);
    final currentMinute = _formatMinute(_dateTime);
    final previousSecond = _formatSecond(previousTime);
    final currentSecond = _formatSecond(_dateTime);

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // First digit of hour
          Expanded(
              flex: 1,
              child: NumberAnimation(
                  fromDigit: previousHour[0], toDigit: currentHour[0])),
          // Second digit of hour.
          Expanded(
              flex: 1,
              child: NumberAnimation(
                  fromDigit: previousHour[1], toDigit: currentHour[1])),
          // colon
          Container(
            height: clockHeight / 2,
            width: smallSpacing,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [colonImage, colonImage]),
          ),
          // First digit of minute
          Expanded(
              flex: 1,
              child: NumberAnimation(
                  fromDigit: previousMinute[0], toDigit: currentMinute[0])),
          // Second digit of minute.
          Expanded(
              flex: 1,
              child: NumberAnimation(
                  fromDigit: previousMinute[1], toDigit: currentMinute[1])),
          // First digit of second
          Container(
              width: smallSpacing,
              height: clockHeight / 4,
              child: NumberAnimation(
                  fromDigit: previousSecond[0], toDigit: currentSecond[0])),
          // Second digit of minute.
          Container(
              width: smallSpacing,
              height: clockHeight / 4,
              child: NumberAnimation(
                  fromDigit: previousSecond[1], toDigit: currentSecond[1])),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    var clockWidth = screenWidth * 0.8;
    var clockHeight = screenHeight * 0.7;

    return Stack(children: <Widget>[
      Image.asset(
        "assets/background.png",
        width: screenWidth,
        height: screenHeight,
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
              child: Container(
                  width: clockWidth,
                  height: clockHeight,
                  child: _renderClockUI(clockWidth, clockHeight))))
    ]);
  }
}
