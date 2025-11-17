# Refiner React Native SDK

![npm](https://img.shields.io/npm/v/refiner-react-native)

This repository hosts the official Refiner React Native SDK. Installing this package allows you to track user data in Refiner and launch in-app surveys within your React Native app.

Refiner is a user feedback survey tool designed specifically to launch [in-app surveys](https://refiner.io/features/in-app-surveys/) in web and mobile applications. Get spot-on insights from your users with perfectly timed microsurveys.

With Refiner you can ask your users any question while they are using your react-native app. Measure [customer satisfaction (CSAT)](https://refiner.io/solutions/csat/), [Net Promoter Score (NPS)](https://refiner.io/solutions/nps/), or [customer effort score (CES)](https://refiner.io/solutions/ces/), research what to built next or profile your users. Refiner supports all survey use cases and comes packed with expert-built templates that will get you started quickly.

Refiner integrates into your existing marketing & sales stacks seamlessly. Our integrations allow you to sync survey responses to the tools you already use in real time, such as your CRM, email marketing automation platform, your backend API or data warehouse.  

Refiner helps you to understand who your users really are, what they need and how you can help them achieve their goals. Get started for free today and increase conversion & retention rates with better customer data.


## 1) Installation

`$ npm install refiner-react-native --save`


### iOS

- Run command `pod install` in your ios directory


## React Native Architecture

This SDK supports both React Native's **New Architecture** and **Legacy Architecture**.

### New Architecture (Default)

Starting with version 1.7.5, the SDK **defaults to React Native's New Architecture**, aligning with React Native 0.82+ where New Architecture is mandatory.

If you're using React Native 0.82 or later, no additional configuration is needed. The SDK will automatically use the New Architecture.

### Legacy Architecture

If you're using an older version of React Native (pre-0.82) and need Legacy Architecture support, you can explicitly enable it:

**For iOS**, create or update `ios/.xcode.env.local` file:

```bash
export RCT_NEW_ARCH_ENABLED=0
```

Then run:

```bash
cd ios && pod install
```

**For Android**, update `android/gradle.properties`:

```properties
newArchEnabled=false
```

### Verifying Your Architecture

You can verify which architecture is being used by checking the build logs:

- **iOS**: Look for `RCT_NEW_ARCH_ENABLED=1` in Xcode build settings
- **Android**: Check `newArchEnabled` in gradle.properties

For more information about React Native's New Architecture, visit the [official React Native documentation](https://reactnative.dev/docs/new-architecture-intro).


## 2) Usage

Visit our [documentation](https://refiner.io/docs/kb/mobile-sdk/mobile-sdk-reference/) for more information about how to use the SDK methods.

### Initialization & Configuration

Initialize the SDK in your application with the needed configuration parameters. 

The second parameter is for activating a debug mode during development. If activated, the SDK will log all interactions with the Refiner backend servers. 

```javascript
import RNRefiner from 'refiner-react-native';
import {NativeEventEmitter} from 'react-native';

export const RNRefinerEventEmitter = new NativeEventEmitter(RNRefiner);

RNRefiner.initialize("PROJECT_ID", false);
```

### Identify User

Call `Identify User` to create or update user traits in Refiner. 

The first parameter is the userId of your logged-in user and is the only mandatory parameter. 

The second parameter is an object of user traits. You can provide an empty object if you don't want to send any user traits to your Refiner account.

```javascript
var userTraits = { email: "hello@hello.com", a_number: 123, a_date: "2022-16-04 12:00:00" };
RNRefiner.identifyUser("USER_ID", userTraits, null, null, null);
```

#### Advanced parameters

The third parameter is for setting the `locale` of a user and is optional. The expected format is a two letter [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) language code. When provided, the locale code is used for launching surveys for specific languages, as well as launching translated sureys. You can set the value to `null` if you are not using any language specific features.

The fourth parameter is an optional [Identity Verification](https://refiner.io/docs/kb/settings/identity-verification/) signature. We recommend to use a Identify Verification signature for increased security in a production environment. For development purposes, you can set this value to `null`.

The fifth parameter allows you to change the data storage mode for userTraits from the default "append" mode to "replace". By default, traits are appended to the existing user record—this means previously stored data will persist even if it's not included in the current payload. When set to "replace", only the traits provided in the current payload are kept. Any previously stored traits that are not included will be removed from the user object in Refiner.

```javascript
var userTraits = { email: "hello@hello.com", a_number: 123, a_date: "2022-16-04 12:00:00" };
RNRefiner.identifyUser("USER_ID", userTraits, "LOCALE", "SIGNATURE", "append");
```

### Set User

The `Set User` method acts as an alternative to the `Identify User` method described above. 

In contrast to the `Identify User` method, the `Set User` method does not immediately create a user object in your Refiner account. The provided user Id and traits are kept locally in your app and no data is communicated to our servers at first. Only when the user performs a meaningful action in your app (e.g. `Track Event` or `Track Screen` is executed) will a user object be created in Refiner. Provided user traits will be attached to the user object when a survey is shown.

The purpose of this alternative method is provide a way to identify users locally when the SDK is initialised but keep the number of tracked users in your Refiner account to a minimum.

```javascript
var userTraits = { email: "hello@hello.com", a_number: 123, a_date: "2022-16-04 12:00:00" };
RNRefiner.setUser("USER_ID", userTraits, "LOCALE", "SIGNATURE");
```

### Track Event

`Track Event` lets you track user events. Tracked events can be used to create user segments and target audiences in Refiner.

```javascript
RNRefiner.trackEvent("EVENT_NAME");
```

### Track Screen

`Track Screen` lets you to track screen that user is currently on. Screen information can be used to launch surveys in specific areas of your app.

We recommend to track screens on which you might want to show a survey one day. There is no need to systematically track all screens of your app.

```javascript
RNRefiner.trackScreen("SCREEN_NAME");
```

### Ping

Depending on your setup, you might want to initiate regular checks for surveys that are scheduled for the current user. For example when you are using time based trigger events, or when a target audience is based on user data received by our backend API. 

The `Ping` method provides an easy way to perform such checks. You can call the `Ping` method at key moments in a user's journey, such as when the app is re-opened, or when the user performs a specific action.

```javascript
RNRefiner.ping();
```

### Show Form

If you use the Manual Trigger Event for your survey, you need to call `Show Form` whenever you want to launch the survey.

```javascript
RNRefiner.showForm("FORM_UUID", false);
```

The second parameter is a boolean value to `force` the display of the survey and bypass all targeting rules which were set in the Refiner dashboard. Setting the parameter to `true` can be helpful when testing the SDK. In production, the parameter should be set to `false`.

```javascript
RNRefiner.showForm("FORM_UUID", true);
```

### Attach Contextual Data

Attach contextual data to the survey submissions with `addToResponse`. Set `null` to remove the contextual data. 

```javascript
var contextualData = { some_data: "hello", some_more_data: "hello again" };
RNRefiner.addToResponse(contextualData);
```

### Start user session

A new user session is automatically detected when a user returns to your application after at least one hour of inactivity. You can choose to manually start a new user session with the method shown below. You can call this method for example right after a user opens your app.

```javascript
RNRefiner.startSession();
```

### Reset User

Call `Reset User` to reset the user identifier previously set through `Identify User`. We recommend calling this method when the user logs out from your app.

```javascript
RNRefiner.resetUser();
```

### Set Project

Change the environment UUID during runtime, after the SDK has been initialised.

```javascript
Refiner.setProject("PROJECT_ID");
```

### Close Surveys

Close a survey programmatically without sending any information to the backend API with the `closeForm` method.

```javascript
Refiner.closeForm("FORM_UUID");
```

Close a survey programmatically and send a "dismissed at" timestamp to the backend server with the `dismissForm` method.

```javascript
Refiner.dismissForm("FORM_UUID");
```

### Register callback functions

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

`onError` gets called when an error occurred.

```javascript
  RNRefinerEventEmitter.addListener('onError', (event) => {
    console.log('onError');
    console.log(event.meesage);
  });   
```
