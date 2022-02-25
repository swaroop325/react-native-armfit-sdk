#import "ArmfitSdk.h"
#import "React/RCTBridge.h"
#import "React/RCTConvert.h"
#import "React/RCTEventDispatcher.h"
#import "VTBLEUtils.h"
#import "VTMProductURATUtils.h"
#import "VTMURATUtils.h"
#import "VTMBLEParser.h"



typedef enum : NSUInteger {
    DeviceStatusSleep = 0,
    DeviceStatusMemery,
    DeviceStatusCharge,
    DeviceStatusReady,
    DeviceStatusBPMeasuring,
    DeviceStatusBPMeasureEnd,
    DeviceStatusECGMeasuring,
    DeviceStatusECGMeasureEnd,
    DeviceStatusDisconnected,
    DeviceStatusConnected,
    
} DeviceStatus;


//ECG
#define ER1_ShowPre @"ER1 " //ER1
#define VisualBeat_ShowPre @"VisualBeat " //VisualBeat
#define ER2_ShowPre @"ER2 " //ER2
#define DuoEK_ShowPre @"DuoEK " //DuoEK

//BP
#define BP2_ShowPre @"BP2" //BP2
#define BP2A_ShowPre @"BP2A" //BP2A

//Scale
#define LeS1_ShowPre @"le S1-" //le S1

@interface ArmfitSdk ()<VTBLEUtilsDelegate,VTMURATDeviceDelegate,VTMURATUtilsDelegate>
@property (nonatomic, strong) NSMutableArray *deviceListArray;
@property (nonatomic, strong) NSMutableArray *deviceIDArray;
@property (nonatomic, strong) NSMutableData *downloadData;
@property (nonatomic, copy) NSString *downloadName;
@property (nonatomic, assign) u_int downloadLen;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,strong) NSMutableDictionary * dev_dict;


@end

@implementation ArmfitSdk
{
    NSString *dev_name;
    VTDevice *dev_found;
}
static ArmfitSdk * _instance = nil;

RCT_EXPORT_MODULE();
bool hasListeners;

- (instancetype)init
{
    if (self = [super init]) {
        _instance = self;
        [VTMProductURATUtils sharedInstance].delegate = self;
        [VTBLEUtils sharedInstance].delegate = self;
        //        [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
        
    }
    return self;
}

-(void)startObserving {
    hasListeners = YES;
}

-(void)stopObserving {
    hasListeners = NO;
}
+(BOOL)requiresMainQueueSetup
{
    return YES;
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"ArmfitSdkModuleDiscoverPeripheral", @"ArmfitSdkModuleDeviceState", @"ArmfitSdkModuleStopScan", @"ArmfitSdkModuleResult", @"ArmfitSdkModuleFileCountResult", @"ArmfitSdkModuleFile"];
}

#pragma mark --  ble
- (void)updateBleState:(VTBLEState)state{
    NSLog(@"updateBleState >> %ld", (long)state);
    if (state == VTBLEStatePoweredOn) {
        [[VTBLEUtils sharedInstance] startScan];
    }
    if (state == VTBLEStatePoweredOff) {
        [[VTBLEUtils sharedInstance] stopScan];
    }
    if (state == VTBLEStateUnauthorized) {
        [[VTBLEUtils sharedInstance] cancelConnect];
    }
    if (state == VTBLEStateUnknown) {
        [[VTBLEUtils sharedInstance] cancelConnect];
    }
    
}

- (void)didDiscoverDevice:(VTDevice *)device{
    NSLog(@"didDiscoverDevice >> %@", device);
    dev_found = device;
    _deviceListArray = [[NSMutableArray alloc]init];
    _dev_dict = [[NSMutableDictionary alloc]init];
    if(device){
        
        [_dev_dict setObject:[NSString stringWithFormat:@"%@", device.rawPeripheral.identifier] forKey:@"id"];
        [_dev_dict setObject:device.RSSI forKey:@"rssi"];
        [_dev_dict setObject:device.rawPeripheral.name forKey:@"name"];
        [_deviceListArray addObject:_dev_dict];
        
        if (hasListeners) {
            [self sendEventWithName:@"ArmfitSdkModuleDiscoverPeripheral" body:_dev_dict];
        }
    }
    else
    {
        if (hasListeners) {
            [self sendEventWithName:@"ArmfitSdkModuleDiscoverPeripheral" body:@{}];
            
        }
    }
}

