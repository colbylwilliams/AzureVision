//
//  Keys.swift
//  AzureVision
//
//  Created by Colby L Williams on 9/14/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation

struct Keys : Codable {
    
    static let subscriptionKeyDefault = "OCP_APIM_SUBSCRIPTION_KEY"
    
    let subscriptionKey: String?
    
    
    var hasValidSubscriptionKey: Bool {
        return Keys.isValidSubscriptionKey(subscriptionKey)
    }
    
    init?(from infoDictionary: [String:Any]?) {
        guard let info = infoDictionary else { return nil }
        subscriptionKey = info[CodingKeys.subscriptionKey.rawValue] as? String
    }
    
    private enum CodingKeys: String, CodingKey {
        case subscriptionKey = "OcpApimSubscriptionKey"
    }
    
    static func tryCreateFromPlists(custom: String? = nil) -> Keys? {
        
        let plistDecoder = PropertyListDecoder()
        
        if let customName = custom,
            let customData = Bundle.main.plist(named: customName),
            let customKeys = try? plistDecoder.decode(Keys.self, from: customData), customKeys.hasValidSubscriptionKey {
            
            return customKeys
        }
        
        if let azureData = Bundle.main.plist(named: "Azure"),
            let azureKeys = try? plistDecoder.decode(Keys.self, from: azureData), azureKeys.hasValidSubscriptionKey {
            
            return azureKeys
        }
        
        if let infoKeys = Keys(from: Bundle.main.infoDictionary), infoKeys.hasValidSubscriptionKey {
            
            return infoKeys
        }
        
        return nil
    }
    
    static func isValidSubscriptionKey(_ key: String?) -> Bool {
        return key != nil && !key!.isEmpty && key! != Keys.subscriptionKeyDefault
    }
}
