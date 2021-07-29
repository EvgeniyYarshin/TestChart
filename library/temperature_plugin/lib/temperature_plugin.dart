
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:temperature_plugin/temeprature_platform_inreface.dart';

class TemperaturePlugin {
  Stream<int> get onTemperatureStateChanged => TemperaturePlatform.instance.onTemperatureStateChanged();
}
