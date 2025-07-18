package io.refiner.rn

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableMap
import com.facebook.react.modules.core.RCTNativeAppEventEmitter
import io.refiner.Refiner
import io.refiner.rn.utils.MapUtil
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonObject

class RNRefinerModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String = "RNRefiner"

    @ReactMethod
    fun initialize(projectId: String?, debugMode: Boolean?) {
        projectId?.let { id ->
            Refiner.INSTANCE.initialize(reactContext.applicationContext, id, debugMode)
            registerCallbacks()
        }
    }

    @ReactMethod
    fun setProject(projectId: String?) {
        projectId?.let { id ->
            Refiner.INSTANCE.setProject(id)
        }
    }

    @ReactMethod
    fun identifyUser(
        userId: String?,
        userTraits: ReadableMap?,
        locale: String?,
        signature: String?,
        writeOperation: String?
    ) {
        val userTraitsMap = userTraits?.let { MapUtil.toMap(it) }?.toMutableMap()
        
        userId?.let { id ->
            val operation = writeOperation?.let { Refiner.WriteOperation.valueOf(it) } 
                ?: Refiner.WriteOperation.APPEND
            Refiner.INSTANCE.identifyUser(id, userTraitsMap, locale, signature, operation)
        }
    }

    @ReactMethod
    fun setUser(
        userId: String?,
        userTraits: ReadableMap?,
        locale: String?,
        signature: String?
    ) {
        val userTraitsMap = userTraits?.let { MapUtil.toMap(it) }?.toMutableMap()
        
        userId?.let { id ->
            Refiner.INSTANCE.setUser(id, userTraitsMap, locale, signature)
        }
    }

    @ReactMethod
    fun resetUser() {
        Refiner.INSTANCE.resetUser()
    }

    @ReactMethod
    fun trackEvent(eventName: String?) {
        eventName?.let { name ->
            Refiner.INSTANCE.trackEvent(name)
        }
    }

    @ReactMethod
    fun trackScreen(screenName: String?) {
        screenName?.let { name ->
            Refiner.INSTANCE.trackScreen(name)
        }
    }

    @ReactMethod
    fun ping() {
        Refiner.INSTANCE.ping()
    }

    @ReactMethod
    fun showForm(formUuid: String?, force: Boolean) {
        formUuid?.let { uuid ->
            Refiner.INSTANCE.showForm(uuid, force)
        }
    }

    @ReactMethod
    fun dismissForm(formUuid: String?) {
        formUuid?.let { uuid ->
            Refiner.INSTANCE.dismissForm(uuid)
        }
    }

    @ReactMethod
    fun closeForm(formUuid: String?) {
        formUuid?.let { uuid ->
            Refiner.INSTANCE.closeForm(uuid)
        }
    }

    @ReactMethod
    fun addToResponse(contextualData: ReadableMap?) {
        val contextualDataMap = contextualData?.let { MapUtil.toMap(it) }?.toMutableMap()
        Refiner.INSTANCE.addToResponse(contextualDataMap)
    }

    @ReactMethod
    fun startSession() {
        Refiner.INSTANCE.startSession()
    }

    @Deprecated("Use addToResponse instead")
    @ReactMethod
    fun attachToResponse(contextualData: ReadableMap?) {
        addToResponse(contextualData)
    }

    @ReactMethod
    fun addListener(eventName: String?) {
        // Keep: Required for RN built in Event Emitter Calls.
    }

    @ReactMethod
    fun removeListeners(count: Int?) {
        // Keep: Required for RN built in Event Emitter Calls.
    }

    private fun registerCallbacks() {
        Refiner.INSTANCE.onBeforeShow { formId, formConfig ->
            val config = Json.Default.encodeToString(JsonObject.serializer(), formConfig as JsonObject)
            val params = Arguments.createMap().apply {
                putString("formId", formId)
                putString("formConfig", config)
            }
            sendEvent("onBeforeShow", params)
            null
        }

        Refiner.INSTANCE.onShow { formId ->
            val params = Arguments.createMap().apply {
                putString("formId", formId.toString())
            }
            sendEvent("onShow", params)
            null
        }

        Refiner.INSTANCE.onClose { formId ->
            val params = Arguments.createMap().apply {
                putString("formId", formId.toString())
            }
            sendEvent("onClose", params)
            null
        }

        Refiner.INSTANCE.onDismiss { formId ->
            val params = Arguments.createMap().apply {
                putString("formId", formId.toString())
            }
            sendEvent("onDismiss", params)
            null
        }

        Refiner.INSTANCE.onComplete { formId, formData ->
            val data = Json.Default.encodeToString(JsonObject.serializer(), formData as JsonObject)
            val params = Arguments.createMap().apply {
                putString("formId", formId.toString())
                putString("formData", data)
            }
            sendEvent("onComplete", params)
            null
        }

        Refiner.INSTANCE.onNavigation { formId, formElement, progress ->
            val element = Json.Default.encodeToString(JsonObject.serializer(), formElement as JsonObject)
            val pro = Json.Default.encodeToString(JsonObject.serializer(), progress as JsonObject)

            val params = Arguments.createMap().apply {
                putString("formId", formId)
                putString("formElement", element)
                putString("progress", pro)
            }
            sendEvent("onNavigation", params)
            null
        }

        Refiner.INSTANCE.onError { message ->
            val params = Arguments.createMap().apply {
                putString("message", message.toString())
            }
            sendEvent("onError", params)
            null
        }
    }

    private fun sendEvent(eventName: String, params: Any?) {
        try {
            reactApplicationContext
                .getJSModule(RCTNativeAppEventEmitter::class.java)
                .emit(eventName, params)
        } catch (t: Throwable) {
            // Log error if needed
        }
    }
} 