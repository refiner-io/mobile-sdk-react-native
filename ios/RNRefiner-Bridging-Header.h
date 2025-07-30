//
//  RNRefiner-Bridging-Header.h
//  RNRefiner
//
//  Bridging header for RNRefiner Swift module
//

#ifndef RNRefiner_Bridging_Header_h
#define RNRefiner_Bridging_Header_h

// Import React Native headers
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#if __has_include("RCTEventEmitter.h")
#import "RCTEventEmitter.h"
#else
#import <React/RCTEventEmitter.h>
#endif

// New Architecture support
#ifdef RCT_NEW_ARCH_ENABLED
#if __has_include("RefinerReactNativeSpec/RefinerReactNativeSpec.h")
#import "RefinerReactNativeSpec/RefinerReactNativeSpec.h"
#endif
#endif

#endif /* RNRefiner_Bridging_Header_h */ 