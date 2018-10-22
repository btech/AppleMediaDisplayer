//
//  FeedType.swift
//  AppleMediaDisplayer
//
//  Created by me on 10/18/18.
//  Copyright © 2018 me. All rights reserved.
//

import Foundation

class FeedType {
    
    static let resultLength = 100
    static let baseURL = "https://rss.itunes.apple.com/api/v1/us"
    
    let title: String
    
    func url(mediaType: MediaType) -> URL {
        
        return URL(string: "\(FeedType.baseURL)/\(mediaType.title.asDirectory())/\(title.asDirectory())/all/\(FeedType.resultLength)/explicit.json")!
    }
    
    init(_ title: String) { self.title = title }
}

fileprivate extension String {
    
    func asDirectory() -> String {
        
        return self.lowercased().replacingOccurrences(of: " ", with: "-")
    }
}
