//
//  MenuItemViewCustomizable.swift
//  PagingMenuController
//
//  Created by Yusuke Kita on 5/23/16.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation
import UIKit

public protocol MenuItemViewCustomizable {
    
    var horizontalMargin: CGFloat { get }
    var displayMode: MenuItemDisplayMode { get }
}

public struct MenuItemViewTraits: MenuItemViewCustomizable {
    
    public let horizontalMargin: CGFloat
    public let displayMode: MenuItemDisplayMode
    
    init(text: String,
         font: UIFont = MenuItemText.defaultFont,
         selectedFont: UIFont = MenuItemText.defaultFont,
         horizontalMargin: CGFloat = 20) {
        
        self.horizontalMargin = horizontalMargin
        displayMode = .text(title: MenuItemText(text: text, font: font, selectedFont: selectedFont))
    }
}

public extension MenuItemViewCustomizable {
    
    var horizontalMargin: CGFloat { return 20 }
    
    var displayMode: MenuItemDisplayMode { return .text(title: MenuItemText()) }
}

public enum MenuItemDisplayMode {
    
    case text(title: MenuItemText)
    case multilineText(title: MenuItemText, description: MenuItemText)
    case image(image: UIImage, selectedImage: UIImage?)
    case custom(view: UIView)
}

public struct MenuItemText {
    
    public static let defaultFont = UIFont.systemFont(ofSize: 16)
    
    let text: String
    let color: UIColor
    let selectedColor: UIColor
    let font: UIFont
    let selectedFont: UIFont
    
    public init(text: String = "Menu",
                color: UIColor = UIColor.lightGray,
                selectedColor: UIColor = UIColor.black,
                font: UIFont = defaultFont,
                selectedFont: UIFont = defaultFont) {
        
        self.text = text
        self.color = color
        self.selectedColor = selectedColor
        self.font = font
        self.selectedFont = selectedFont
    }
}
