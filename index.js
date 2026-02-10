import { NativeModules, NativeEventEmitter, Platform } from "react-native";

// Try to import TurboModule if available
let RNRefinerTurboModule;
let turboModuleAvailable = false;

try {
  const { TurboModuleRegistry, NativeModules } = require("react-native");

  console.log("Refiner: Available NativeModules:", Object.keys(NativeModules));
  console.log("Refiner: TurboModuleRegistry available:", !!TurboModuleRegistry);

  // First try to get the TurboModule
  try {
    RNRefinerTurboModule = TurboModuleRegistry.getEnforcing("RNRefiner");
    turboModuleAvailable = true;
    console.log(
      "Refiner: TurboModule loaded successfully via TurboModuleRegistry"
    );
  } catch (turboError) {
    console.log(
      "Refiner: TurboModule not available via TurboModuleRegistry:",
      turboError.message
    );

    // If TurboModuleRegistry fails, try getting it from NativeModules
    if (NativeModules.RNRefiner) {
      RNRefinerTurboModule = NativeModules.RNRefiner;
      turboModuleAvailable = true;
      console.log(
        "Refiner: Module loaded successfully via NativeModules.RNRefiner"
      );
      console.log(
        "Refiner: This is likely the legacy module, not the TurboModule"
      );
    } else {
      console.log("Refiner: Module not found in NativeModules either");
    }
  }

  if (RNRefinerTurboModule) {
    console.log("Refiner: Module methods:", Object.keys(RNRefinerTurboModule));
  }
} catch (e) {
  console.log("Refiner: Error loading module:", e.message);
  // Module not available, will fall back to legacy bridge
}

// Determine which module to use and set architecture flag
let RNRefinerModule;
let isNewArchitecture = false;

// In New Architecture with bridgeless mode, prioritize legacy module since TurboModules
// from local dependencies may not be properly autolinked
if (NativeModules.RNRefiner) {
  RNRefinerModule = NativeModules.RNRefiner;
  isNewArchitecture = false;
  console.log("Refiner: Using legacy module from NativeModules");
} else if (turboModuleAvailable && RNRefinerTurboModule) {
  RNRefinerModule = RNRefinerTurboModule;
  isNewArchitecture = true;
  console.log("Refiner: Using TurboModule (New Architecture)");
} else {
  // If neither TurboModule nor legacy module is available, try to access it through TurboModuleRegistry
  console.log(
    "Refiner: Neither TurboModule nor legacy module found, attempting fallback"
  );
  try {
    const { TurboModuleRegistry } = require("react-native");
    // Try without getEnforcing to avoid exceptions
    RNRefinerModule = TurboModuleRegistry.get("RNRefiner");
    if (RNRefinerModule) {
      isNewArchitecture = true;
      console.log("Refiner: Found module via TurboModuleRegistry.get()");
    } else {
      console.log(
        "Refiner: Module not found via TurboModuleRegistry.get() either"
      );
      RNRefinerModule = null;
    }
  } catch (e) {
    console.log("Refiner: Error accessing TurboModuleRegistry:", e.message);
    RNRefinerModule = null;
  }
}

// Create a stub module for when native module is not available
const createStubModule = () => {
  const stubMethod =
    (methodName) =>
    (...args) => {
      // Stub method - no logging needed
    };

  return {
    initialize: stubMethod("initialize"),
    setProject: stubMethod("setProject"),
    identifyUser: stubMethod("identifyUser"),
    setUser: stubMethod("setUser"),
    resetUser: stubMethod("resetUser"),
    trackEvent: stubMethod("trackEvent"),
    trackScreen: stubMethod("trackScreen"),
    ping: stubMethod("ping"),
    showForm: stubMethod("showForm"),
    dismissForm: stubMethod("dismissForm"),
    closeForm: stubMethod("closeForm"),
    addToResponse: stubMethod("addToResponse"),
    startSession: stubMethod("startSession"),
    setLocale: stubMethod("setLocale"),
    setAnonymousId: stubMethod("setAnonymousId"),
    addListener: stubMethod("addListener"),
    removeListeners: stubMethod("removeListeners"),
    attachToResponse: stubMethod("attachToResponse"),
    isNewArchitecture: () => false,
    get platform() { return Platform.OS; },
  };
};

