
# react-native-refiner

## Getting started

`$ npm install react-native-refiner --save`

### Mostly automatic installation

`$ react-native link react-native-refiner`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-refiner` and add `RNRefiner.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNRefiner.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import io.refiner.RNRefinerPackage;` to the imports at the top of the file
  - Add `new RNRefinerPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-refiner'
  	project(':react-native-refiner').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-refiner/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      implementation project(':react-native-refiner')
  	```


## Usage
```javascript
import RNRefiner from 'react-native-refiner';

//TODO: Update

RNRefiner.initialize(new RefinerConfigs("PROJECT_ID"));
RNRefiner.identifyUser("USER_ID", new LinkedHashMap<>(),"LOCALE");
RNRefiner.resetUser();
RNRefiner.trackEvent("EVENT_NAME");
RNRefiner.trackScreen("SCREEN_NAME");
RNRefiner.showForm("FORM_UUID", true);
RNRefiner.attachToResponse(new HashMap<>());
```
