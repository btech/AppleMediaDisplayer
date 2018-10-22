//
//  CMediaFeed.swift
//  AppleMediaDisplayer
//
//  Created by me on 10/17/18.
//  Copyright © 2018 me. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class CMediaFeed: UITableViewController {
    
    private let feedType: FeedType
    
    private var media: [Media]? { didSet { self.tableView.reloadData() } }
    
    private let playerController: AVPlayerViewController = {
        
        $0.player = AVPlayer(playerItem: nil); $0.entersFullScreenWhenPlaybackBegins = true
        
        return $0
        
    }(AVPlayerViewController(nibName: nil, bundle: nil))
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MediaTVC.self)", for: indexPath as IndexPath) as! MediaTVC
        cell.bind(with: media![indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        media?[indexPath.row].previewURL >? {
            
            AVHelper.shared.prepareToPlay(assetAt: $0, with: playerController.player!) { [weak self] in
                
                guard let strongSelf = self else { return }
                
                switch $0 {
                    
                    case .readyToPlay:
                    
                        strongSelf.present(strongSelf.playerController, animated: true) { strongSelf.playerController.player!.play() }
                    
                    case .failed: break
                    
                    case .unknown: break
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return media?.count ?? 0
    }
    
    
    init(feedType: FeedType, mediaType: MediaType) {
        
        self.feedType = feedType
        
        super.init(style: .plain)
        
        tableView.register(MediaTVC.self, forCellReuseIdentifier: "\(MediaTVC.self)")
        
        NetworkInterface.shared.load(feedType, of: mediaType) { [weak self] (data, response, error) in
            
            guard let strongSelf = self else { return }
            
            guard error.isNil else { print(error!.localizedDescription); return }
            
            DispatchQueue.main.async {
                
                let decodedData = data ?! { try? JSONDecoder().decode(FeedWrapper.self, from: $0) }
                strongSelf.media = decodedData?.feed.results
                strongSelf.media?.forEach { $0.loadPreviewURL() }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
