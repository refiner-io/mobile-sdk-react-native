
package io.refiner;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.util.HashMap;
import java.util.LinkedHashMap;

import javax.annotation.Nullable;

public class RNRefinerModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public RNRefinerModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNRefiner";
    }

    @ReactMethod
    public void initialize(RefinerConfigs refinerConfigs) {
        Refiner.INSTANCE.initialize(reactContext, refinerConfigs);
    }

    @ReactMethod
    public void identifyUser(String userId, @Nullable LinkedHashMap<String, Object> userTraits, @Nullable String locale) {
        Refiner.INSTANCE.identifyUser(userId, userTraits, locale);
    }

    @ReactMethod
    public void resetUser() {
        Refiner.INSTANCE.resetUser();
    }

    @ReactMethod
    public void trackEvent(String eventName) {
        Refiner.INSTANCE.trackEvent(eventName);
    }

    @ReactMethod
    public void trackScreen(String screenName) {
        Refiner.INSTANCE.trackScreen(screenName);
    }

    @ReactMethod
    public void showForm(String formUuid, Boolean force) {
        Refiner.INSTANCE.showForm(formUuid, force);
    }

    @ReactMethod
    public void attachToResponse(@Nullable HashMap<String, Object> contextualData) {
        Refiner.INSTANCE.attachToResponse(contextualData);
    }
}
