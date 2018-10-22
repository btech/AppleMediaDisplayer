//
//  Media.swift
//  AppleMediaDisplayer
//
//  Created by me on 10/18/18.
//  Copyright © 2018 me. All rights reserved.
//

import Foundation

class Media: Decodable {
    
    static let previewSourceBaseURL = "http://itunes.apple.com/us/lookup?id="
    
    private(set) var title: String = ""
    private(set) var creatorName: String = ""
    private(set) var imageURL: URL = URL(string: "google.com")!
    private(set) var previewURL: URL?
    private(set) var id: String = ""
    
    enum CodingKeys : String, CodingKey {
        
        case title = "name"
        case creatorName = "artistName"
        case imageURL = "artworkUrl100"
        case previewURL
        case id
    }
    
    func loadPreviewURL() {
        
        guard previewURL.isNil else { return }
        
        let previewSourceURL = URL(string: "\(Media.previewSourceBaseURL)\(id)")!
        URLSession.shared.dataTask(with: previewSourceURL) { [weak self] (data, response, error) in
            
            guard let strongSelf = self else { return }
            
            guard error.isNil else { print(error!.localizedDescription); return }
            
            DispatchQueue.main.async {
                
                let decodedData = data ?! { try? JSONDecoder().decode(ResultsWrapper.self, from: $0) }
                strongSelf.previewURL = decodedData?.results.first?.previewURL
            }
            
        }.resume()
    }
}
