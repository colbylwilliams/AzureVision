//
//  Models.swift
//  AzureVision
//
//  Created by Colby L Williams on 9/13/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation


public struct AnalyzeResult: Codable {
    public let categories: [Category]
    public let adult: Adult?
    public let tags: [Tag]?
    public let description: Description?
    public let requestId: UUID?
    public let metadata: Metadata?
    public let faces: [Face]?
    public let color: Color?
    public let imageType: ImageType?
}

public struct DescribeResult: Codable {
    public let description: Description?
    public let requestId: UUID?
    public let metadata: Metadata?
}

public struct OcrResult: Codable {
    public let language: String?
    public let textAngle: Double?
    public let orientation: String?
    public let regions: [Region]?
}

public struct Region: Codable {
    public let boundingBox: String?
    public let lines: [Line]?
}

public struct Line: Codable {
    public let boundingBox: String?
    public let words: [Word]?
}

public struct Word: Codable {
    public let boundingBox, text: String?
}


public struct Adult: Codable {
    public let isAdultContent, isRacyContent: Bool?
    public let adultScore, racyScore: Double?
}

public struct Category: Codable {
    public let name: String?
    public let score: Double?
    public let detail: Detail??
}

public struct Detail: Codable {
    public let celebrities: [Celebrity]?
    public let landmarks: [Tag]?
}

public struct Celebrity: Codable {
    public let name: String?
    public let faceRectangle: FaceRectangle?
    public let confidence: Double?
}

public struct FaceRectangle: Codable {
    public let left, top, width, height: Int?
}

public struct Tag: Codable {
    public let name: String?
    public let confidence: Double?
}

public struct Color: Codable {
    public let dominantColorForeground, dominantColorBackground: String?
    public let dominantColors: [String]?
    public let accentColor: String?
    public let isBwImg: Bool?
}

public struct Description: Codable {
    public let tags: [String]?
    public let captions: [Caption]?
}

public struct Caption: Codable {
    public let text: String?
    public let confidence: Double?
}

public struct Face: Codable {
    public let age: Int?
    public let gender: String?
    public let faceRectangle: FaceRectangle?
}

public struct ImageType: Codable {
    public let clipArtType: ClipArtType
    public let lineDrawingType: LineDrawingType
    
    public enum ClipArtType: Int, Codable {
        case nonClipart     = 0
        case ambiguous      = 1
        case normalClipart  = 2
        case goodClipart    = 3
    }

    public enum LineDrawingType: Int, Codable {
        case nonLineDrawing = 0
        case lineDrawing    = 1
    }
}

public struct Metadata: Codable {
    public let width, height: Int?
    public let format: String?
}
