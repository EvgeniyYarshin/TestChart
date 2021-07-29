import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:temperature_plugin/temperature_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('temperature_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await TemperaturePlugin.platformVersion, '42');
  });
}
