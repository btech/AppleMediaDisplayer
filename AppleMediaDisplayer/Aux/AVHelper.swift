//
//  AVHelper.swift
//  AppleMediaDisplayer
//
//  Created by me on 10/19/18.
//  Copyright © 2018 me. All rights reserved.
//

import Foundation
import AVKit


class AVHelper: NSObject {
    
    static let shared = AVHelper()
    
    
    var statusChangeListenerFor = [AVPlayerItem : (AVPlayerItemStatus) -> Void]()

    
    func prepareToPlay(assetAt url: URL, with player: AVPlayer, onStatusChanged: @escaping (AVPlayerItemStatus) -> Void) {
        
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        playerItem.addObserver(AVHelper.shared,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: UnsafeMutableRawPointer(bitPattern: 1)
        )
        statusChangeListenerFor[playerItem] = onStatusChanged
        
        player.replaceCurrentItem(with: playerItem)
    }
    
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        guard let playerItem = object as? AVPlayerItem, keyPath == #keyPath(AVPlayerItem.status) else {
            
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context); return
        }
        
        let status: AVPlayerItemStatus = {
            
            if let statusNumber = change?[.newKey] as? NSNumber {
                
                return AVPlayerItemStatus(rawValue: statusNumber.intValue)!
                
            } else { return .unknown }
        }()
        statusChangeListenerFor[playerItem]?(status)
    }
}
