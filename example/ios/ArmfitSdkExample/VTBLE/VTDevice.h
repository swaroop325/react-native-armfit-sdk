#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface VTDevice : NSObject

@property (nonatomic, strong) CBPeripheral *rawPeripheral;

@property (nonatomic, copy) NSString *advName;

@property (nonatomic, strong) NSNumber *RSSI;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral adv:(NSDictionary *)advDic RSSI:(NSNumber *)RSSI;


@end

NS_ASSUME_NONNULL_END
