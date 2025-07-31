import Foundation
import React
import RefinerSDK

#if RCT_NEW_ARCH_ENABLED
import RefinerReactNativeSpec
#endif

@objc(RNRefiner)
public class RNRefiner: RCTEventEmitter {
    
    private let kRefinerOnBeforeShow = "onBeforeShow"
    private let kRefinerOnNavigation = "onNavigation"
    private let kRefinerOnShow = "onShow"
    private let kRefinerOnClose = "onClose"
    private let kRefinerOnDismiss = "onDismiss"
    private let kRefinerOnComplete = "onComplete"
    private let kRefinerOnError = "onError"
    
    private let kRefinerFormId = "formId"
    private let kRefinerFormConfig = "formConfig"
    private let kRefinerFormElement = "formElement"
    private let kRefinerProgress = "progress"
    private let kRefinerFormData = "formData"
    private let kRefinerMessage = "message"
    
    public func methodQueue() -> DispatchQueue! {
        return DispatchQueue.main
    }
    
    public override func supportedEvents() -> [String]! {
        return [
            kRefinerOnBeforeShow,
            kRefinerOnNavigation,
            kRefinerOnShow,
            kRefinerOnClose,
            kRefinerOnDismiss,
            kRefinerOnComplete,
            kRefinerOnError
        ]
    }
    
    @objc
    public override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    @objc
    public override static func moduleName() -> String! {
        return "RNRefiner"
    }
    
    // MARK: - Public Methods
    
    @objc(initialize:withDebugMode:)
    func initialize(_ projectId: String, debugMode: Bool) {
        // Register callbacks first, synchronously
        self.registerCallbacks()
        
        // Then initialize the SDK
        DispatchQueue.main.async {
            Refiner.instance.initialize(projectId: projectId, debugMode: debugMode)
        }
    }
    
    @objc(setProject:)
    func setProject(_ projectId: String) {
        Refiner.instance.setProject(with: projectId)
    }
    
    @objc(identifyUser:withUserTraits:withLocale:withSignature:withWriteOperation:)
    func identifyUser(_ userId: String, userTraits: NSDictionary, locale: String?, signature: String?, writeOperation: String?) {
        DispatchQueue.main.async {
            // Convert NSDictionary to Swift Dictionary
            var userTraitsMap: [String: Any] = [:]
            for (key, value) in userTraits {
                if let stringKey = key as? String {
                    userTraitsMap[stringKey] = value
                }
            }
            
            // Try to call Refiner SDK with error handling
            do {
                let operation: Refiner.WriteOperation
                if let writeOp = writeOperation, !writeOp.isEmpty {
                    operation = Refiner.WriteOperation(rawValue: writeOp) ?? .append
                } else {
                    operation = .append
                }
                
                try? Refiner.instance.identifyUser(
                    userId: userId,
                    userTraits: userTraitsMap,
                    locale: locale,
                    signature: signature,
                    writeOperation: operation.rawValue
                )
            } catch {
                // Handle error silently
            }
        }
    }
    
    @objc(setUser:withUserTraits:withLocale:withSignature:)
    func setUser(_ userId: String, userTraits: NSDictionary?, locale: String?, signature: String?) {
        DispatchQueue.main.async {
            let userTraitsMap = userTraits?.toSwiftDictionary() ?? [:]
            try? Refiner.instance.setUser(userId: userId, userTraits: userTraitsMap, locale: locale, signature: signature)
        }
    }
    
    @objc
    func resetUser() {
        Refiner.instance.resetUser()
    }
    
    @objc(trackEvent:)
    func trackEvent(_ eventName: String) {
        Refiner.instance.trackEvent(name: eventName)
    }
    
    @objc(trackScreen:)
    func trackScreen(_ screenName: String) {
        Refiner.instance.trackScreen(name: screenName)
    }
    
    @objc
    func ping() {
        Refiner.instance.ping()
    }
    
    @objc(showForm:withForce:)
    func showForm(_ formUuid: String, force: Bool) {
        DispatchQueue.main.async {
            Refiner.instance.showForm(uuid: formUuid, force: force)
        }
    }
    
    @objc(dismissForm:)
    func dismissForm(_ formUuid: String) {
        DispatchQueue.main.async {
            Refiner.instance.dismissForm(uuid: formUuid)
        }
    }
    
    @objc(closeForm:)
    func closeForm(_ formUuid: String) {
        DispatchQueue.main.async {
            Refiner.instance.closeForm(uuid: formUuid)
        }
    }
    
