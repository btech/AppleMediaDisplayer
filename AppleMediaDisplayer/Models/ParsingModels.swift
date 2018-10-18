//
//  ParsingModels.swift
//  AppleMediaDisplayer
//
//  Created by me on 10/18/18.
//  Copyright © 2018 me. All rights reserved.
//

import Foundation

/// For retrieving `Media`
struct FeedWrapper: Decodable {
    
    let feed: Feed
}
struct Feed: Decodable {
    
    let results: [Media]
}

/// For retrieving `Media` preview urls
struct ResultsWrapper: Decodable {
    
    let results: [ResultObject]
}
class ResultObject: Decodable {
    
    private(set) var previewURL: URL? = nil
    
    enum CodingKeys : String, CodingKey {
        
        case previewURL = "previewUrl"
    }
}
