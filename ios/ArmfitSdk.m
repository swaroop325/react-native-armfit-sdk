#import "ArmfitSdk.h"
#import "React/RCTBridge.h"
#import "React/RCTConvert.h"
#import "React/RCTEventDispatcher.h"


@implementation ArmfitSdk
static ArmfitSdk * _instance = nil;

RCT_EXPORT_MODULE();

- (instancetype)init
{
    if (self = [super init]) {
    _instance = self;
    }
    return self;
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"ArmfitSdkModuleDiscoverPeripheral", @"ArmfitSdkModuleDeviceState", @"ArmfitSdkModuleStopScan", @"ArmfitSdkModuleResult", @"ArmfitSdkModuleFileCountResult", @"ArmfitSdkModuleFile"];
}

// Example method
// See // https://reactnative.dev/docs/native-modules-ios
RCT_REMAP_METHOD(multiply,
                 multiplyWithA:(nonnull NSNumber*)a withB:(nonnull NSNumber*)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
  NSNumber *result = @([a floatValue] * [b floatValue]);

  resolve(result);
}


//1. public void start(Callback callback)
RCT_EXPORT_METHOD(start:(nonnull RCTResponseSenderBlock)callback)
{
    NSLog(@"start_iOS");
    callback(@[@"start_iOS"]);
}

//2. public void scan(ReadableArray serviceUUIDs, final int scanSeconds, boolean allowDuplicates, ReadableMap options, Callback callback)
RCT_EXPORT_METHOD(scan:(NSArray *)serviceUUIDStrings scanSeconds:(int)scanSeconds allowDuplicates:(BOOL)allowDuplicates options:(NSString *)options callback:(nonnull RCTResponseSenderBlock)callback)
{
    NSLog(@"scant_iOS");
    callback(@[]);
}

//3. public void stopScan(Callback callback)
RCT_EXPORT_METHOD(stopScan:(nonnull RCTResponseSenderBlock)callback)
{
    NSLog(@"stopScan_iOS");
    callback(@[]);
}

//4. public void connect(String peripheralUUID, Callback callback)
RCT_EXPORT_METHOD(connect:(NSString *)peripheralUUID callback:(nonnull RCTResponseSenderBlock)callback)
{
    NSLog(@"stopScan_iOS");
    callback(@[]);
}

//5. public void retrieveServices(String deviceUUID, ReadableArray services, Callback callback)
RCT_EXPORT_METHOD(retrieveServices:(NSString *)deviceUUID services:(NSArray *)services callback:(nonnull RCTResponseSenderBlock)callback)
{
    NSLog(@"retrieveServices_iOS");
    callback(@[]);
}

//6. public void getInfo(Callback callback)
RCT_EXPORT_METHOD(getInfo:(nonnull RCTResponseSenderBlock)callback)
{
    NSLog(@"getInfo_iOS");
    callback(@[]);
}

//7. public void getData(Callback callback)
RCT_EXPORT_METHOD(getData:(nonnull RCTResponseSenderBlock)callback)
{
    NSLog(@"getData_iOS");
    callback(@[]);
}

//8. public void getRealTimeData(Callback callback)
RCT_EXPORT_METHOD(getRealTimeData:(nonnull RCTResponseSenderBlock)callback)
{
    NSLog(@"getRealTimeData_iOS");
    callback(@[]);
}
// 9. public void getFiles(Callback callback)
RCT_EXPORT_METHOD(getFiles:(nonnull RCTResponseSenderBlock)callback)
{
    NSLog(@"getFiles_iOS");
    callback(@[]);
}
     
+(ArmfitSdk *)getInstance
{
    return _instance;
}

@end
