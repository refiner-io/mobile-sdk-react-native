
import { NativeModules,NativeEventEmitter } from 'react-native';

export const RNRefiner = NativeModules.RNRefiner;

export const RNRefinerEventEmitter = new NativeEventEmitter(RNRefiner);