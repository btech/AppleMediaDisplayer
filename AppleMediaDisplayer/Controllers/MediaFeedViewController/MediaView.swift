//
//  MediaView.swift
//  AppleMediaDisplayer
//
//  Created by me on 10/18/18.
//  Copyright © 2018 me. All rights reserved.
//

import Foundation
import UIKit

fileprivate class URLImageView: UIImageView {
    
    private var url: URL?
    
    func loadImage(from url: URL) {
        
        image = nil; self.url = url
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard self.url == url && error.isNil else { return }
            
            DispatchQueue.main.async { self.image = UIImage(data: data!) }
            
            }.resume()
    }
}
