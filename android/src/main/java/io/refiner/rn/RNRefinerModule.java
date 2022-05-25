
package io.refiner.rn;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

import java.util.HashMap;
import java.util.LinkedHashMap;

import io.refiner.Refiner;
import io.refiner.RefinerConfigs;
import io.refiner.rn.utils.MapUtil;
import kotlinx.serialization.json.Json;
import kotlinx.serialization.json.JsonObject;

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
    public void initialize(String projectId) {
        if (projectId != null) {
            Refiner.INSTANCE.initialize(reactContext, new RefinerConfigs(projectId));
        }
    }

    @ReactMethod
    public void identifyUser(String userId, ReadableMap userTraits, String locale) {
        LinkedHashMap<String, Object> userTraitsMap = null;
        if (userTraits != null) {
            userTraitsMap = new LinkedHashMap<>(MapUtil.toMap(userTraits));
        }
        if (userId != null) {
            Refiner.INSTANCE.identifyUser(userId, userTraitsMap, locale);
        }
    }

    @ReactMethod
    public void resetUser() {
        Refiner.INSTANCE.resetUser();
    }

    @ReactMethod
    public void trackEvent(String eventName) {
        if (eventName != null) {
            Refiner.INSTANCE.trackEvent(eventName);
        }
    }

    @ReactMethod
    public void trackScreen(String screenName) {
        if (screenName != null) {
            Refiner.INSTANCE.trackScreen(screenName);
        }
    }

    @ReactMethod
    public void showForm(String formUuid, boolean force) {
        if (formUuid != null) {
            Refiner.INSTANCE.showForm(formUuid, force);
        }
    }

    @ReactMethod
    public void attachToResponse(ReadableMap contextualData) {
        HashMap<String, Object> contextualDataMap = null;
        if (contextualData != null) {
            contextualDataMap = new HashMap<>(MapUtil.toMap(contextualData));
        }
        Refiner.INSTANCE.attachToResponse(contextualDataMap);
    }

    @ReactMethod
    public void onBeforeShow(Callback callback) {
        Refiner.INSTANCE.onBeforeShow((formId, formConfig) -> {
            String config = Json.Default.encodeToString(JsonObject.Companion.serializer(), (JsonObject) formConfig);
            callback.invoke(formId, config);
            return null;
        });
    }

//    @ReactMethod
//    public void onNavigation() {
//        Refiner.INSTANCE.onNavigation((formId, formElement, progress) -> {
////            JsonElement element = Json.Default.encodeToJsonElement(JsonObject.Companion.serializer(), (JsonObject) formElement);
////            JsonElement pro = Json.Default.encodeToJsonElement(JsonObject.Companion.serializer(), (JsonObject) progress);
//
//            WritableMap params = Arguments.createMap();
//            params.putString("formId", formId);
////            params.putMap("formElement", (WritableMap) element);
////            params.putMap("progress", (WritableMap) pro);
//            sendEvent("onNavigation", params, reactContext);
//            return null;
//        });
//    }

    @ReactMethod
    public void onShow(Callback callback) {
        Refiner.INSTANCE.onShow((formId) -> {
            callback.invoke(formId);
            return null;
        });
    }

    @ReactMethod
    public void onClose(Callback callback) {
        Refiner.INSTANCE.onClose((formId) -> {
            callback.invoke(formId);
            return null;
        });
    }

    @ReactMethod
    public void onDismiss(Callback callback) {
        Refiner.INSTANCE.onDismiss((formId) -> {
            callback.invoke(formId);
            return null;
        });
    }

    @ReactMethod
    public void onComplete(Callback callback) {
        Refiner.INSTANCE.onComplete((formId, formData) -> {
            String data = Json.Default.encodeToString(JsonObject.Companion.serializer(), (JsonObject) formData);
            callback.invoke(formId, data);
            return null;
        });
    }

//    private void sendEvent(String eventName, Object params, ReactContext context) {
//        try {
//            context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
//                    .emit(eventName, params);
//            Log.e(TAG, "Sending event " + eventName);
//        } catch (Throwable t) {
//            Log.e(TAG, t.getLocalizedMessage());
//        }
//    }
}
