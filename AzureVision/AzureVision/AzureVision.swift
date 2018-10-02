//
//  AzureVision.swift
//  AzureVision
//
//  Created by Colby L Williams on 9/13/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation

public class AzureVisionClient {
    
    public static let shared: AzureVisionClient = {
        
        let client = AzureVisionClient()
        
        return client
    }()
    
    
    let compressionQuality: CGFloat = 0.5
    
    let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    
    fileprivate let pollDelay: Double = 3
    fileprivate let boundary = "Boundary-\(UUID().uuidString)"
    
    fileprivate var usingContainer: Bool = false
    
    fileprivate var containerHost: String = Keys.containerHostDefault
    fileprivate var subscriptionKey: String = Keys.subscriptionKeyDefault
    fileprivate var subscriptionRegion: AzureRegion = .westUS
    
    
    // MARK: - Configure
    
    public func configure(withPlistNamed customPlistName: String? = nil) {
        
        if let keys = Keys.tryCreateFromPlists(custom: customPlistName) {
            
            if keys.hasValidSubscriptionInfo {
                self.configure(withSubscriptionKey: keys.subscriptionKey!, subscriptionRegion: AzureRegion(rawValue: keys.subscriptionRegion!)!)
            } else if keys.hasValidContainerHost {
                self.configure(withContainerHost: keys.containerHost!)
            }
        }
    }
    
    public func configure(withSubscriptionKey subscriptionKey: String, subscriptionRegion: AzureRegion) {
        self.usingContainer = false
        self.subscriptionKey = subscriptionKey
        self.subscriptionRegion = subscriptionRegion
    }
    
    public func configure(withContainerHost containerHost: String) {
        self.usingContainer = true
        self.containerHost = containerHost
    }

    
    // MARK: - API
    
    public func analyze(image imageData: Data, visualFeatures categories: [AnalyzeParams.Categories]? = nil, details: [AnalyzeParams.Details]? = nil, language: AnalyzeParams.Language? = nil, completion: @escaping (Response<AnalyzeResult>) -> Void) {
    
        let query = getQuery((AnalyzeParams.Categories.name, categories?.map{ $0.rawValue }), (AnalyzeParams.Details.name, details), (AnalyzeParams.Language.name, language))
        
        print(query!)
        
        do {
            let request = try dataRequest(for: Api.analyze, withBody: imageData, withQuery: query)
            
            return sendRequest(request, completion: completion)
            
        } catch {
            completion(Response(error))
        }
    }

    
    public func describe(image imageData: Data, maxCandidates: Int = 1, language: DescribeParams.Language? = nil, completion: @escaping (Response<DescribeResult>) -> Void) {
        
        let query = getQuery((DescribeParams.MaxCandidates.name, maxCandidates), (DescribeParams.Language.name, language))
        
        do {
            let request = try dataRequest(for: Api.describe, withBody: imageData, withQuery: query)
            
            return sendRequest(request, completion: completion)
            
        } catch {
            completion(Response(error))
        }
    }

    
    public func thumbnail(image imageData: Data, width: Int = 512, height: Int = 512, smartCrop: Bool = true, completion: @escaping (Response<Data>) -> Void) {
        
        let query = getQuery((ThumbnailParams.width, width), (ThumbnailParams.height, height), (ThumbnailParams.smartCropping, smartCrop))
        
        do {
            let request = try dataRequest(for: Api.generateThumbnail, withBody: imageData, withQuery: query)
            
            return sendRequest(request, completion: completion)
            
        } catch {
            completion(Response(error))
        }
    }

    
    public func ocr(image imageData: Data, language: OcrParams.Language? = nil, detectOrientation: Bool? = nil, completion: @escaping (Response<OcrResult>) -> Void) {
        
        let query = getQuery((OcrParams.Language.name, language), (OcrParams.DetectOrientation.name, detectOrientation))
        
        do {
            let request = try dataRequest(for: Api.ocr, withBody: imageData, withQuery: query)
            
            return sendRequest(request, completion: completion)
            
        } catch {
            completion(Response(error))
        }
    }
    
    
    
