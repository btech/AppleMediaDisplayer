//
//  GeneralGlobals.swift
//  ClassMate
//
//  Created by me on 1/30/18.
//  Copyright © 2018 b. All rights reserved.
//

import Foundation
import UIKit

var statusBarHeight: CGFloat {
    
    let size = UIApplication.shared.statusBarFrame.size
    return min(size.width, size.height)
}

func typeName(of something: Any) -> String {
    
    return String(describing: type(of: something))
}

typealias Maybe = () -> Bool
func maybeChain(_ chain: [Maybe]) {
    
    for maybe in chain {
        
        if maybe() { return }
    }
}

func keyboardSize(from notification: NSNotification) -> CGSize? {
    
    return (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
}
