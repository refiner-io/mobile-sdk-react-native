#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

@interface RNRefiner : NSObject <RCTBridgeModule>
@property (nonatomic, copy, nullable) void (^onBeforeShow)(NSString *, id);
@property (nonatomic, copy, nullable) void (^onNavigation)(NSString *, id, id);
@property (nonatomic, copy, nullable) void (^onShow)(NSString *);
@property (nonatomic, copy, nullable) void (^onClose)(NSString *);
@property (nonatomic, copy, nullable) void (^onDismiss)(NSString *);
@property (nonatomic, copy, nullable) void (^onComplete)(NSString *, id);
@end
