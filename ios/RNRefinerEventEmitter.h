#import <React/RCTEventEmitter.h>

@interface RNRefinerEventEmitter : RCTEventEmitter

+ (instancetype)sharedInstance;
- (void) registerEvents;

@end
