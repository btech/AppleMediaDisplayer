//
//  Operators.swift
//  illumination
//
//  Created by me on 7/1/17.
//  Copyright © 2017 b. All rights reserved.
//

import Foundation

// Assign only if the value being assigned is not nil
infix operator ?= : AssignmentPrecedence
@discardableResult
func ?= <T: Any>(lhs: inout T, rhs: T?)->Bool {
    
    guard rhs != nil else { return false }

    lhs = rhs!; return true
}

// Perform += only if rhs is not nil
infix operator ?+= : AssignmentPrecedence
@discardableResult
func ?+= <T: Numeric>(lhs: inout T, rhs: T?)->Bool {
    
    guard rhs != nil else { return false }

    lhs += rhs!; return true
}

// Perform -= only if rhs is not nil
infix operator ?-= : AssignmentPrecedence
@discardableResult
func ?-= <T: Numeric>(lhs: inout T, rhs: T?)->Bool {
    
    guard rhs != nil else { return false }

    lhs -= rhs!; return true
}

// Execute right only if left is not nil
infix operator >? : NilCoalescingPrecedence
func >? <T>(lhs: T?, rhs: (T) -> Void) {
    
    guard lhs != nil else { return }

    rhs(lhs!)
}

// Execute right only if left is nil
infix operator ?> : NilCoalescingPrecedence
func ?> (left: Any?, right: @autoclosure ()->Void) {
    if left == nil {right()}
}
func ?> (left: Any?, right: ()->Void) {
    if left == nil {right()}
}

// Return the result of rhs with lhs as a parameter if lhs is not nil, else return nil
infix operator ?! : NilCoalescingPrecedence
func ?! <T, G>(lhs: T?, rhs: (T) -> G?) -> G? {
    
    guard lhs != nil else {   return nil   }
    
    return rhs(lhs!)
}

postfix operator ++
@discardableResult
postfix func ++(x: inout Int) -> Int {
    x += 1
    return (x - 1)
}

postfix operator --
@discardableResult
postfix func --(x: inout Int) -> Int {
    x -= 1
    return (x + 1)
}

private let epsilon = 1e-4
infix operator ~== : ComparisonPrecedence
public func ~== (left: Double?, right: Double?) -> Bool {
    
    guard left != nil && right != nil else { return left == right }
    
    return fabs(left!.distance(to: right!)) <= epsilon
}
infix operator ~!= : ComparisonPrecedence
public func ~!= (left: Double?, right: Double?) -> Bool {
    return !(left ~== right)
}
infix operator ~<= : ComparisonPrecedence
public func ~<= (left: Double, right: Double) -> Bool {
    return (left ~== right) || (left ~< right)
}
infix operator ~>= : ComparisonPrecedence
public func ~>= (left: Double, right: Double) -> Bool {
    return (left ~== right) || (left ~> right)
}
infix operator ~< : ComparisonPrecedence
public func ~< (left: Double, right: Double) -> Bool {
    return left.distance(to: right) > epsilon
}
infix operator ~> : ComparisonPrecedence
public func ~> (left: Double, right: Double) -> Bool {
    return left.distance(to: right) < -epsilon
}
