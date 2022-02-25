#import "VTMProductURATUtils.h"

@implementation VTMProductURATUtils

static VTMProductURATUtils *URATUtils = nil;
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        URATUtils = [[self alloc] init];
    });
    return URATUtils;
}

@end
