#import "RNRefinerEventEmitter.h"
#import "RNRefiner.h"
#import <RefinerSDK/RefinerSDK-Swift.h>

@implementation RNRefinerEventEmitter

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[
        kRefinerOnBeforeShow,
        kRefinerOnNavigation,
        kRefinerOnShow,
        kRefinerOnClose,
        kRefinerOnDismiss,
        kRefinerOnComplete
    ];
}

+ (instancetype)sharedInstance {
    static RNRefinerEventEmitter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    return self;
}
/*
 Thread 1: "Error when sending event: deneme with body: scrollToTopHomeFeed. RCTCallableJSModules is not set. This is probably because you've explicitly synthesized the RCTCallableJSModules in RNRefinerEventEmitter, even though it's inherited from RCTEventEmitter."
 */
- (void) registerEvents {
    [[Refiner instance] setOnBeforeShow:^(NSString * formId, id formConfig) {
        [self emitEventInternal:kRefinerOnBeforeShow andBody: @{kRefinerFormId: formId,
                                                                kRefinerFormConfig: formConfig}];
    }];
//
//    [[Refiner instance] setOnNavigation:^(NSString * formId, id formConfig, id progress) {
//        [self emitEventInternal:kRefinerOnNavigation andBody: @{kRefinerFormId: formId,
//                                                                kRefinerFormConfig: formConfig,
//                                                                kRefinerProgress: progress}];
//    }];
//
//    [[Refiner instance] setOnShow:^(NSString * formId) {
//        [self emitEventInternal:kRefinerOnShow andBody: @{kRefinerFormId: formId}];
//    }];
//
//    [[Refiner instance] setOnClose:^(NSString * formId) {
//        [self emitEventInternal:kRefinerOnClose andBody: @{kRefinerFormId: formId}];
//    }];
//
//    [[Refiner instance] setOnDismiss:^(NSString * formId) {
//        [self emitEventInternal:kRefinerOnDismiss andBody: @{kRefinerFormId: formId}];
//    }];
//
//    [[Refiner instance] setOnComplete:^(NSString * formId, id formData) {
//        [self emitEventInternal:kRefinerOnComplete andBody:  @{kRefinerFormId: formId,
//                                                               kRefinerFormData: formData}];
//    }];
}

#pragma mark - Private
- (void)emitEventInternal:(NSString *)eventName andBody:(NSDictionary *)body {
     [self sendEventWithName: eventName body: body];
}

@end
