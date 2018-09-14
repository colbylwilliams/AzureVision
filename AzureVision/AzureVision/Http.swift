//
//  Http.swift
//  AzureVision
//
//  Created by Colby L Williams on 9/14/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation

enum HttpStatusCode : Int {
    case ok                     = 200
    case created                = 201
    case accepted               = 202
    case noContent              = 204
    case badRequest             = 400
    case unauthorized           = 401
    case forbidden              = 403
    case notFound               = 404
    case internalServerError    = 500
    case badGateway             = 502
    case serviceUnavailable     = 503
}


enum HttpMethod : String {
    case get    = "GET"
    case head   = "HEAD"
    case patch  = "PATCH"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
    
    var lowercased: String {
        switch self {
        case .get:      return "get"
        case .head:     return "head"
        case .patch:    return "patch"
        case .post:     return "post"
        case .put:      return "put"
        case .delete:   return "delete"
        }
    }
    
    var read: Bool {
        switch self {
        case .get, .head:           return true
        case .patch, .post, .put, .delete:  return false
        }
    }
    
    var write: Bool {
        return !read
    }
}


enum HttpHeader : String {
    case subscriptionKey = "Ocp-Apim-Subscription-Key"
    case contentType = "Content-Type"
}