    @objc(addToResponse:)
    func addToResponse(_ contextualData: NSDictionary?) {
        DispatchQueue.main.async {
            let contextualDataMap = contextualData?.toSwiftDictionary() ?? [:]
            Refiner.instance.addToResponse(data: contextualDataMap)
        }
    }
    
    @objc
    func startSession() {
        Refiner.instance.startSession()
    }
    
    // MARK: - Architecture Detection Methods
    
    @objc(getArchitectureInfo:rejecter:)
    func getArchitectureInfo(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
        #if RCT_NEW_ARCH_ENABLED
            resolve(true)
        #else
            resolve(false)
        #endif
    }
    
    @objc(setArchitectureInfo:)
    func setArchitectureInfo(_ isNewArch: Bool) {
        // Store architecture info if needed for future use
        // Currently using compile-time detection, but this allows runtime override
    }
    
    @objc(detectArchitecture:rejecter:)
    func detectArchitecture(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
        #if RCT_NEW_ARCH_ENABLED
            resolve(true)
        #else
            resolve(false)
        #endif
    }
    
    // MARK: - Deprecated Methods
    
    @objc(attachToResponse:)
    func attachToResponse(_ contextualData: [String: Any]?) {
        DispatchQueue.main.async {
            self.addToResponse(contextualData as NSDictionary?)
        }
    }
    
    // MARK: - Event Emitter Methods
    
    @objc(addListener:)
    public override func addListener(_ eventName: String) {
        // Call super to properly register the listener with RCTEventEmitter
        super.addListener(eventName)
    }
    
    @objc(removeListeners:)
    public override func removeListeners(_ count: Double) {
        // Call super to properly remove listeners with RCTEventEmitter
        super.removeListeners(count)
    }
    
    // MARK: - Private Methods
    
    private func registerCallbacks() {
        Refiner.instance.onBeforeShow = { [weak self] formId, formConfig in
            guard let self = self else { return }
            
            let configString = self.serializeToJSON(formConfig)
            let body: [String: Any] = [
                self.kRefinerFormId: formId,
                self.kRefinerFormConfig: configString
            ]
            self.emitEventInternal(self.kRefinerOnBeforeShow, body: body)
        }
        
        Refiner.instance.onNavigation = { [weak self] formId, formElement, progress in
            guard let self = self else { return }
            
            let elementString = self.serializeToJSON(formElement)
            let progressString = self.serializeToJSON(progress)
            let body: [String: Any] = [
                self.kRefinerFormId: formId,
                self.kRefinerFormElement: elementString,
                self.kRefinerProgress: progressString
            ]
            self.emitEventInternal(self.kRefinerOnNavigation, body: body)
        }
        
        Refiner.instance.onShow = { [weak self] formId in
            guard let self = self else { return }
            
            let body: [String: Any] = [
                self.kRefinerFormId: formId
            ]
            self.emitEventInternal(self.kRefinerOnShow, body: body)
        }
        
        Refiner.instance.onClose = { [weak self] formId in
            guard let self = self else { return }
            
            let body: [String: Any] = [
                self.kRefinerFormId: formId
            ]
            self.emitEventInternal(self.kRefinerOnClose, body: body)
        }
        
        Refiner.instance.onDismiss = { [weak self] formId in
            guard let self = self else { return }
            
            let body: [String: Any] = [
                self.kRefinerFormId: formId
            ]
            self.emitEventInternal(self.kRefinerOnDismiss, body: body)
        }
        
        Refiner.instance.onComplete = { [weak self] formId, formData in
            guard let self = self else { return }
            
            let dataString = self.serializeToJSON(formData)
            let body: [String: Any] = [
                self.kRefinerFormId: formId,
                self.kRefinerFormData: dataString
            ]
            self.emitEventInternal(self.kRefinerOnComplete, body: body)
        }
        
        Refiner.instance.onError = { [weak self] message in
            guard let self = self else { return }
            
            let body: [String: Any] = [
                self.kRefinerMessage: message
            ]
            self.emitEventInternal(self.kRefinerOnError, body: body)
        }
    }
    
    private func emitEventInternal(_ eventName: String, body: [String: Any]) {
        // Add a small delay to ensure JavaScript listeners are fully registered
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.sendEvent(withName: eventName, body: body)
        }
    }
    
    private func serializeToJSON(_ object: Any?) -> String {
        guard let object = object else { return "" }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: object, options: [])
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }
}

