
package io.refiner.rn

import com.facebook.react.bridge.*
import com.facebook.react.turbomodule.core.interfaces.TurboModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.Promise
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.facebook.react.module.annotations.ReactModule
import io.refiner.Refiner
import io.refiner.rn.utils.MapUtil
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonObject

@ReactModule(name = RNRefinerTurboModule.NAME)
class RNRefinerTurboModule(
    reactContext: ReactApplicationContext
) : NativeRNRefinerSpec(reactContext) {

    companion object {
        const val NAME = "RNRefiner"
        private val isNewArchitecture = BuildConfig.IS_NEW_ARCHITECTURE_ENABLED
    }

    @ReactMethod
    override fun initialize(projectId: String, debugMode: Boolean) {
        Refiner.initialize(reactApplicationContext.applicationContext, projectId, debugMode)
        registerCallbacks()
    }

    @ReactMethod
    override fun setProject(projectId: String) {
        Refiner.setProject(projectId)
    }

    @ReactMethod
    override fun identifyUser(
        userId: String?,
        userTraits: ReadableMap,
        locale: String?,
        signature: String?,
        writeOperation: String?
    ) {
        val userTraitsMap = MapUtil.toMap(userTraits)
        val operation = writeOperation?.let { Refiner.WriteOperation.valueOf(it) }
            ?: Refiner.WriteOperation.APPEND
        Refiner.identifyUser(userId, userTraitsMap, locale, signature, operation)
    }

    @ReactMethod
    override fun setUser(
        userId: String?,
        userTraits: ReadableMap?,
        locale: String?,
        signature: String?
    ) {
        val userTraitsMap = userTraits?.let { MapUtil.toMap(it) }
        Refiner.setUser(userId, userTraitsMap, locale, signature)
    }

    @ReactMethod
    override fun resetUser() {
        Refiner.resetUser()
    }

    @ReactMethod
    override fun trackEvent(eventName: String) {
        Refiner.trackEvent(eventName)
    }

    @ReactMethod
    override fun trackScreen(screenName: String) {
        Refiner.trackScreen(screenName)
    }

    @ReactMethod
    override fun ping() {
        Refiner.ping()
    }

    @ReactMethod
    override fun showForm(formUuid: String, force: Boolean) {
        try {
            Refiner.showForm(formUuid, force)
        } catch (e: Exception) {
            // Handle error silently in production
        }
    }

    @ReactMethod
    override fun dismissForm(formUuid: String) {
        Refiner.dismissForm(formUuid)
    }

    @ReactMethod
    override fun closeForm(formUuid: String) {
        Refiner.closeForm(formUuid)
    }

    @ReactMethod
    override fun addToResponse(contextualData: ReadableMap?) {
        val contextualDataMap = contextualData?.let { MapUtil.toMap(it) }
        Refiner.addToResponse(contextualDataMap)
    }

    @ReactMethod
    override fun startSession() {
        Refiner.startSession()
    }

    @ReactMethod
    override fun setLocale(locale: String?) {
        locale?.let { Refiner.setLocale(it) }
    }

    @ReactMethod
    override fun setAnonymousId(anonymousId: String?) {
        anonymousId?.let { Refiner.setAnonymousId(it) }
    }

    @ReactMethod
    override fun addListener(eventName: String) {
        // Keep: Required for RN built in Event Emitter Calls.
    }

    @ReactMethod
    override fun removeListeners(count: Double) {
        // Keep: Required for RN built in Event Emitter Calls.
    }

    private fun registerCallbacks() {
        Refiner.onBeforeShow { formId, formConfig ->
            val config = Json.Default.encodeToString(JsonObject.serializer(), formConfig as JsonObject)
            val params = Arguments.createMap().apply {
                putString("formId", formId)
                putString("formConfig", config)
            }
            sendEvent("onBeforeShow", params)
        }

        Refiner.onShow { formId ->
            val params = Arguments.createMap().apply {
                putString("formId", formId.toString())
            }
            sendEvent("onShow", params)
        }

        Refiner.onClose { formId ->
            val params = Arguments.createMap().apply {
                putString("formId", formId.toString())
            }
            sendEvent("onClose", params)
        }

        Refiner.onDismiss { formId ->
            val params = Arguments.createMap().apply {
                putString("formId", formId.toString())
            }
            sendEvent("onDismiss", params)
        }

        Refiner.onComplete { formId, formData ->
            val data = Json.Default.encodeToString(JsonObject.serializer(), formData as JsonObject)
            val params = Arguments.createMap().apply {
                putString("formId", formId.toString())
                putString("formData", data)
            }
            sendEvent("onComplete", params)
        }

        Refiner.onNavigation { formId, formElement, progress ->
            val element = Json.Default.encodeToString(JsonObject.serializer(), formElement as JsonObject)
            val pro = Json.Default.encodeToString(JsonObject.serializer(), progress as JsonObject)

            val params = Arguments.createMap().apply {
                putString("formId", formId)
                putString("formElement", element)
                putString("progress", pro)
            }
            sendEvent("onNavigation", params)
        }

        Refiner.onError { message ->
            val params = Arguments.createMap().apply {
                putString("message", message.toString())
            }
            sendEvent("onError", params)
        }
    }

    private fun sendEvent(eventName: String, params: WritableMap?) {
        try {
            reactApplicationContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit(eventName, params)
        } catch (t: Throwable) {
            // Log error if needed
        }
    }
} 