    // MARK: - Request
    
    fileprivate func sendRequest<T:Codable> (_ request: URLRequest, completion: @escaping (Response<T>) -> ()) {
        
        session.dataTask(with: request) { (data, response, error) in
            
            let httpResponse = response as? HTTPURLResponse
            
            if let error = error {
                
                completion(Response(request: request, data: data, response: httpResponse, result: .failure(error)))
                
            } else if let data = data {
                
                do {
                    
                    let resource = try self.decoder.decode(T.self, from: data)
                    
                    completion(Response(request: request, data: data, response: httpResponse, result: .success(resource)))
                    
                } catch {
                    
                    completion(Response(request: request, data: data, response: httpResponse, result: .failure(error)))
                }
            } else {
                completion(Response(request: request, data: data, response: httpResponse, result: .failure(AzureVisionClientError.unknown)))
            }
        }.resume()
    }
    
    
    // MARK: -
    
    fileprivate func dataRequest(for api: Api, withQuery query: String? = nil, andHeaders headers: [String:String]? = nil) throws -> URLRequest {
        return try self._dataRequest(for: api, withQuery: query, andHeaders: headers)
    }
    
    
    fileprivate func dataRequest<T:Codable>(for api: Api, withBody body: T? = nil, withQuery query: String? = nil, andHeaders headers: [String:String]? = nil) throws -> URLRequest {
        
        if let body = body {
            
            let bodyData = try encoder.encode(body)
            
            return try self._dataRequest(for: api, withBody: bodyData, withQuery: query, andHeaders: headers)
        }
        
        return try self._dataRequest(for: api, withQuery: query, andHeaders: headers)
    }
    
    
    fileprivate func dataRequest(for api: Api, withBody body: Data? = nil, withQuery query: String? = nil, andHeaders headers: [String:String]? = nil) throws -> URLRequest {
        
        if let body = body {
            
            return try self._dataRequest(for: api, withBody: getMultipartFormBody(body, boundary: boundary), withQuery: query, andHeaders: headers)
        }
        
        return try self._dataRequest(for: api, withQuery: query, andHeaders: headers)
    }
    
    
    fileprivate func _dataRequest(for api: Api, withBody body: Data? = nil, withQuery query: String? = nil, andHeaders headers: [String:String]? = nil) throws -> URLRequest {
        
        //guard api.hasValidIds else { throw AzureVisionClientError.invalidIds }
        
        guard let url = usingContainer ? api.url(forHost: containerHost) : api.url(forRegion: subscriptionRegion, withQuery: query) else { throw AzureVisionClientError.urlError(usingContainer ? api.urlString(forHost: containerHost) : api.urlString(forRegion: subscriptionRegion, withQuery: query)) }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = api.method.rawValue
        
        request.addValue(api.contentType(boundary), forHTTPHeaderField: HttpHeader.contentType.rawValue)
        
        if !usingContainer {
            request.addValue(subscriptionKey, forHTTPHeaderField: HttpHeader.subscriptionKey.rawValue)
        }
        
        if let headers = headers {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        request.httpBody = body
        
        return request
    }
    
    
    // MARK: - JSON Encoder/Decoder
    
    static let iso8601Formatter: DateFormatter = {
        
        let formatter = DateFormatter()
        
        formatter.calendar      = Calendar(identifier: .iso8601)
        formatter.locale        = Locale(identifier: "en_US_POSIX")
        formatter.timeZone      = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        return formatter
    }()
    
    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(iso8601Formatter)
        return encoder
    }()
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(iso8601Formatter)
        return decoder
    }()
}


// MARK: -

public enum AzureVisionClientError : Error {
    case unknown
    case invalidIds
    case noConversation
    case urlError(String)
    case decodeError(DecodingError)
    case encodingError(EncodingError)
    //case apiError(ApiError?)
}
