
# refiner-react-native

## Getting started

`$ npm install refiner-react-native --save`

## Usage
```javascript
import RNRefiner from 'refiner-react-native';

RNRefiner.initialize("PROJECT_ID");

var userTraits = { email: "hello@hello.com", a_number: 123, a_date: "2022-16-04 12:00:00" };
RNRefiner.identifyUser("USER_ID", userTraits, "LOCALE");

RNRefiner.resetUser();
RNRefiner.trackEvent("EVENT_NAME");
RNRefiner.trackScreen("SCREEN_NAME");
RNRefiner.showForm("FORM_UUID", true);

var contextualData = { some_data: "hello", some_more_data: "hello again" };
RNRefiner.attachToResponse(contextualData);
```
