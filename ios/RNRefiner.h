#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#import <React/RCTEventEmitter.h>

#pragma mark - EVENT NAMES
static NSString *const kRefinerOnBeforeShow     = @"RefinerOnBeforeShow";
static NSString *const kRefinerOnNavigation     = @"RefinerOnNavigation";
static NSString *const kRefinerOnShow           = @"RefinerOnShow";
static NSString *const kRefinerOnClose          = @"RefinerOnClose";
static NSString *const kRefinerOnDismiss        = @"RefinerOnDismiss";
static NSString *const kRefinerOnComplete       = @"RefinerOnComplete";

#pragma mark - Constant Name
static NSString *const kRefinerFormId           = @"RefinerFormId";
static NSString *const kRefinerFormConfig       = @"RefinerFormConfig";
static NSString *const kRefinerProgress         = @"RefinerProgress";
static NSString *const kRefinerFormData         = @"RefinerFormData";

@interface RNRefiner : NSObject <RCTBridgeModule>

@end

@interface RNRefinerEventEmitter : RCTEventEmitter

+ (instancetype)sharedInstance;
- (void) registerEvents;

@end