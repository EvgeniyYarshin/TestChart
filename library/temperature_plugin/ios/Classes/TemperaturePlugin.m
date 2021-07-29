#import "TemperaturePlugin.h"
#if __has_include(<temperature_plugin/temperature_plugin-Swift.h>)
#import <temperature_plugin/temperature_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "temperature_plugin-Swift.h"
#endif

@implementation TemperaturePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTemperaturePlugin registerWithRegistrar:registrar];
}
@end