#if RCT_NEW_ARCH_ENABLED
// MARK: - TurboModule Support
extension RNRefiner: NativeRNRefinerSpec {
    func initialize(_ projectId: String, debugMode: Bool) -> Void {
        // Register callbacks first, synchronously
        self.registerCallbacks()
        
        // Then initialize the SDK
        DispatchQueue.main.async {
            Refiner.instance.initialize(projectId: projectId, debugMode: debugMode)
        }
    }
    
    func setProject(_ projectId: String) -> Void {
        Refiner.instance.setProject(with: projectId)
    }
    
    func identifyUser(_ userId: String, userTraits: NSDictionary, locale: String?, signature: String?, writeOperation: String?) -> Void {
        DispatchQueue.main.async {
            // Convert NSDictionary to Swift Dictionary
            var userTraitsMap: [String: Any] = [:]
            for (key, value) in userTraits {
                if let stringKey = key as? String {
                    userTraitsMap[stringKey] = value
                }
            }
            
            // Check if Refiner SDK is available
            if Refiner.instance != nil {
                // Try to call Refiner SDK with error handling
                do {
                    let operation: Refiner.WriteOperation
                    if let writeOp = writeOperation, !writeOp.isEmpty {
                        operation = Refiner.WriteOperation(rawValue: writeOp) ?? .append
                    } else {
                        operation = .append
                    }
                    
                    try? Refiner.instance.identifyUser(
                        userId: userId,
                        userTraits: userTraitsMap,
                        locale: locale,
                        signature: signature,
                        writeOperation: operation.rawValue
                    )
                } catch {
                    // Handle error silently
                }
            }
        }
    }
    
    func setUser(_ userId: String, userTraits: NSDictionary?, locale: String?, signature: String?) -> Void {
        DispatchQueue.main.async {
            let userTraitsMap = userTraits?.toSwiftDictionary() ?? [:]
            try? Refiner.instance.setUser(userId: userId, userTraits: userTraitsMap, locale: locale, signature: signature)
        }
    }
    
    func resetUser() -> Void {
        Refiner.instance.resetUser()
    }
    
    func trackEvent(_ eventName: String) -> Void {
        Refiner.instance.trackEvent(name: eventName)
    }
    
    func trackScreen(_ screenName: String) -> Void {
        Refiner.instance.trackScreen(name: screenName)
    }
    
    func ping() -> Void {
        Refiner.instance.ping()
    }
    
    func showForm(_ formUuid: String, force: Bool) -> Void {
        DispatchQueue.main.async {
            Refiner.instance.showForm(uuid: formUuid, force: force)
        }
    }
    
    func dismissForm(_ formUuid: String) -> Void {
        DispatchQueue.main.async {
            Refiner.instance.dismissForm(uuid: formUuid)
        }
    }
    
    func closeForm(_ formUuid: String) -> Void {
        DispatchQueue.main.async {
            Refiner.instance.closeForm(uuid: formUuid)
        }
    }
    
    func addToResponse(_ contextualData: NSDictionary?) -> Void {
        DispatchQueue.main.async {
            let contextualDataMap = contextualData?.toSwiftDictionary() ?? [:]
            Refiner.instance.addToResponse(data: contextualDataMap)
        }
    }
    
    func startSession() -> Void {
        Refiner.instance.startSession()
    }
    
    func addListener(_ eventName: String) -> Void {
        // Required for RN built in Event Emitter Calls
    }
    
    func removeListeners(_ count: Double) -> Void {
        // Required for RN built in Event Emitter Calls
    }
    
    // Architecture detection methods for TurboModule
    func getArchitectureInfo(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        #if RCT_NEW_ARCH_ENABLED
            resolve(true)
        #else
            resolve(false)
        #endif
    }
    
    func setArchitectureInfo(_ isNewArch: Bool) -> Void {
        // Store architecture info if needed for future use
        // Currently using compile-time detection, but this allows runtime override
    }
    
    func detectArchitecture(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        #if RCT_NEW_ARCH_ENABLED
            resolve(true)
        #else
            resolve(false)
        #endif
    }
}
#endif

// MARK: - Extensions

extension NSDictionary {
    func toSwiftDictionary() -> [String: Any] {
        var result: [String: Any] = [:]
        for (key, value) in self {
            if let stringKey = key as? String {
                result[stringKey] = value
            }
        }
        return result
    }
}

extension Dictionary where Key == String, Value == Any {
    func toMutableMap() -> [String: Any] {
        return self
    }
} 