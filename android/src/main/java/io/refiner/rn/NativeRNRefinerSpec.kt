package io.refiner.rn

import com.facebook.react.bridge.*
import com.facebook.react.turbomodule.core.interfaces.TurboModule

interface NativeRNRefinerSpec : TurboModule {
    fun initialize(projectId: String, debugMode: Boolean)
    fun setProject(projectId: String)
    fun identifyUser(
        userId: String,
        userTraits: ReadableMap,
        locale: String?,
        signature: String?,
        writeOperation: String?
    )
    fun setUser(
        userId: String,
        userTraits: ReadableMap?,
        locale: String?,
        signature: String?
    )
    fun resetUser()
    fun trackEvent(eventName: String)
    fun trackScreen(screenName: String)
    fun ping()
    fun showForm(formUuid: String, force: Boolean)
    fun dismissForm(formUuid: String)
    fun closeForm(formUuid: String)
    fun addToResponse(contextualData: ReadableMap?)
    fun startSession()
    fun addListener(eventName: String)
    fun removeListeners(count: Double)
    fun setArchitectureInfo(isNewArch: Boolean)
    fun getArchitectureInfo(promise: Promise)
    fun detectArchitecture(promise: Promise)
} 