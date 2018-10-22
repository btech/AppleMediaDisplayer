//
//  AppDelegate.swift
//  AppleMediaDisplayer
//
//  Created by me on 10/16/18.
//  Copyright © 2018 me. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}
}

fileprivate func mediaTypesPagingController(for mediaTypes: [MediaType]) -> PagingMenuController {
    
    let menuItemTraits = mediaTypes.map { return MenuItemViewTraits(text: $0.title) }
    let menuTraits = MenuViewTraits(itemTraits: menuItemTraits)
    let pagingControllers = mediaTypes.map { feedTypesPagingController(for: $0) }
    
    return PagingMenuController(traits: PagingMenuControllerTraits(pagingControllers: pagingControllers, menuTraits: menuTraits))
}

fileprivate func feedTypesPagingController(for mediaType: MediaType) -> PagingMenuController {
    
    let menuViewHeight: CGFloat = 40
    
    let menuItemTraits = mediaType.feedTypes.map { return MenuItemViewTraits(text: $0.title) }
    let menuTraits = MenuViewTraits(height: menuViewHeight,
                                    itemTraits: menuItemTraits,
                                    displayMode: .standard(widthMode: .flexible,
                                                           centerItem: true,
                                                           scrollingMode: .scrollEnabled
                                    )
    )
    let pagingControllers = mediaType.feedTypes.map { CMediaFeed(feedType: $0, mediaType: mediaType) }
    
    return PagingMenuController(traits: PagingMenuControllerTraits(pagingControllers: pagingControllers, menuTraits: menuTraits))
}
