
#import "RNRefiner.h"
#import <RefinerSDK/RefinerSDK-Swift.h>

@implementation RNRefiner

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(initialize:(NSString *)projectId)
{
    [[Refiner instance] initializeWithProjectId: projectId];
    // [[RNRefinerEventEmitter sharedInstance] registerEvents];
}

RCT_EXPORT_METHOD(identifyUser:(NSString *)userId withUserTraits:(NSDictionary *)userTraits withLocale:(NSString *)locale)
{
    [[Refiner instance] identifyUserWithUserId: userId userTraits: userTraits locale: locale error: nil];
}

RCT_EXPORT_METHOD(resetUser)
{
    [[Refiner instance] resetUser];
}

RCT_EXPORT_METHOD(trackEvent:(NSString *)eventName)
{
    [[Refiner instance] trackEventWithName: eventName];
}

RCT_EXPORT_METHOD(trackScreen:(NSString *)screenName)
{
    [[Refiner instance] trackScreenWithName: screenName];
}

RCT_EXPORT_METHOD(showForm:(NSString *)formUuid withForce:(BOOL *)force)
{
    [[Refiner instance] showFormWithUuid: formUuid force: force];
}

RCT_EXPORT_METHOD(attachToResponse:(NSDictionary *)contextualData)
{
    [[Refiner instance] attachToResponseWithData: contextualData];
}

@end


@implementation RNRefinerEventEmitter

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

- (void) registerEvents {
    [[Refiner instance] setOnBeforeShow:^(NSString * formId, id formConfig) {
        [self emitEventInternal:kRefinerOnBeforeShow andBody: @{kRefinerFormId: formId,
                                                                kRefinerFormConfig: formConfig}];
    }];
    
    [[Refiner instance] setOnNavigation:^(NSString * formId, id formConfig, id progress) {
        [self emitEventInternal:kRefinerOnNavigation andBody: @{kRefinerFormId: formId,
                                                                kRefinerFormConfig: formConfig,
                                                                kRefinerProgress: progress}];
    }];
    
    [[Refiner instance] setOnShow:^(NSString * formId) {
        [self emitEventInternal:kRefinerOnShow andBody: @{kRefinerFormId: formId}];
    }];
    
    [[Refiner instance] setOnClose:^(NSString * formId) {
        [self emitEventInternal:kRefinerOnClose andBody: @{kRefinerFormId: formId}];
    }];
    
    [[Refiner instance] setOnDismiss:^(NSString * formId) {
        [self emitEventInternal:kRefinerOnDismiss andBody: @{kRefinerFormId: formId}];
    }];
    
    [[Refiner instance] setOnComplete:^(NSString * formId, id formData) {
        [self emitEventInternal:kRefinerOnComplete andBody:  @{kRefinerFormId: formId,
                                                               kRefinerFormData: formData}];
    }];
}

#pragma mark - Private
- (void)emitEventInternal:(NSString *)eventName andBody:(NSDictionary *)body {
    // [self sendEventWithName: eventName body: body];
          [self sendEventWithName:@"deneme" body:@"scrollToTopHomeFeed"];
}

@end