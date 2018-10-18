//
//  MediaType.swift
//  AppleMediaDisplayer
//
//  Created by me on 10/17/18.
//  Copyright © 2018 me. All rights reserved.
//

import Foundation

class MediaType {
    
    let title: String
    let feedTypes: [FeedType]
    
    init(title: String, feedTypes: [FeedType]) {
        
        self.title = title; self.feedTypes = feedTypes
    }
}


