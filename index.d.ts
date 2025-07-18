import { NativeModule } from "react-native";

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
  ) => Promise<void>;

  /**
   * Set user data without signature verification
   */
  setUser: (
    userId: string,
    userTraits: Record<string, unknown>,
    locale: string | null,
    signature: string | null
  ) => Promise<void>;

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
}

declare module "react-native" {
  interface NativeModulesStatic {
    RNRefiner: RefinerSDKInterface;
  }
}