// Create wrapper that works with both architectures
const createRNRefinerWrapper = (nativeModule) => {
  if (!nativeModule) {
    return createStubModule();
  }

  // Pass architecture information to native module
  if (nativeModule.setArchitectureInfo) {
    nativeModule.setArchitectureInfo(isNewArchitecture);
  }

  // Additional runtime detection if available (works for both Android and iOS)
  if (nativeModule.detectArchitecture) {
    nativeModule
      .detectArchitecture()
      .then((detectedArch) => {
        // Architecture detection completed
      })
      .catch(() => {
        // Ignore detection errors
      });
  }

  return {
    // Core SDK methods
    initialize: (projectId, debugMode) => {
      return nativeModule.initialize(projectId, debugMode);
    },
    setProject: (projectId) => nativeModule.setProject(projectId),
    identifyUser: (userId, userTraits, locale, signature, writeOperation) => {
      // Always pass an object for userTraits
      const safeTraits = userTraits || {};

      try {
        if (isNewArchitecture) {
          // TurboModule expects non-nullable userTraits
          return nativeModule.identifyUser(
            userId,
            safeTraits,
            locale,
            signature,
            writeOperation
          );
        } else {
          // Legacy module can handle nullable userTraits
          return nativeModule.identifyUser(
            userId,
            safeTraits,
            locale,
            signature,
            writeOperation
          );
        }
      } catch (error) {
        throw error;
      }
    },
    setUser: (userId, userTraits, locale, signature) => {
      // Handle the difference between TurboModule (non-nullable) and legacy module (nullable)
      if (isNewArchitecture) {
        // TurboModule expects non-nullable userTraits, so we need to provide an empty object if null
        const traits = userTraits || {};
        return nativeModule.setUser(userId, traits, locale, signature);
      } else {
        // Legacy module can handle nullable userTraits
        return nativeModule.setUser(
          userId,
          userTraits || null,
          locale,
          signature
        );
      }
    },
    resetUser: () => nativeModule.resetUser(),
    trackEvent: (eventName) => nativeModule.trackEvent(eventName),
    trackScreen: (screenName) => nativeModule.trackScreen(screenName),
    ping: () => nativeModule.ping(),
    showForm: (formUuid, force) => nativeModule.showForm(formUuid, force),
    dismissForm: (formUuid) => nativeModule.dismissForm(formUuid),
    closeForm: (formUuid) => nativeModule.closeForm(formUuid),
    addToResponse: (contextualData) => {
      // Handle the difference between TurboModule (non-nullable) and legacy module (nullable)
      if (isNewArchitecture) {
        // TurboModule expects non-nullable contextualData, so we need to provide an empty object if null
        const data = contextualData || {};
        return nativeModule.addToResponse(data);
      } else {
        // Legacy module can handle nullable contextualData
        return nativeModule.addToResponse(contextualData || null);
      }
    },
    startSession: () => nativeModule.startSession(),
    setLocale: (locale) => nativeModule.setLocale(locale),
    setAnonymousId: (anonymousId) => nativeModule.setAnonymousId(anonymousId),

    // Event emitter methods (required for both architectures)
    addListener: (eventName) => nativeModule.addListener(eventName),
    removeListeners: (count) => nativeModule.removeListeners(count),

    // Deprecated method for backward compatibility
    attachToResponse: (contextualData) => {
      // Handle the difference between TurboModule (non-nullable) and legacy module (nullable)
      if (isNewArchitecture) {
        // TurboModule expects non-nullable contextualData, so we need to provide an empty object if null
        const data = contextualData || {};
        return nativeModule.addToResponse(data);
      } else {
        // Legacy module can handle nullable contextualData
        return nativeModule.addToResponse(contextualData || null);
      }
    },

    // Architecture detection helper
    isNewArchitecture: () => isNewArchitecture,

    // Platform info (use getter to defer Platform.OS access)
    get platform() { return Platform.OS; },
  };
};

// Export the wrapped module
export const RNRefiner = createRNRefinerWrapper(RNRefinerModule);

// Create event emitter that works with both architectures - with fallback for when module is unavailable
let RNRefinerEventEmitter;
try {
  if (RNRefinerModule) {
    RNRefinerEventEmitter = new NativeEventEmitter(RNRefinerModule);
  } else {
    // Create a stub event emitter when native module is not available
    // Use a simple object with event emitter methods instead of Node.js events
    RNRefinerEventEmitter = {
      addListener: (eventName, callback) => {
        return {
          remove: () => {
            // Stub remove method
          },
        };
      },
      removeAllListeners: (eventName) => {
        // Stub removeAllListeners method
      },
    };
  }
} catch (error) {
  // Fallback to a basic stub implementation
  RNRefinerEventEmitter = {
    addListener: (eventName, callback) => {
      return {
        remove: () => {
          // Stub remove method
        },
      };
    },
    removeAllListeners: (eventName) => {
      // Stub removeAllListeners method
    },
  };
}

export { RNRefinerEventEmitter };

// Legacy export for backward compatibility
export default RNRefiner;