- (void) get_device_info
{
    [[VTMProductURATUtils sharedInstance] requestDeviceInfo];
    
}

- (void)didConnectedDevice:(VTDevice *)device{
    CBPeripheral *rawPeripheral = device.rawPeripheral;
    [VTMProductURATUtils sharedInstance].peripheral = rawPeripheral;
    if (hasListeners){
        [self sendEventWithName:@"ArmfitSdkModuleDeviceState" body:[NSNumber numberWithInt:DeviceStatusConnected]];
    }
}

/// @brief This device has been disconnected. Note: If error == nil ，user manually disconnect.
- (void)didDisconnectedDevice:(VTDevice *)device andError:(NSError *)error{
    if (hasListeners){
        [self sendEventWithName:@"ArmfitSdkModuleDeviceState" body:[NSNumber numberWithInt:DeviceStatusDisconnected]];
    }
}

- (void)util:(VTMURATUtils *)util commandCompletion:(u_char)cmdType deviceType:(VTMDeviceType)deviceType response:(NSData *)response{
    if(cmdType == VTMBLECmdGetDeviceInfo) {
        VTMDeviceInfo info = [VTMBLEParser parseDeviceInfo:response];
        NSLog(@"hw_version:%hhu,fw_version:%u,fw_version:%u,sn:%s,branch_code:%s",info.hw_version,info.fw_version,info.fw_version,info.sn.serial_num,info.branch_code);
    }else if(cmdType == VTMBPCmdGetRealData){
        VTMBPRealTimeData bpData = [VTMBLEParser parseBPRealTimeData:response];
        VTMBatteryInfo info = bpData.run_status.battery;
        //        NSLog(@"state:%hhu,percent:%hhu,voltage:%hu",info.state,info.percent,info.voltage);
        VTMBPRunStatus status = bpData.run_status;
        VTMBPRealTimeWaveform waveform = bpData.rt_wav;
        switch (status.status) {
            case DeviceStatusSleep:{
            }
                break;
            case DeviceStatusMemery:{
                
            }
                break;
            case DeviceStatusCharge:{
                
            }
                break;
            case DeviceStatusReady:{
            }
                break;
            case DeviceStatusBPMeasuring:{
                NSData *tempData = [NSData dataWithBytes:waveform.data length:sizeof(waveform.data)];
                VTMBPMeasuringData measuringData = [VTMBLEParser parseBPMeasuringData:tempData];
                if (measuringData.is_deflating_2) {
                    for (int i = 0; i < waveform.wav.sampling_num ; i++) {
                        short prWave = waveform.wav.wave_data[i];
                    }
                }
                if (hasListeners){
                    [self sendEventWithName:@"ArmfitSdkModuleResult" body:[NSNumber numberWithInt:measuringData.pressure]];
                }
                
            }
                break;
            case DeviceStatusBPMeasureEnd:{
                NSData *tempData = [NSData dataWithBytes:waveform.data length:sizeof(waveform.data)];
                VTMBPEndMeasureData endMeasureData = [VTMBLEParser parseBPEndMeasureData:tempData];
                if (hasListeners){
                    [self sendEventWithName:@"ArmfitSdkModuleResult" body:[NSString stringWithFormat: @"%hu %hu %hu", endMeasureData.systolic_pressure, endMeasureData.diastolic_pressure,endMeasureData.pulse_rate]];
                }
                
                [_timer invalidate];
                _timer = nil;
            }
                break;
            case DeviceStatusECGMeasuring:{
                NSData *tempData = [NSData dataWithBytes:waveform.data length:sizeof(waveform.data)];
                VTMECGMeasuringData ecgMeasuringData = [VTMBLEParser parseECGMeasuringData:tempData];
                for (int i = 0; i < waveform.wav.sampling_num ; i++) {
                    if (waveform.wav.wave_data[i] != 0x7FFF) {
                        float mV = [VTMBLEParser bpMvFromShort:waveform.wav.wave_data[i]];
                    }
                }
                if (hasListeners){
                    [self sendEventWithName:@"ArmfitSdkModuleResult" body:[NSNumber numberWithInt:ecgMeasuringData.pulse_rate]];
                }
            }
                break;
            case DeviceStatusECGMeasureEnd:{
                NSData *tempData = [NSData dataWithBytes:waveform.data length:sizeof(waveform.data)];
                VTMECGEndMeasureData ecgEndMeasueData = [VTMBLEParser parseECGEndMeasureData:tempData];
                if (hasListeners) {
                    [self sendEventWithName:@"ArmfitSdkModuleResult" body:[NSString stringWithFormat: @"%hu %hu %u %hu", ecgEndMeasueData.hr, ecgEndMeasueData.qtc,ecgEndMeasueData.result, ecgEndMeasueData.pvcs]];
                }
                [_timer invalidate];
                _timer = nil;
            }
                break;
            default:
                
                break;
        }
    }else if(cmdType == VTMBLECmdSyncTime){
        NSLog(@"Synchronize time successfully");
        
    }else if(cmdType == VTMBLECmdGetFileList){
        VTMFileList list = [VTMBLEParser parseFileList:response];
        NSMutableArray *downloadArr = [NSMutableArray array];
        NSMutableString *fileStr = [NSMutableString string];
        for (int i = 0; i < list.file_num; i++) {
            NSMutableString *temp = [NSMutableString string];
            u_char *file_name = list.fileName[i].str;
            size_t fileLen = strlen((char *)file_name);
            for (int j = 0; j < fileLen; j++) {
                [temp appendString:[NSString stringWithFormat:@"%c",file_name[j]]];
            }
            [downloadArr addObject:temp];
            [fileStr appendString:[NSString stringWithFormat:@"%@\n", temp]];
        }
        
        if (downloadArr.count > 0) {
            self.downloadName = downloadArr[arc4random() % downloadArr.count];
            [[VTMProductURATUtils sharedInstance] prepareReadFile:self.downloadName];
            if (hasListeners) {
                [self sendEventWithName:@"ArmfitSdkModuleFileCountResult" body:[NSString stringWithFormat: @"%lu", (unsigned long)downloadArr.count]];
            }
        }
        
    }else if(cmdType == VTMBLECmdStartRead){
        _downloadLen = 0;
        _downloadData = [NSMutableData data];
        VTMOpenFileReturn fsrr = [VTMBLEParser parseFileLength:response];
        _downloadLen = fsrr.file_size;
        if (fsrr.file_size == 0) {
            [[VTMProductURATUtils sharedInstance] endReadFile];
        }else{
            [[VTMProductURATUtils sharedInstance] readFile:0];
        }
        if (hasListeners) {
            [self sendEventWithName:@"ArmfitSdkModuleFile" body:_downloadData];
        }
        
    }else if (cmdType == VTMBLECmdReadFile) {
        [_downloadData appendData:response];
        if (_downloadData.length == _downloadLen){
            [[VTMProductURATUtils sharedInstance] endReadFile];
        }else{
            [[VTMProductURATUtils sharedInstance] readFile:(u_int)_downloadData.length];
        }
        if (hasListeners) {
            [self sendEventWithName:@"ArmfitSdkModuleFile" body:_downloadData];
        }
        
    }else if(cmdType == VTMBLECmdEndRead){
        Byte *b = _downloadData.mutableBytes;
        int type = b[1]; // BP2 -- ECG/BP ; BP2A -- BP
        
        if (type == 2) { //   ECG
            VTMBPECGResult result = [VTMBLEParser parseECGResult:[_downloadData subdataWithRange:NSMakeRange(0, sizeof(VTMBPECGResult))]];
            NSLog(@"fileName:%@\tHeart Rate: %d", self.downloadName,result.hr);
            NSArray *ecgWaveArr = [VTMBLEParser parseBPPoints:[_downloadData subdataWithRange:NSMakeRange(sizeof(VTMBPECGResult), _downloadData.length - sizeof(VTMBPECGResult))]];
            if (hasListeners) {
                [self sendEventWithName:@"ArmfitSdkModuleFile" body:ecgWaveArr];
            }
            
        }else if (type == 1){ // BP
            VTMBPBPResult result = [VTMBLEParser parseBPResult:_downloadData];
            NSLog(@"fileName: %@\tSYS: %d\tDIA: %d\tMAP: %d\tPR: %d", self.downloadName,result.systolic_pressure, result.diastolic_pressure, result.mean_pressure, result.pulse_rate);
            if (hasListeners) {
                [self sendEventWithName:@"ArmfitSdkModuleFile" body:[NSString stringWithFormat: @"%hu %hu %u", result.systolic_pressure, result.diastolic_pressure,result.pulse_rate]];
            }
            
        }else {
            NSLog(@"Error");
        }
        
    }else if (cmdType == VTMBLECmdRestore) {
        NSLog(@"Factory Settings restored successfully");
    }else if (cmdType == VTMBLECmdRestoreInfo) {
        NSLog(@"Set successfully");
    }else if (cmdType == VTMBLECmdProductReset){
        NSLog(@"Production factory Settings restored successfully");
    }else if (cmdType == VTMBPCmdGetConfig){
        NSLog(@"Get Config successfully");
        VTMBPConfig  bpConfig =  [VTMBLEParser parseBPConfig:response];
        NSLog(@"Get Config successfully");
        
    }else if (cmdType == VTMBPCmdSetConfig){
        NSLog(@"Set Config successfully");
        
    }
}

