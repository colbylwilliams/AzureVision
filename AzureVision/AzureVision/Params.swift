//
//  Params.swift
//  AzureVision
//
//  Created by Colby L Williams on 9/14/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation


public struct AnalyzeParams {
    
    // A string indicating what visual feature types to return. Multiple values should be comma-separated.
    //
    // Valid visual feature types include:
    //   - Categories - categorizes image content according to a taxonomy defined in documentation.
    //   - Tags - tags the image with a detailed list of words related to the image content.
    //   - Description - describes the image content with a complete sentence in supported languages.
    //   - Faces - detects if faces are present. If present, generate coordinates, gender and age.
    //   - ImageType - detects if image is clipart or a line drawing.
    //   - Color - determines the accent color, dominant color, and whether an image is black&white.
    //   - Adult - detects if the image is pornographic in nature (depicts nudity or a sex act).  Sexually suggestive content is also detected.
    public enum Categories: String {
        case imageType      = "ImageType"
        case faces          = "Faces"
        case adult          = "Adult"
        case categories     = "Categories"
        case color          = "Color"
        case tags           = "Tags"
        case description    = "Description"
        
        static let name = "visualFeatures"
    }
    
    
    // A string indicating which domain-specific details to return. Multiple values should be comma-separated.
    //
    // Valid visual feature types include:
    //  - Celebrities - identifies celebrities if detected in the image.
    //  - Landmarks - identifies landmarks if detected in the image.
    public enum Details: String {
        case celebrities = "Celebrities"
        case landmarks   = "Landmarks"
        
        static let name = "details"
    }
    
    
    // A string indicating which language to return. The service will return recognition results in specified language.
    // If this parameter is not specified, the default value is "en".
    public enum Language: String {
        case english            = "en" // default
        case japanese           = "ja"
        case portuguese         = "pt"
        case simplifiedChinese  = "zh"
        
        static let name = "language"
    }
}

public struct DescribeParams {
    
    public struct MaxCandidates {
        static let name = "maxCandidates"
    }
    
    // A string indicating which language to return. The service will return recognition results in specified language.
    // If this parameter is not specified, the default value is "en".
    public enum Language: String {
        case english            = "en" // default
        case japanese           = "ja"
        case portuguese         = "pt"
        case simplifiedChinese  = "zh"
        
        static var name = "language"
    }
}


struct ThumbnailParams {
    static let width = "width"
    static let height = "height"
    static let smartCropping = "smartCropping"
}


public struct OcrParams {
    
    struct DetectOrientation {
        static let name = "detectOrientation"
    }
    
    public enum Language: String {
        case autoDetect         = "unk"
        case chineseSimplified  = "zh-Hans"
        case chineseTraditional = "zh-Hant"
        case czech              = "cs"
        case danish             = "da"
        case dutch              = "nl"
        case english            = "en"
        case finnish            = "fi"
        case french             = "fr"
        case german             = "de"
        case greek              = "el"
        case hungarian          = "hu"
        case italian            = "it"
        case japanese           = "ja"
        case korean             = "ko"
        case norwegian          = "nb"
        case polish             = "pl"
        case portuguese         = "pt"
        case russian            = "ru"
        case spanish            = "es"
        case swedish            = "sv"
        case turkish            = "tr"
        case arabic             = "ar"
        case romanian           = "ro"
        case serbianCyrillic    = "sr-Cyrl"
        case serbianLatin       = "sr-Latn"
        case slovak             = "sk"
        
        static let name         = "language"
    }
}
