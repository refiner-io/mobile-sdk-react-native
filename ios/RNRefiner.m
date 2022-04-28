
#import "RNRefiner.h"
@import RefinerSDK;

@implementation RNRefiner

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(initialize:(NSString *)projectId)
{
    [[Refiner shared] initialize:RefinerConfigs(projectId)];
}

RCT_EXPORT_METHOD(identifyUser:(NSString *)userId (NSDictionary *) userTraits (NSString *)locale)
{
    [[Refiner shared] identifyUser:userId userTraits:userTraits locale:locale];
}

RCT_EXPORT_METHOD(resetUser)
{
    [[Refiner shared] resetUser];
}

RCT_EXPORT_METHOD(trackEvent:(NSString *)eventName)
{
    [[Refiner shared] trackEvent:eventName];
}

RCT_EXPORT_METHOD(trackScreen:(NSString *)screenName)
{
    [[Refiner shared] trackScreen:screenName];
}

RCT_EXPORT_METHOD(showForm:(NSString *)formUuid (BOOL *)force)
{
    [[Refiner shared] showForm:formUuid force];
}

RCT_EXPORT_METHOD(attachToResponse:(NSDictionary *)contextualData)
{
    [[Refiner shared] attachToResponse:contextualData];
}

@end
