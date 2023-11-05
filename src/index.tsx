import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'beek' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const AlterNativeModule = new Proxy(
  {},
  {
    get() {
      throw new Error(LINKING_ERROR);
    },
  }
);

const BeekBarcodeScanner =
  NativeModules.BeekBarcodeScanner ?? AlterNativeModule;

export const openScanner = () => {
  BeekBarcodeScanner.openScanner();
};
