// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import "package:flare_flutter/flare_actor.dart";
import "package:flare_flutter/flare_cache_builder.dart";
import 'package:flutter/material.dart';

/// Animation widget that animates number digits to the next subsequent number
class NumberAnimation extends StatelessWidget {
  final String fromDigit; // digit from last render
  final String toDigit; // digit for current render

  /// Array of animation file names where the index corresponds to the digit
  /// to be animated.
  ///
  /// For example, index 1 will contain the animation from 0 to 1.
  /// Animations to 0 are a special condition and will be managed by [_zeroAnimationMap]
  final _animArray = [
    "0",
    "0to1",
    "1to2",
    "2to3",
    "3to4",
    "4to5",
    "5to6",
    "6to7",
    "7to8",
    "8to9"
  ];

  /// Map of animation file names to zero where key is the digit to animate from.
  ///
  /// Animations to 0 are a special condition because there can be multiple
  /// digits that can transition to 0.
  final _zeroAnimationMap = <String, String>{"9": "9to0"};

  NumberAnimation({this.fromDigit, this.toDigit});

  @override
  Widget build(BuildContext context) {
    // Animations are from previous number to current number.
    var animTo = int.parse(toDigit);
    var animFrom = animTo - 1;

    var animName = "";
    if (toDigit == "0") {
      // If animation exists fromDigit -> toDigit, then use animation from map;
      // Otherwise, use 0 image with no animation.
      if (_zeroAnimationMap.containsKey(fromDigit)) {
        animName = _zeroAnimationMap[fromDigit];
      } else {
        animName = _animArray[0];
      }
    } else {
      // Generate animation file name.
      animName = "$animFrom" + "to" + "$animTo";
    }

    // Attach file extension.
    var filename = "assets/" + animName + ".flr";

    return FlareCacheBuilder([filename],
        builder: (BuildContext context, bool isWarm) {
      return FlareActor(filename, animation: animName, fit: BoxFit.fitHeight);
    });
  }
}
