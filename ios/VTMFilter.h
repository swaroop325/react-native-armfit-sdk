#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VTMFilter : NSObject

+ (VTMFilter *)shared;

- (void)resetParams;

- (NSArray *)sfilterPointValue:(NSArray <NSNumber *>*)ptArray;

- (NSArray *)filterPointValue:(double)ptValue;

- (NSArray *)offlineFilterPoints:(NSArray <NSNumber *>*)ptArray;

@end

NS_ASSUME_NONNULL_END
