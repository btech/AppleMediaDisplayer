//
//  MediaTVC.swift
//  AppleMediaDisplayer
//
//  Created by me on 10/18/18.
//  Copyright © 2018 me. All rights reserved.
//

import Foundation
import UIKit

class MediaTVC: UITableViewCell {
    
    private let mediaView = MediaView()
    
    
    func bind(with media: Media) { mediaView.bind(with: media) }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(mediaView)
        mediaView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        mediaView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mediaView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        mediaView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
