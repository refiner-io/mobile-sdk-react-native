const { getDefaultConfig, mergeConfig } = require("@react-native/metro-config");

/**
 * Metro configuration
 * https://facebook.github.io/metro/docs/configuration
 *
 * @type {import('metro-config').MetroConfig}
 */
const config = {
  maxWorkers: 1,
  watchman: false,
  resetCache: true,
  transformer: {
    getTransformOptions: async () => ({
      transform: {
        experimentalImportSupport: false,
        inlineRequires: true,
      },
    }),
  },
  resolver: {
    platforms: ["ios", "android", "native", "web"],
    nodeModulesPaths: [
      __dirname + "/node_modules",
      __dirname + "/../node_modules",
    ],
  },
};

module.exports = mergeConfig(getDefaultConfig(__dirname), config);
