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
    
    private let window: UIWindow = {
        
        $0.backgroundColor = UIColor.white; return $0
        
    }(UIWindow(frame: UIScreen.main.bounds))

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window.rootViewController = mediaTypesPagingController(for: mediaTypes)
        window.makeKeyAndVisible()
        
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
