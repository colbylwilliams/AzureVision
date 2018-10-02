//
//  Keys.swift
//  AzureVision
//
//  Created by Colby L Williams on 9/14/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation

struct Keys : Codable {
    
    static let containerHostDefault = "COGNITIVE_SERVICE_CONTAINER_HOST"
    static let subscriptionKeyDefault = "OCP_APIM_SUBSCRIPTION_KEY"
    static let subscriptionRegionDefault = "OCP_APIM_SUBSCRIPTION_REGION"
    
    let containerHost: String?
    let subscriptionKey: String?
    let subscriptionRegion: String?
    
    
    var hasValidContainerHost: Bool {
        return Keys.isValidContainerHost(containerHost)
    }
    
    var hasValidSubscriptionKey: Bool {
        return Keys.isValidSubscriptionKey(subscriptionKey)
    }

    var hasValidSubscriptionRegion: Bool {
        return Keys.isValidSubscriptionKey(subscriptionKey)
    }

    var hasValidSubscriptionInfo: Bool {
        return hasValidSubscriptionKey && hasValidSubscriptionRegion
    }
    
    var hasValidInfo: Bool {
        return hasValidSubscriptionInfo || hasValidContainerHost
    }

    
    init?(from infoDictionary: [String:Any]?) {
        guard let info = infoDictionary else { return nil }
        containerHost = info[CodingKeys.containerHost.rawValue] as? String
        subscriptionKey = info[CodingKeys.subscriptionKey.rawValue] as? String
        subscriptionRegion = info[CodingKeys.subscriptionRegion.rawValue] as? String
    }
    
    private enum CodingKeys: String, CodingKey {
        case containerHost = "CognitiveServiceContainerHost"
        case subscriptionKey = "OcpApimSubscriptionKey"
        case subscriptionRegion = "CognitiveServiceSubscriptionRegion"
    }
    
    static func tryCreateFromPlists(custom: String? = nil) -> Keys? {
        
        let plistDecoder = PropertyListDecoder()
        
        if let customName = custom,
            let customData = Bundle.main.plist(named: customName),
            let customKeys = try? plistDecoder.decode(Keys.self, from: customData), customKeys.hasValidInfo {
            
            return customKeys
        }
        
        if let azureData = Bundle.main.plist(named: "Azure"),
            let azureKeys = try? plistDecoder.decode(Keys.self, from: azureData), azureKeys.hasValidInfo {
            
            return azureKeys
        }
        
        if let infoKeys = Keys(from: Bundle.main.infoDictionary), infoKeys.hasValidInfo {
            
            return infoKeys
        }
        
        return nil
    }
    
    static func isValidContainerHost(_ host: String?) -> Bool {
        return host != nil && !host!.isEmpty && host! != Keys.containerHostDefault
    }

    static func isValidSubscriptionKey(_ key: String?) -> Bool {
        return key != nil && !key!.isEmpty && key! != Keys.subscriptionKeyDefault
    }
    
    static func isValidSubscriptionRegion(_ region: String?) -> Bool {
        return region != nil && !region!.isEmpty && region! != Keys.subscriptionRegionDefault && AzureRegion(rawValue: region!.lowercased()) != nil
    }
}
