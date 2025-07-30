import { NativeModules, NativeEventEmitter, Platform } from "react-native";

// Try to import TurboModule if available
let RNRefinerTurboModule;
try {
  // Dynamic import for TurboModule if new architecture is enabled
  if (global.__turboModuleProxy != null) {
    const { TurboModuleRegistry } = require("react-native");
    RNRefinerTurboModule = TurboModuleRegistry.getEnforcing("RNRefiner");
  }
} catch (e) {
  // TurboModule not available, will fall back to legacy bridge
}

// Determine which module to use and set architecture flag
let RNRefinerModule;
let isNewArchitecture = false;

if (RNRefinerTurboModule) {
  RNRefinerModule = RNRefinerTurboModule;
  isNewArchitecture = true;
} else {
  RNRefinerModule = NativeModules.RNRefiner;
  isNewArchitecture = false;
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
    addListener: stubMethod("addListener"),
    removeListeners: stubMethod("removeListeners"),
    attachToResponse: stubMethod("attachToResponse"),
    isNewArchitecture: () => false,
    platform: Platform.OS,
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

    // Platform info
    platform: Platform.OS,
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
