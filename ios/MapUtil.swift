import Foundation
import React

class MapUtil {
    
    static func toMap(_ readableMap: RCTResponseSenderBlock?) -> [String: Any]? {
        guard let readableMap = readableMap else { return nil }
        
        // This is a simplified version since React Native's bridge handles most conversions
        // In a real implementation, you would need to handle the ReadableMap properly
        return [:]
    }
    
    static func toWritableMap(_ map: [String: Any]?) -> [String: Any]? {
        return map
    }
    
    static func serializeToJSON(_ object: Any?) -> String {
        guard let object = object else { return "" }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: object, options: [])
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }
    
    static func deserializeFromJSON(_ jsonString: String) -> [String: Any]? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json as? [String: Any]
        } catch {
            return nil
        }
    }
} 