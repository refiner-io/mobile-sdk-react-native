package io.refiner.rn

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import com.facebook.react.TurboReactPackage
import com.facebook.react.module.model.ReactModuleInfoProvider
import com.facebook.react.module.model.ReactModuleInfo

class RNRefinerPackage : TurboReactPackage() {

    override fun getModule(name: String, reactContext: ReactApplicationContext): NativeModule? {
        return when (name) {
            RNRefinerTurboModule.NAME -> RNRefinerTurboModule(reactContext)
            else -> null
        }
    }

    override fun getReactModuleInfoProvider(): ReactModuleInfoProvider {
        return ReactModuleInfoProvider {
            mapOf(
                RNRefinerTurboModule.NAME to ReactModuleInfo(
                    RNRefinerTurboModule.NAME,
                    RNRefinerTurboModule.NAME,
                    canOverrideExistingModule = false, // canOverrideExistingModule
                    needsEagerInit = false, // needsEagerInit
                    hasConstants = true,  // hasConstants
                    isCxxModule = false, // isCxxModule
                    isTurboModule = true   // isTurboModule
                )
            )
        }
    }

    // Legacy support for Old Architecture
    override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
        return listOf(RNRefinerModule(reactContext))
    }

    // Deprecated from RN 0.47
    fun createJSModules(): List<Class<out com.facebook.react.bridge.JavaScriptModule>> {
        return emptyList()
    }

    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
        return emptyList()
    }
} 
