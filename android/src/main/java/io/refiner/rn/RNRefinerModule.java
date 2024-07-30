
package io.refiner.rn;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.RCTNativeAppEventEmitter;

import java.util.HashMap;
import java.util.LinkedHashMap;

import io.refiner.Refiner;
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
    public void initialize(String projectId, Boolean debugMode) {
        if (projectId != null) {
            Refiner.INSTANCE.initialize(reactContext, projectId, debugMode);
            registerCallbacks();
        }
    }

    @ReactMethod
    public void setProject(String projectId) {
        if (projectId != null) {
            Refiner.INSTANCE.setProject(projectId);
        }
    }

    @ReactMethod
    public void identifyUser(String userId, ReadableMap userTraits, String locale, String signature) {
        LinkedHashMap<String, Object> userTraitsMap = null;
        if (userTraits != null) {
            userTraitsMap = new LinkedHashMap<>(MapUtil.toMap(userTraits));
        }
        if (userId != null) {
            Refiner.INSTANCE.identifyUser(userId, userTraitsMap, locale, signature);
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
    public void ping() {
        Refiner.INSTANCE.ping();
    }

    @ReactMethod
    public void showForm(String formUuid, boolean force) {
        if (formUuid != null) {
            Refiner.INSTANCE.showForm(formUuid, force);
        }
    }

    @ReactMethod
    public void dismissForm(String formUuid) {
        if (formUuid != null) {
            Refiner.INSTANCE.dismissForm(formUuid);
        }
    }

    @ReactMethod
    public void closeForm(String formUuid) {
        if (formUuid != null) {
            Refiner.INSTANCE.closeForm(formUuid);
        }
    }

    @ReactMethod
    public void addToResponse(ReadableMap contextualData) {
        HashMap<String, Object> contextualDataMap = null;
        if (contextualData != null) {
            contextualDataMap = new HashMap<>(MapUtil.toMap(contextualData));
        }
        Refiner.INSTANCE.addToResponse(contextualDataMap);
    }

    @ReactMethod
    public void startSession() {
        Refiner.INSTANCE.startSession();
    }

    @Deprecated
    @ReactMethod
    public void attachToResponse(ReadableMap contextualData) {
        addToResponse(contextualData);
    }

    @ReactMethod
    public void addListener(String eventName) {
        // Keep: Required for RN built in Event Emitter Calls.
    }

    @ReactMethod
    public void removeListeners(Integer count) {
        // Keep: Required for RN built in Event Emitter Calls.
    }

    private void registerCallbacks() {
        Refiner.INSTANCE.onBeforeShow((formId, formConfig) -> {
            String config = Json.Default.encodeToString(JsonObject.Companion.serializer(), (JsonObject) formConfig);
            WritableMap params = Arguments.createMap();
            params.putString("formId", formId);
            params.putString("formConfig", config);
            sendEvent("onBeforeShow", params);
            return null;
        });

        Refiner.INSTANCE.onShow((formId) -> {
            WritableMap params = Arguments.createMap();
            params.putString("formId", formId.toString());
            sendEvent("onShow", params);
            return null;
        });

        Refiner.INSTANCE.onClose((formId) -> {
            WritableMap params = Arguments.createMap();
            params.putString("formId", formId.toString());
            sendEvent("onClose", params);
            return null;
        });

        Refiner.INSTANCE.onDismiss((formId) -> {
            WritableMap params = Arguments.createMap();
            params.putString("formId", formId.toString());
            sendEvent("onDismiss", params);
            return null;
        });

        Refiner.INSTANCE.onComplete((formId, formData) -> {
            String data = Json.Default.encodeToString(JsonObject.Companion.serializer(), (JsonObject) formData);
            WritableMap params = Arguments.createMap();
            params.putString("formId", formId.toString());
            params.putString("formData", data);
            sendEvent("onComplete", params);
            return null;
        });

        Refiner.INSTANCE.onNavigation((formId, formElement, progress) -> {
            String element = Json.Default.encodeToString(JsonObject.Companion.serializer(), (JsonObject) formElement);
            String pro = Json.Default.encodeToString(JsonObject.Companion.serializer(), (JsonObject) progress);

            WritableMap params = Arguments.createMap();
            params.putString("formId", formId);
            params.putString("formElement", element);
            params.putString("progress", pro);
            sendEvent("onNavigation", params);
            return null;
        });
    }

    private void sendEvent(String eventName, Object params) {
        try {
            getReactApplicationContext().getJSModule(RCTNativeAppEventEmitter.class).emit(eventName, params);
//            Log.d(TAG, "Sending event " + eventName);
        } catch (Throwable t) {
//            Log.e(TAG, t.getLocalizedMessage());
        }
    }
}
