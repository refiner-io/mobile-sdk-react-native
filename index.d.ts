import { NativeModule, NativeEventEmitter } from "react-native";

export interface RefinerEvents {
  onBeforeShow: {
    formId: string;
    formConfig: string;
  };
  onShow: {
    formId: string;
  };
  onClose: {
    formId: string;
  };
  onDismiss: {
    formId: string;
  };
  onComplete: {
    formId: string;
    formData: string;
  };
  onNavigation: {
    formId: string;
    formElement: string;
    progress: string;
  };
  onError: {
    message: string;
  };
}

export interface RefinerSDKInterface extends NativeModule {
  /**
   * Add contextual data to the current response
   */
  addToResponse: (response: Record<string, unknown> | null) => void;

  /**
   * Identify a user with traits and optional signature verification
   */
  identifyUser: (
    userId: string,
    userTraits: Record<string, unknown>,
    locale: string | null,
    signature: string | null,
    writeOperation: string | null
  ) => void;

  /**
   * Set user data without signature verification
   */
  setUser: (
    userId: string,
    userTraits: Record<string, unknown>,
    locale: string | null,
    signature: string | null
  ) => void;

  /**
   * Initialize the Refiner SDK
   */
  initialize: (projectId: string, debugMode: boolean) => void;

  /**
   * Reset the current user
   */
  resetUser: () => void;

  /**
   * Set the project ID
   */
  setProject: (projectId: string | null) => void;

  /**
   * Track a custom event
   */
  trackEvent: (eventName: string) => void;

  /**
   * Track a screen view
   */
  trackScreen: (screenName: string) => void;

  /**
   * Ping the Refiner service
   */
  ping: () => void;

  /**
   * Show a form by UUID
   */
  showForm: (formUuid: string, force: boolean) => void;

  /**
   * Dismiss a form by UUID
   */
  dismissForm: (formUuid: string) => void;

  /**
   * Close a form by UUID
   */
  closeForm: (formUuid: string) => void;

  /**
   * Start a new session
   */
  startSession: () => void;

  /**
   * @deprecated Use addToResponse instead
   */
  attachToResponse: (response: Record<string, unknown> | null) => void;

  /**
   * Required for RN built in Event Emitter Calls
   */
  addListener: (eventName: string) => void;

  /**
   * Required for RN built in Event Emitter Calls
   */
  removeListeners: (count: number) => void;

  /**
   * Check if the New Architecture is being used
   */
  isNewArchitecture: () => boolean;

  /**
   * Get the current platform
   */
  platform: string;

  /**
   * Set architecture information from JavaScript
   */
  setArchitectureInfo?: (isNewArch: boolean) => void;

  /**
   * Get architecture information from native module
   */
  getArchitectureInfo?: () => Promise<boolean>;

  /**
   * Detect architecture at runtime
   */
  detectArchitecture?: () => Promise<boolean>;
}

// iOS-specific interface (extends the main interface)
export interface RNRefinerIOSInterface extends RefinerSDKInterface {
  // iOS has the same methods as Android
  // The architecture detection methods work the same way
}

/**
 * Main Refiner SDK interface
 */
export declare const RNRefiner: RefinerSDKInterface;

/**
 * Event emitter for Refiner SDK events
 */
export declare const RNRefinerEventEmitter: NativeEventEmitter;

/**
 * Default export for backward compatibility
 */
declare const _default: RefinerSDKInterface;
export default _default;

/**
 * TurboModule spec for New Architecture
 */
export interface NativeRNRefinerSpec {
  initialize(projectId: string, debugMode: boolean): void;
  setProject(projectId: string): void;
  identifyUser(
    userId: string,
    userTraits: Record<string, unknown>,
    locale?: string,
    signature?: string,
    writeOperation?: string
  ): void;
  setUser(
    userId: string,
    userTraits: Record<string, unknown>,
    locale?: string,
    signature?: string
  ): void;
  resetUser(): void;
  trackEvent(eventName: string): void;
  trackScreen(screenName: string): void;
  ping(): void;
  showForm(formUuid: string, force: boolean): void;
  dismissForm(formUuid: string): void;
  closeForm(formUuid: string): void;
  addToResponse(contextualData: Record<string, unknown>): void;
  startSession(): void;
  addListener(eventName: string): void;
  removeListeners(count: number): void;
}

declare module "react-native" {
  interface NativeModulesStatic {
    RNRefiner: RefinerSDKInterface;
  }
}
