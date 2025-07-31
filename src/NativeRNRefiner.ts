import type { TurboModule } from "react-native";
import { TurboModuleRegistry } from "react-native";

export interface Spec extends TurboModule {
  /**
   * Initialize the Refiner SDK
   */
  initialize(projectId: string, debugMode: boolean): void;

  /**
   * Set the project ID
   */
  setProject(projectId: string): void;

  /**
   * Identify a user with traits and optional signature verification
   */
  identifyUser(
    userId: string,
    userTraits: Object, // made required
    locale?: string,
    signature?: string,
    writeOperation?: string
  ): void;

  /**
   * Set user data without signature verification
   */
  setUser(
    userId: string,
    userTraits?: Object | null, // made optional and nullable
    locale?: string,
    signature?: string
  ): void;

  /**
   * Reset the current user
   */
  resetUser(): void;

  /**
   * Track a custom event
   */
  trackEvent(eventName: string): void;

  /**
   * Track a screen view
   */
  trackScreen(screenName: string): void;

  /**
   * Ping the Refiner service
   */
  ping(): void;

  /**
   * Show a form by UUID
   */
  showForm(formUuid: string, force: boolean): void;

  /**
   * Dismiss a form by UUID
   */
  dismissForm(formUuid: string): void;

  /**
   * Close a form by UUID
   */
  closeForm(formUuid: string): void;

  /**
   * Add contextual data to the current response
   */
  addToResponse(contextualData?: Object | null): void; // made nullable

  /**
   * Start a new session
   */
  startSession(): void;

  /**
   * Required for RN built in Event Emitter Calls
   */
  addListener(eventName: string): void;

  /**
   * Required for RN built in Event Emitter Calls
   */
  removeListeners(count: number): void;

  /**
   * Architecture detection methods
   */
  getArchitectureInfo(): Promise<boolean>;
  setArchitectureInfo(isNewArch: boolean): void;
  detectArchitecture(): Promise<boolean>;
}

export default TurboModuleRegistry.getEnforcing<Spec>("RNRefiner");
