//
//  MenuViewCustomizable.swift
//  PagingMenuController
//
//  Created by Yusuke Kita on 5/23/16.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation
import UIKit

fileprivate let defaultHeight: CGFloat = 50
fileprivate let defaultDisplayMode: MenuDisplayMode = .infinite(widthMode: .flexible, scrollingMode: .scrollEnabled)

public protocol MenuViewCustomizable {
    
    var backgroundColor: UIColor { get }
    var selectedBackgroundColor: UIColor { get }
    var height: CGFloat { get }
    var animationDuration: TimeInterval { get }
    var deceleratingRate: CGFloat { get }
    var selectedItemCenter: Bool { get }
    var displayMode: MenuDisplayMode { get }
    var focusMode: MenuFocusMode { get }
    var dummyItemViewsSet: Int { get }
    var menuPosition: MenuPosition { get }
    var dividerImage: UIImage? { get }
    var itemTraits: [MenuItemViewCustomizable] { get }
}

struct MenuViewTraits: MenuViewCustomizable {
    
    let height: CGFloat
    let itemTraits: [MenuItemViewCustomizable]
    let displayMode: MenuDisplayMode
    
    init(height: CGFloat = defaultHeight, itemTraits: [MenuItemViewCustomizable], displayMode: MenuDisplayMode = defaultDisplayMode) {
        
        self.height = height; self.itemTraits = itemTraits; self.displayMode = displayMode
    }
}

public extension MenuViewCustomizable {
    
    var backgroundColor: UIColor { return UIColor.white }
    var selectedBackgroundColor: UIColor { return UIColor.white }
    var height: CGFloat { return defaultHeight }
    var animationDuration: TimeInterval { return 0.3 }
    var deceleratingRate: CGFloat { return UIScrollViewDecelerationRateFast }
    var selectedItemCenter: Bool { return true }
    var displayMode: MenuDisplayMode { return defaultDisplayMode }
    var focusMode: MenuFocusMode {
        
        return .underline(height: 3, color: UIColor.blue, horizontalPadding: 0, verticalPadding: 0)
    }
    var dummyItemViewsSet: Int { return 3 }
    var menuPosition: MenuPosition { return .top }
    var dividerImage: UIImage? { return nil }
}

public enum MenuDisplayMode {
    
    case standard(widthMode: MenuItemWidthMode, centerItem: Bool, scrollingMode: MenuScrollingMode)
    case segmentedControl
    case infinite(widthMode: MenuItemWidthMode, scrollingMode: MenuScrollingMode)
}

public enum MenuItemWidthMode {
    
    case flexible, fixed(width: CGFloat)
}

public enum MenuScrollingMode {
    
    case scrollEnabled, scrollEnabledAndBouces, pagingEnabled
}

public enum MenuFocusMode {
    
    case none
    case underline(height: CGFloat, color: UIColor, horizontalPadding: CGFloat, verticalPadding: CGFloat)
    case roundRect(radius: CGFloat, horizontalPadding: CGFloat, verticalPadding: CGFloat, selectedColor: UIColor)
}

public enum MenuPosition {
    
    case top, bottom
}
