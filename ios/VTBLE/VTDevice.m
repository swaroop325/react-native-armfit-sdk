//
//  VTDevice.m
//  VTMProductSDK
//
//  Created by viatom on 2020/6/23.
//  Copyright © 2020 viatom. All rights reserved.
//

#import "VTDevice.h"
//#import <VTMProductLib/VTMProductLib.h>
#import "VTBLEUtils.h"
#import "VTMProductURATUtils.h"
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
@implementation VTDevice

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral adv:(NSDictionary *)advDic RSSI:(NSNumber *)RSSI{
    self = [super init];
    if (self) {
        self.RSSI = RSSI;
        self.advName = [advDic objectForKey:@"kCBAdvDataLocalName"];
        if (![self.advName isKindOfClass:[NSNull class]] &&
            ![self.advName isEqualToString:@""] &&
            self.advName != nil && 
            ![peripheral.name isEqualToString:self.advName]) {
            [peripheral setValue:self.advName forKey:@"name"];
        }
        self.rawPeripheral = peripheral;
        NSLog(@"scan device:%@",peripheral.name);
        if (![peripheral.name hasPrefix:ER1_ShowPre] &&
            ![peripheral.name hasPrefix:VisualBeat_ShowPre] &&
            ![peripheral.name hasPrefix:ER2_ShowPre] &&
            ![peripheral.name hasPrefix:DuoEK_ShowPre] &&
            ![peripheral.name hasPrefix:BP2_ShowPre]&&
            ![peripheral.name hasPrefix:BP2A_ShowPre]&&
            ![peripheral.name hasPrefix:LeS1_ShowPre]&&
            ![peripheral.name hasPrefix:LeS1_ShowPre]) {
            return nil;
        }
    }
    return self;
}

@end
