//
//  AzureVisionExtensions.swift
//  AzureVision
//
//  Created by Colby L Williams on 9/14/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension AzureVisionClient {
    
    #if os(macOS)
    typealias UIImage = NSImage
    #endif
    
    
    
    
    public func analyze(image: UIImage, visualFeatures categories: [AnalyzeParams.Categories]? = nil, details: [AnalyzeParams.Details]? = nil, language: AnalyzeParams.Language? = nil, completion: @escaping (Response<AnalyzeResult>) -> Void) {
        if let data = image.jpegData(compressionQuality: compressionQuality) {
            return self.analyze(image: data, visualFeatures: categories, details: details, language: language, completion: completion)
        } else {
            completion(Response(AzureVisionClientError.unknown))
        }
    }

    public func describe(image: UIImage, maxCandidates: Int = 1, language: DescribeParams.Language? = nil, completion: @escaping (Response<DescribeResult>) -> Void) {
        if let data = image.jpegData(compressionQuality: compressionQuality) {
            return self.describe(image: data, maxCandidates: maxCandidates, language: language, completion: completion)
        } else {
            completion(Response(AzureVisionClientError.unknown))
        }
    }
    
    public func thumbnail(image: UIImage, width: Int = 512, height: Int = 512, smartCrop: Bool = true, completion: @escaping (Response<Data>) -> Void) {
        if let data = image.jpegData(compressionQuality: compressionQuality) {
            return self.thumbnail(image: data, width: width, height: height, smartCrop: smartCrop, completion: completion)
        } else {
            completion(Response(AzureVisionClientError.unknown))
        }
    }
    
    public func ocr(image: UIImage, language: OcrParams.Language? = nil, detectOrientation: Bool? = nil, completion: @escaping (Response<OcrResult>) -> Void) {
        if let data = image.jpegData(compressionQuality: compressionQuality) {
            return self.ocr(image: data, language: language, detectOrientation: detectOrientation, completion: completion)
        } else {
            completion(Response(AzureVisionClientError.unknown))
        }
    }
    
    
    func getQuery(_ args: (String, Any?)...) -> String? {
        
        var query: String? = nil
        
        let filtered = args.compactMap { $0.1 != nil ? ($0.0, $0.1!) : nil }
        
        for item in filtered {
            query.add(item.0, item.1)
        }
        
        return query
    }
    
    
    func getMultipartFormBody(_ data: Data, boundary: String) -> Data {
        
        var body = Data()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(UUID().uuidString).jpeg\"\r\n")
        body.appendString("Content-Type: image/jpg\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body
    }
    

    
    #if os(macOS)
    func UIImageJPEGRepresentation(_ image: NSImage, _ scale: Float) -> Data? {
        
        if let bits = image.representations.first as? NSBitmapImageRep,
            let data = bits.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:]) {
            
            return data
        }
        return nil
    }
    #endif
}

