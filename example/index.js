/**
 * @format
 */

import {AppRegistry} from 'react-native';
import {NativeModules} from 'react-native';
import App from './App';
import {name as appName} from './app.json';

// Safely initialize Refiner SDK at app startup
try {
  const {RNRefiner} = NativeModules;

  if (RNRefiner) {
    // Initialize Refiner SDK
    RNRefiner.initialize('56421950-5d32-11ea-9bb4-9f1f1a987a49', true);
  }
} catch (error) {
  // Handle initialization error silently
}

AppRegistry.registerComponent(appName, () => App);
