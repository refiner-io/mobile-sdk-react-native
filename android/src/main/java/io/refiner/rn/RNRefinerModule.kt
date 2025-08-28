package io.refiner.rn

import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule
import io.refiner.Refiner
import io.refiner.rn.utils.MapUtil
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonObject

class RNRefinerModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    companion object {
        const val NAME = "RNRefiner"
        private val isNewArchitecture = BuildConfig.IS_NEW_ARCHITECTURE_ENABLED
    }

    init {
        android.util.Log.d("RNRefinerModule", "RNRefinerModule instantiated, isNewArch: $isNewArchitecture")
    }

    override fun getName(): String = NAME

    @ReactMethod
    @Suppress("UNUSED_PARAMETER")
    fun setArchitectureInfo(isNewArch: Boolean) {
        // Architecture is determined at build time via BuildConfig.IS_NEW_ARCHITECTURE_ENABLED
        // This method is kept for compatibility but doesn't change the architecture
    }

    @ReactMethod
    fun getArchitectureInfo(promise: Promise) {
        promise.resolve(isNewArchitecture)
    }

    @ReactMethod
    fun detectArchitecture(promise: Promise) {
        promise.resolve(isNewArchitecture)
    }

    @ReactMethod
    fun initialize(projectId: String?, debugMode: Boolean?) {
        android.util.Log.d("RNRefinerModule", "initialize called with projectId: $projectId, debugMode: $debugMode")
        projectId?.let { id ->
            Refiner.initialize(reactApplicationContext.applicationContext, id, debugMode)
            registerCallbacks()
        }
    }

    @ReactMethod
    fun setProject(projectId: String?) {
        projectId?.let { id ->
            Refiner.setProject(id)
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
        val userTraitsMap = userTraits?.let { MapUtil.toMap(it) }
        
        userId?.let { id ->
            val operation = writeOperation?.let { Refiner.WriteOperation.valueOf(it) } 
                ?: Refiner.WriteOperation.APPEND
            Refiner.identifyUser(id, userTraitsMap, locale, signature, operation)
        }
    }

    @ReactMethod
    fun setUser(
        userId: String?,
        userTraits: ReadableMap?,
        locale: String?,
        signature: String?
    ) {
        val userTraitsMap = userTraits?.let { MapUtil.toMap(it) }
        
        userId?.let { id ->
            Refiner.setUser(id, userTraitsMap, locale, signature)
        }
    }

    @ReactMethod
    fun resetUser() {
        Refiner.resetUser()
    }

    @ReactMethod
    fun trackEvent(eventName: String?) {
        eventName?.let { name ->
            Refiner.trackEvent(name)
        }
    }

    @ReactMethod
    fun trackScreen(screenName: String?) {
        screenName?.let { name ->
            Refiner.trackScreen(name)
        }
    }

    @ReactMethod
    fun ping() {
        Refiner.ping()
    }

    @ReactMethod
    fun showForm(formUuid: String?, force: Boolean) {
        android.util.Log.d("RNRefinerModule", "showForm called with formUuid: $formUuid, force: $force")
        formUuid?.let { uuid ->
            Refiner.showForm(uuid, force)
        }
    }

    @ReactMethod
    fun dismissForm(formUuid: String?) {
        formUuid?.let { uuid ->
            Refiner.dismissForm(uuid)
        }
    }

    @ReactMethod
    fun closeForm(formUuid: String?) {
        formUuid?.let { uuid ->
            Refiner.closeForm(uuid)
        }
    }

    @ReactMethod
    fun addToResponse(contextualData: ReadableMap?) {
        val contextualDataMap = contextualData?.let { MapUtil.toMap(it) }
        Refiner.addToResponse(contextualDataMap)
    }

    @ReactMethod
    fun startSession() {
        Refiner.startSession()
    }

    @Deprecated("Use addToResponse instead", ReplaceWith("addToResponse(contextualData)"))
    @ReactMethod
    fun attachToResponse(contextualData: ReadableMap?) {
        addToResponse(contextualData)
    }

    @ReactMethod
    @Suppress("UNUSED_PARAMETER")
    fun addListener(eventName: String?) {
        // Keep: Required for RN built in Event Emitter Calls.
    }

    @ReactMethod
    @Suppress("UNUSED_PARAMETER")
    fun removeListeners(count: Int?) {
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
