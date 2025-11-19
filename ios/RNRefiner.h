//
//  RNRefiner.h
//  RNRefiner
//
//  Public header for RNRefiner module
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

// Import the spec header for New Architecture support
#ifdef RCT_NEW_ARCH_ENABLED
#import "RefinerReactNativeSpec.h"
#endif

// This header is required for CocoaPods umbrella header
// The actual implementation is in RNRefiner.swift
// and is exposed via the generated RNRefiner-Swift.h header
