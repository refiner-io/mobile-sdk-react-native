
#import "RNRefiner.h"
#import <RefinerSDK/RefinerSDK-Swift.h>
@import RefinerSDK;

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
static NSString *const kRefinerFormElement      = @"formElement";
static NSString *const kRefinerProgress         = @"progress";
static NSString *const kRefinerFormData         = @"formData";

@implementation RNRefiner

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

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

RCT_EXPORT_METHOD(initialize:(NSString *)projectId withEnableDebugMode:(BOOL *)enableDebugMode)
{
    [[Refiner instance] initializeWithProjectId: projectId enableDebugMode: enableDebugMode];
    [self registerCallbacks];
}

RCT_EXPORT_METHOD(identifyUser:(NSString *)userId withUserTraits:(NSDictionary *)userTraits withLocale:(NSString *)locale withSignature:(NSString *)signature)
{
    [[Refiner instance] identifyUserWithUserId: userId userTraits: userTraits locale: locale signature: signature error: nil];
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

- (void) registerCallbacks {
    [[Refiner instance] setOnBeforeShow:^(NSString * formId, id formConfig) {
        [self emitEventInternal:kRefinerOnBeforeShow andBody: @{kRefinerFormId: formId,
                                                                kRefinerFormConfig: formConfig}];
    }];

    [[Refiner instance] setOnNavigation:^(NSString * formId, id formElement, id progress) {
        [self emitEventInternal:kRefinerOnNavigation andBody: @{kRefinerFormId: formId,
                                                                kRefinerFormElement: formElement,
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

- (void)emitEventInternal:(NSString *)eventName andBody:(NSDictionary *)body {
     [self sendEventWithName: eventName body: body];
}

@end
