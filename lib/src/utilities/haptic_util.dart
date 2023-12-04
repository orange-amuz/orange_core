import 'dart:io';

import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class HapticUtil {
  static void vibrateSelection() {
    if (Platform.isIOS) {
      HapticFeedback.selectionClick();
    } else {
      Vibration.vibrate(duration: 25, amplitude: 32);
    }
  }

  static void vibrateLightImpact() {
    if (Platform.isIOS) {
      HapticFeedback.lightImpact();
    } else {
      Vibration.vibrate(duration: 50, amplitude: 64);
    }
  }
}