#pragma mark ---deviceDelegate
- (void)utilDeployFailed:(VTMURATUtils *)util{
    NSLog(@"utilDeployFailed");
    [[VTBLEUtils sharedInstance] startScan];
}

- (void)utilDeployCompletion:(VTMURATUtils *)util{
    NSLog(@"utilDeployCompletion");
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


RCT_EXPORT_METHOD(start:(nonnull RCTResponseSenderBlock)callback)
{
    callback(@[]);
}

RCT_EXPORT_METHOD(scan:(NSArray *)serviceUUIDStrings scanSeconds:(int)scanSeconds allowDuplicates:(BOOL)allowDuplicates callback:(nonnull RCTResponseSenderBlock)callback)
{
    [self didDiscoverDevice:dev_found];
    serviceUUIDStrings = [[_dev_dict objectForKey:@"id"] mutableCopy];
    scanSeconds = 5;
    allowDuplicates = false;
    if (hasListeners) {
        [self sendEventWithName:@"ArmfitSdkModuleStopScan" body:@{}];
    }
    callback(@[]);
    
}

RCT_EXPORT_METHOD(connect:(NSString *)peripheralUUID callback:(nonnull RCTResponseSenderBlock)callback)
{
    [[VTBLEUtils sharedInstance] stopScan];
    [[VTBLEUtils sharedInstance] connectToDevice:dev_found];
    callback(@[]);
}

RCT_EXPORT_METHOD(stopScan:(nonnull RCTResponseSenderBlock)callback)
{
    if (hasListeners) {
        [self sendEventWithName:@"ArmfitSdkModuleStopScan" body:@{}];
    }
    callback(@[]);
}

RCT_EXPORT_METHOD(retrieveServices:(NSString *)deviceUUID services:(NSArray *)services callback:(nonnull RCTResponseSenderBlock)callback)
{
    callback(@[]);
}

RCT_EXPORT_METHOD(getInfo:(nonnull RCTResponseSenderBlock)callback)
{
    [[VTMProductURATUtils sharedInstance] requestDeviceInfo];
    callback(@[]);
    
}

RCT_EXPORT_METHOD(getData:(nonnull RCTResponseSenderBlock)callback)
{
    callback(@[]);
}

RCT_EXPORT_METHOD(getRealTimeData:(nonnull RCTResponseSenderBlock)callback)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(requestRealtimeData) userInfo: nil repeats:YES];
    });
    callback(@[]);
}
RCT_EXPORT_METHOD(getFiles:(nonnull RCTResponseSenderBlock)callback)
{
    [[VTMProductURATUtils sharedInstance] requestFilelist];
    callback(@[]);
}

+(ArmfitSdk *)getInstance
{
    return _instance;
}

- (void)requestRealtimeData{
    [[VTMProductURATUtils sharedInstance] requestBPRealData];
    [[VTMProductURATUtils sharedInstance]requestECGRealData];
}
@end
