//
//  Api.swift
//  AzureVision
//
//  Created by Colby L Williams on 9/13/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation

enum Api {
    case analyze
    case describe
    case textOperations(operationId: String)
    case generateThumbnail
    case models
    case ocr
    case recognizeText
    case tag
    
    
    static var version = "v2.0"
    static var basePath = "vision"
 
    
    var method: HttpMethod {
        switch self {
        case .textOperations, .models: return .get
        default: return .post
        }
    }
    
    var path: String {
        switch self {
        case .analyze:                   return "analyze"
        case .describe:                  return "describe"
        case let .textOperations(oId):   return "textOperations/" + oId
        case .generateThumbnail:         return "generateThumbnail"
        case .models:                    return "models"
        case .ocr:                       return "ocr"
        case .recognizeText:             return "recognizeText"
        case .tag:                       return "tag"
        }
    }
    

    // MARK: Container
    
    func url(forHost host: String, withQuery query: String? = nil) -> URL? {
        return URL(string: urlString(forHost: host, withQuery: query))
    }
    
    func urlString(forHost host: String, withQuery query: String? = nil) -> String {
        return "https://" + host + "/" + Api.basePath + "/" + Api.version + "/" + self.path + query.valueOrEmpty
    }

    
    // MARK: Azure
    
    func url(forRegion region: AzureRegion, withQuery query: String? = nil) -> URL? {
        return URL(string: urlString(forRegion: region, withQuery: query))
    }
    
    func urlString(forRegion region: AzureRegion, withQuery query: String? = nil) -> String {
        return "https://" + region.host + "/" + Api.basePath + "/" + Api.version + "/" + self.path + query.valueOrEmpty
    }
    
    func contentType(_ boundary: String? = nil) -> String {
        switch self {
        case .analyze, .describe, .ocr: return "multipart/form-data; boundary=\(boundary!)"
        default: return "application/json"
        }
    }
}


public enum AzureRegion : String {
    case westUS         = "westus"
    case westUS2        = "westus2"
    case eastUS         = "eastus"
    case eastUS2        = "eastus2"
    case westCentralUS  = "westcentralus"
    case southCentralUS = "southcentralus"
    case westEurope     = "westeurope"
    case northEurope    = "northeurope"
    case southeastAsia  = "southeastasia"
    case eastAsia       = "eastasia"
    case australiaEast  = "australiaeast"
    case brazilSouth    = "brazilsouth"
    case canadaCentral  = "canadacentral"
    case centralIndia   = "centralindia"
    case ukSouth        = "uksouth"
    case japanEast      = "japaneast"
    
    var host: String {
        return self.rawValue + ".api.cognitive.microsoft.com"
    }
}



