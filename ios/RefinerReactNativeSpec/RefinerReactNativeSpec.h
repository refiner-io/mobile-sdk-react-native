//
//  RefinerReactNativeSpec.h
//  refiner-react-native
//
//  Created by Codegen for New Architecture support
//

#ifdef RCT_NEW_ARCH_ENABLED

#import <React/RCTBridgeModule.h>
#import <React/RCTTurboModule.h>

@protocol NativeRNRefinerSpec <RCTBridgeModule, RCTTurboModule>

- (void)initialize:(NSString *)projectId debugMode:(BOOL)debugMode;
- (void)setProject:(NSString *)projectId;
- (void)identifyUser:(NSString *)userId
          userTraits:(NSDictionary *)userTraits
              locale:(NSString * _Nullable)locale
           signature:(NSString * _Nullable)signature
      writeOperation:(NSString * _Nullable)writeOperation;
- (void)setUser:(NSString *)userId
     userTraits:(NSDictionary * _Nullable)userTraits
         locale:(NSString * _Nullable)locale
      signature:(NSString * _Nullable)signature;
- (void)resetUser;
- (void)trackEvent:(NSString *)eventName;
- (void)trackScreen:(NSString *)screenName;
- (void)ping;
- (void)showForm:(NSString *)formUuid force:(BOOL)force;
- (void)dismissForm:(NSString *)formUuid;
- (void)closeForm:(NSString *)formUuid;
- (void)addToResponse:(NSDictionary * _Nullable)contextualData;
- (void)startSession;
- (void)addListener:(NSString *)eventName;
- (void)removeListeners:(double)count;

// Architecture detection methods
- (void)getArchitectureInfo:(RCTPromiseResolveBlock)resolve
                   rejecter:(RCTPromiseRejectBlock)reject;
- (void)setArchitectureInfo:(BOOL)isNewArch;
- (void)detectArchitecture:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject;

@end

#endif // RCT_NEW_ARCH_ENABLED 