//
//  RNRefiner.m
//  RNRefiner
//
//  Objective-C wrapper for Swift RNRefiner module
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(RNRefiner, RCTEventEmitter)

// Core SDK methods
RCT_EXTERN_METHOD(initialize:(NSString *)projectId withDebugMode:(BOOL)debugMode)
RCT_EXTERN_METHOD(setProject:(NSString *)projectId)
RCT_EXTERN_METHOD(identifyUser:(NSString * _Nullable)userId
                  withUserTraits:(NSDictionary *)userTraits
                  withLocale:(NSString * _Nullable)locale
                  withSignature:(NSString * _Nullable)signature
                  withWriteOperation:(NSString * _Nullable)writeOperation)
RCT_EXTERN_METHOD(setUser:(NSString * _Nullable)userId
                  withUserTraits:(NSDictionary * _Nullable)userTraits
                  withLocale:(NSString * _Nullable)locale
                  withSignature:(NSString * _Nullable)signature)
RCT_EXTERN_METHOD(resetUser)
RCT_EXTERN_METHOD(trackEvent:(NSString *)eventName)
RCT_EXTERN_METHOD(trackScreen:(NSString *)screenName)
RCT_EXTERN_METHOD(ping)
RCT_EXTERN_METHOD(showForm:(NSString *)formUuid withForce:(BOOL)force)
RCT_EXTERN_METHOD(dismissForm:(NSString *)formUuid)
RCT_EXTERN_METHOD(closeForm:(NSString *)formUuid)
RCT_EXTERN_METHOD(addToResponse:(NSDictionary * _Nullable)contextualData)
RCT_EXTERN_METHOD(startSession)
RCT_EXTERN_METHOD(setLocale:(NSString *)locale)
RCT_EXTERN_METHOD(setAnonymousId:(NSString *)anonymousId)

// Architecture detection methods
RCT_EXTERN_METHOD(getArchitectureInfo:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(setArchitectureInfo:(BOOL)isNewArch)
RCT_EXTERN_METHOD(detectArchitecture:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)

// Deprecated method
RCT_EXTERN_METHOD(attachToResponse:(NSDictionary * _Nullable)contextualData)

// Event emitter methods
RCT_EXTERN_METHOD(addListener:(NSString *)eventName)
RCT_EXTERN_METHOD(removeListeners:(NSInteger)count)

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

@end 