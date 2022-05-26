
package io.refiner.rn;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

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

        onBeforeShow();
        onShow();
        onClose();
        onComplete();
        onDismiss();
        onNavigation();
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

    private void onBeforeShow() {
        Refiner.INSTANCE.onBeforeShow((formId, formConfig) -> {
            String config = Json.Default.encodeToString(JsonObject.Companion.serializer(), (JsonObject) formConfig);
            WritableMap params = Arguments.createMap();
            params.putString("formId", formId);
            params.putString("formConfig", config);
            sendEvent("onBeforeShow", params, reactContext);
            return null;
        });
    }

    private void onShow() {
        Refiner.INSTANCE.onShow((formId) -> {
            WritableMap params = Arguments.createMap();
            params.putString("formId", formId.toString());
            sendEvent("onShow", params, reactContext);
            return null;
        });
    }

    private void onClose() {
        Refiner.INSTANCE.onClose((formId) -> {
            WritableMap params = Arguments.createMap();
            params.putString("formId", formId.toString());
            sendEvent("onClose", params, reactContext);
            return null;
        });
    }

    private void onDismiss() {
        Refiner.INSTANCE.onDismiss((formId) -> {
            WritableMap params = Arguments.createMap();
            params.putString("formId", formId.toString());
            sendEvent("onDismiss", params, reactContext);
            return null;
        });
    }

    private void onComplete() {
        Refiner.INSTANCE.onComplete((formId, formData) -> {
            String data = Json.Default.encodeToString(JsonObject.Companion.serializer(), (JsonObject) formData);
            WritableMap params = Arguments.createMap();
            params.putString("formId", formId.toString());
            params.putString("formData", data);
            sendEvent("onComplete", params, reactContext);
            return null;
        });
    }

    private void onNavigation() {
        Refiner.INSTANCE.onNavigation((formId, formElement, progress) -> {
            String element = Json.Default.encodeToString(JsonObject.Companion.serializer(), (JsonObject) formElement);
            String pro = Json.Default.encodeToString(JsonObject.Companion.serializer(), (JsonObject) progress);

            WritableMap params = Arguments.createMap();
            params.putString("formId", formId);
            params.putString("formElement", element);
            params.putString("progress", pro);
            sendEvent("onNavigation", params, reactContext);
            return null;
        });
    }

    private void sendEvent(String eventName, Object params, ReactContext context) {
        try {
            context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(eventName, params);
//            Log.d(TAG, "Sending event " + eventName);
        } catch (Throwable t) {
//            Log.e(TAG, t.getLocalizedMessage());
        }
    }
}
