import Foundation
import React
import RefinerSDK

@objc(RNRefiner)
class RNRefiner: RCTEventEmitter {
    
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
    
    override func methodQueue() -> DispatchQueue! {
        return DispatchQueue.main
    }
    
    override func supportedEvents() -> [String]! {
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
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    // MARK: - Public Methods
    
    @objc(initialize:withDebugMode:)
    func initialize(_ projectId: String, debugMode: Bool) {
        Refiner.instance.initialize(projectId: projectId, debugMode: debugMode)
        registerCallbacks()
    }
    
    @objc(setProject:)
    func setProject(_ projectId: String) {
        Refiner.instance.setProject(projectId)
    }
    
    @objc(identifyUser:withUserTraits:withLocale:withSignature:withWriteOperation:)
    func identifyUser(_ userId: String, userTraits: [String: Any]?, locale: String?, signature: String?, writeOperation: String?) {
        let operation = writeOperation.flatMap { Refiner.WriteOperation(rawValue: $0) } ?? .append
        let userTraitsMap = userTraits?.toMutableMap()
        Refiner.instance.identifyUser(userId: userId, userTraits: userTraitsMap, locale: locale, signature: signature, writeOperation: operation)
    }
    
    @objc(setUser:withUserTraits:withLocale:withSignature:)
    func setUser(_ userId: String, userTraits: [String: Any]?, locale: String?, signature: String?) {
        let userTraitsMap = userTraits?.toMutableMap()
        Refiner.instance.setUser(userId: userId, userTraits: userTraitsMap, locale: locale, signature: signature)
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
        Refiner.instance.showForm(uuid: formUuid, force: force)
    }
    
    @objc(dismissForm:)
    func dismissForm(_ formUuid: String) {
        Refiner.instance.dismissForm(uuid: formUuid)
    }
    
    @objc(closeForm:)
    func closeForm(_ formUuid: String) {
        Refiner.instance.closeForm(uuid: formUuid)
    }
    
    @objc(addToResponse:)
    func addToResponse(_ contextualData: [String: Any]?) {
        let contextualDataMap = contextualData?.toMutableMap()
        Refiner.instance.addToResponse(data: contextualDataMap)
    }
    
    @objc
    func startSession() {
        Refiner.instance.startSession()
    }
    
    // MARK: - Deprecated Methods
    
    @objc(attachToResponse:)
    func attachToResponse(_ contextualData: [String: Any]?) {
        // Deprecated: Use addToResponse instead
        addToResponse(contextualData)
    }
    
    // MARK: - Event Emitter Methods
    
    @objc(addListener:)
    func addListener(_ eventName: String) {
        // Required for RN built in Event Emitter Calls
    }
    
    @objc(removeListeners:)
    func removeListeners(_ count: Int) {
        // Required for RN built in Event Emitter Calls
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
        sendEvent(withName: eventName, body: body)
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

// MARK: - Extensions

extension Dictionary where Key == String, Value == Any {
    func toMutableMap() -> [String: Any] {
        return self
    }
} 