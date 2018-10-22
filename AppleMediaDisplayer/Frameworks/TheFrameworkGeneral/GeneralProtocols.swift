//
//  GeneralProtocols.swift
//  ClassMate
//
//  Created by me on 11/26/17.
//  Copyright © 2017 b. All rights reserved.
//

import Foundation
import UIKit

protocol Copyable {
    
    init()
    
    func copy() -> Self
}
