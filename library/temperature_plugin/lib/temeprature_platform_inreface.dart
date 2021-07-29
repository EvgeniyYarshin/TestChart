import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:temperature_plugin/temeperature_channel.dart';

abstract class TemperaturePlatform extends PlatformInterface {
  /// Constructs a BatteryPlatform.
  TemperaturePlatform() : super(token: _token);

  static final Object _token = Object();

  static TemperaturePlatform _instance = MethodChannelTemperature();

  /// The default instance of [TemperaturePlatform] to use.
  ///
  /// Defaults to [MethodChannelTemperature].
  static TemperaturePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [TemperaturePlatform] when they register themselves.
  static set instance(TemperaturePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// gets battery state from device.
  Stream<int> onTemperatureStateChanged() {
    throw UnimplementedError(
        'onBatteryStateChanged() has not been implemented.');
  }
}
