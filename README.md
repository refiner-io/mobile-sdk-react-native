# Refiner Mobile SDK integration

## React Native

![npm](https://img.shields.io/npm/v/refiner-react-native)


### 1) Installation

`$ npm install refiner-react-native --save`

#### Android

- Add the configuration below in your app/build.gradle file.

```kotlin
android {
    buildFeatures {
        dataBinding = true
    }
}
```

#### iOS

- Run command `pod install` in your ios directory


### 2) Usage

Visit our [documentation](https://refiner.io/docs/kb/mobile-sdk/mobile-sdk-reference/) for more information about how to use the SDK methods.

#### Initialization & Configuration

Initialize the SDK in your application with the needed configuration parameters.

```javascript
import { NativeModules, NativeEventEmitter } from 'react-native';

export const RNRefiner = NativeModules.RNRefiner;
export const RNRefinerEventEmitter = new NativeEventEmitter(RNRefiner);

RNRefiner.initialize("PROJECT_ID");
```

#### Identify User

Call `Identify User` to create or update user traits in Refiner.

```javascript
var userTraits = { email: "hello@hello.com", a_number: 123, a_date: "2022-16-04 12:00:00" };
RNRefiner.identifyUser("USER_ID", userTraits, "LOCALE");
```

#### Track Event

`Track Event` lets you track user events. Tracked events can be used to create user segments and target audiences in Refiner.

```javascript
RNRefiner.trackEvent("EVENT_NAME");
```

#### Track Screen

`Track Screen` provides to track screen that user is currently on. Screen information can be used to launch surveys in specific areas of your app.

```javascript
RNRefiner.trackScreen("SCREEN_NAME");
```

#### Show Form

If you use the Manual Trigger Event for your survey, you need to call `Show Form` whenever you want to launch the survey.

```javascript
RNRefiner.showForm("FORM_UUID", false);
```

The second parameter is a boolean value to `force` the display of the survey and bypass all targeting rules which were set in the Refiner dashboard. Setting the parameter to `true` can be helpful when testing the SDK. In production, the parameter should be set to `false`.

```javascript
RNRefiner.showForm("FORM_UUID", true);
```

#### Attach Contextual Data

Attach contextual data to the survey submissions with `attachToResponse`. Set `null` to remove the contextual data. 

```javascript
var contextualData = { some_data: "hello", some_more_data: "hello again" };
RNRefiner.attachToResponse(contextualData);
```

#### Reset User

Call `Reset User` to reset the user identifier previously set through `Identify User`. We recommend calling this method when the user logs out from your app.

```javascript
RNRefiner.resetUser();
```

#### Register callback functions

Registering callback functions allows you to execute any code at specific moments in the lifecycle of a survey.
A popular use-case for callback functions is to redirect a user to a new screen once they completed a survey.

`onBeforeShow` gets called right before a survey is supposed to be shown.

```javascript
  RNRefinerEventEmitter.addListener('onBeforeShow', (event) => {
    console.log('onBeforeShow');
    console.log(event.formId);
    console.log(event.formConfig);
  });     
```

`onNavigation` gets called when the user moves through the survey

```javascript
  RNRefinerEventEmitter.addListener('onNavigation', (event) => {
    console.log('onNavigation');
    console.log(event.formId);
    console.log(event.formElement);
    console.log(event.progress);
  });    
```

`onShow` gets called when a survey widget becomes visible to your user.

```javascript
  RNRefinerEventEmitter.addListener('onShow', (event) => {
    console.log('onShow');
    console.log(event.formId);
  });   
```

`onClose` gets called when the survey widgets disappears from the screen.

```javascript
  RNRefinerEventEmitter.addListener('onClose', (event) => {
    console.log('onClose');
    console.log(event.formId);
  });    
```

`onDismiss` gets called when the user dismissed a survey by clicking on the “x” in the top right corner.

```javascript
  RNRefinerEventEmitter.addListener('onDismiss', (event) => {
    console.log('onDismiss');
    console.log(event.formId);
  });    
```

`onComplete` gets called when the user completed (submitted) a survey.

```javascript
  RNRefinerEventEmitter.addListener('onComplete', (event) => {
    console.log('onComplete');
    console.log(event.formId);
    console.log(event.formData);
  });   
```     
