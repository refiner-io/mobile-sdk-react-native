/**
 * Jest setup for the example app.
 *
 * The `react-native` preset does not stand up the native bridge, so any module
 * touching `NativeModules` at import time throws
 * "__fbBatchedBridgeConfig is not set, cannot invoke native modules".
 *
 * `refiner-react-native` resolves its native module at import time (see
 * `index.js`), so provide a fake bridge before anything imports it.
 *
 * React Native reads `global.nativeModuleProxy` first and only falls back to
 * `global.__fbBatchedBridgeConfig` (the invariant above) when it is absent, so
 * populating the proxy is enough to satisfy the real implementation.
 *
 * @format
 */

const noop = () => {};

const RNRefiner = {
  initialize: noop,
  setProject: noop,
  identifyUser: noop,
  resetUser: noop,
  setUser: noop,
  setAnonymousId: noop,
  setLocale: noop,
  trackEvent: noop,
  trackScreen: noop,
  showForm: noop,
  dismissForm: noop,
  closeForm: noop,
  addToResponse: noop,
  startSession: noop,
  enableClient: noop,
  disableClient: noop,
  ping: noop,
  // Required so `new NativeEventEmitter(RNRefinerModule)` is valid.
  addListener: noop,
  removeListeners: noop,
};

global.nativeModuleProxy = {RNRefiner};
