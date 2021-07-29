import 'package:flutter/services.dart';
import 'package:temperature_plugin/temeprature_platform_inreface.dart';

class MethodChannelTemperature extends TemperaturePlatform {
  final EventChannel eventChannel = const EventChannel('temperature_plugin');

  /// Stream variable for storing battery state.
  Stream<int>? _onTemperatureStateChanged;

  /// Event channel for getting battery change state.
  @override
  Stream<int> onTemperatureStateChanged() {
    _onTemperatureStateChanged ??= eventChannel
          .receiveBroadcastStream()
          .map((dynamic event) => event);

    return _onTemperatureStateChanged!;
  }
}
