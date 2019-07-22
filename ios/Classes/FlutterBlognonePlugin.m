#import "FlutterBlognonePlugin.h"
#import <flutter_blognone/flutter_blognone-Swift.h>

@implementation FlutterBlognonePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterBlognonePlugin registerWithRegistrar:registrar];
}
@end
