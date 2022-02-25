#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <VTMProductLib/VTMBLEEnum.h>
#import <VTMProductLib/VTMBLEStruct.h>

@class VTMURATUtils;
@protocol VTMURATDeviceDelegate <NSObject>

@optional
- (void)utilDeployCompletion:(VTMURATUtils * _Nonnull)util;

- (void)utilDeployFailed:(VTMURATUtils * _Nonnull)util;

- (void)util:(VTMURATUtils * _Nonnull)util updateDeviceRSSI:(NSNumber *_Nonnull)RSSI;

@end

@protocol VTMURATUtilsDelegate <NSObject>

@optional
- (void)util:(VTMURATUtils * _Nonnull)util commandCompletion:(u_char)cmdType deviceType:(VTMDeviceType)deviceType response:(NSData * _Nullable)response;

- (void)util:(VTMURATUtils * _Nonnull)util commandFailed:(u_char)cmdType deviceType:(VTMDeviceType)deviceType failedType:(VTMBLEPkgType)type;


- (void)receiveHeartRateByStandardService:(Byte)hrByte;

@end

@interface VTMURATUtils : NSObject

@property (nonatomic, assign) id<VTMURATUtilsDelegate> _Nullable delegate;

@property (nonatomic, assign) id <VTMURATDeviceDelegate> _Nullable deviceDelegate;

@property (nonatomic) BOOL notifyHeartRate;

@property (nonatomic) BOOL notifyDeviceRSSI;

@property (nonatomic, strong) CBPeripheral * _Nonnull peripheral;

@property (nonatomic, assign, readonly) VTMDeviceType currentType;

- (void)requestDeviceInfo;

- (void)requestBatteryInfo;

- (void)syncTime:(NSDate * _Nullable)date;

- (void)requestFilelist;

- (void)prepareReadFile:(NSString * _Nonnull)fileName;

- (void)readFile:(u_int)offset;

- (void)endReadFile;

- (void)factoryReset;

@end

@interface VTMURATUtils (ECG)

- (void)requestECGConfig;

- (void)requestECGRealData;

- (void)syncER1Config:(VTMER1Config)config;

- (void)syncER2Config:(VTMER2Config)config;

@end

@interface VTMURATUtils (BP)

- (void)requestBPConfig;

- (void)syncBPSwitch:(BOOL)swi;

- (void)requestBPRealData;

@end

@interface VTMURATUtils (Scale)

- (void)requestScaleRealWve;

- (void)requestScaleRunPrams;

- (void)requestScaleRealData;

@end

