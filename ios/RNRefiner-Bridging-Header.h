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

#import "React/RCTEventEmitter.h"

#endif /* RNRefiner_Bridging_Header_h */ 