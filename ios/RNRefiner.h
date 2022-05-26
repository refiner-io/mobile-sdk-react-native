#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#import <React/RCTEventEmitter.h>

#pragma mark - EVENT NAMES
static NSString *const kRefinerOnBeforeShow     = @"onBeforeShow";
static NSString *const kRefinerOnNavigation     = @"onNavigation";
static NSString *const kRefinerOnShow           = @"onShow";
static NSString *const kRefinerOnClose          = @"onClose";
static NSString *const kRefinerOnDismiss        = @"onDismiss";
static NSString *const kRefinerOnComplete       = @"onComplete";

#pragma mark - Constant Name
static NSString *const kRefinerFormId           = @"formId";
static NSString *const kRefinerFormConfig       = @"formConfig";
static NSString *const kRefinerProgress         = @"progress";
static NSString *const kRefinerFormData         = @"formData";

@interface RNRefiner : NSObject <RCTBridgeModule>

@end

@interface RNRefinerEventEmitter : RCTEventEmitter

+ (instancetype)sharedInstance;
- (void) registerEvents;

@end
