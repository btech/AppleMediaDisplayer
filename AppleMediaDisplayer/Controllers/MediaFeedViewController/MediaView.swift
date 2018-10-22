//
//  MediaView.swift
//  AppleMediaDisplayer
//
//  Created by me on 10/18/18.
//  Copyright © 2018 me. All rights reserved.
//

import Foundation
import UIKit


class MediaView: UIView {
    
    private var media: Media?
    
    
    private let imageView: URLImageView = {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.widthAnchor.constraint(equalToConstant: 150).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        return $0
        
    }(URLImageView(frame: .zero))
    
    private let titleLabel: UILabel = {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.textAlignment = .center
        
        return $0
        
    }(UILabel(frame: .zero))
    
    private let creatorLabel: UILabel = {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.textAlignment = .center
        
        return $0
        
    }(UILabel(frame: .zero))
    
    
    func bind(with media: Media) {
        
        self.media = media
        
        imageView.loadImage(from: media.imageURL)
        titleLabel.text = media.title
        creatorLabel.text = media.creatorName
    }
    
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews([imageView, titleLabel, creatorLabel])
        
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: creatorLabel.topAnchor).isActive = true
        
        creatorLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        creatorLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        creatorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        creatorLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
