//
//  NetworkingInterface.swift
//  AppleMediaDisplayer
//
//  Created by me on 10/22/18.
//  Copyright © 2018 me. All rights reserved.
//

import Foundation

final class NetworkInterface {
    
    static let shared = NetworkInterface()
    
    public func load(_ feedType: FeedType,
                     of mediaType: MediaType,
                     _ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        URLSession.shared.dataTask(with: feedType.url(mediaType: mediaType)) { (data, response, error) in
            
            completion(data, response, error)
            
        }.resume()
    }
}
