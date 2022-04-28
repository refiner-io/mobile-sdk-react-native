
#import "RNRefiner.h"
@import RefinerSDK;

@implementation RNRefiner

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(initialize:(RefinerConfigs *)refinerConfigs)
{
    [[Refiner shared] initializeWithValue:refinerConfigs];
}

RCT_EXPORT_METHOD(identifyUser:(NSString *)userId)
{
    [[Refiner shared] identifyUserWithValue:userId];
}

RCT_EXPORT_METHOD(resetUser:(NSString *)eventName)
{
    [[Refiner shared] resetUser];
}

RCT_EXPORT_METHOD(trackEvent:(NSString *)eventName)
{
    [[Refiner shared] trackEventWithValue:eventName];
}

RCT_EXPORT_METHOD(trackScreen:(NSString *)screenName)
{
    [[Refiner shared] trackScreenWithValue:screenName];
}

RCT_EXPORT_METHOD(showForm:(NSString *)formUuid (BOOL *)force)
{
    [[Refiner shared] showFormWithValue:(formUuid, force)];
}

RCT_EXPORT_METHOD(attachToResponse:(NSDictionary *)contextualData)
{
    [[Refiner shared] attachToResponseWithValue:contextualData];
}

@end
