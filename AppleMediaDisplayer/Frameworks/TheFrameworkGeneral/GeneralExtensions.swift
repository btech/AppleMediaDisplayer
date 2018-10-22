//
//  GeneralExtensions.swift
//  ClassMate
//
//  Created by me on 1/19/17.
//  Copyright © 2017 b. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element:AnyObject {
    
    mutating func remove(_ object: Element) {
        while let index = index(where: {$0 === object}) {
            remove(at: index)
        }
    }
    
    mutating func removeAll(_ array:[Element]){
        for element in array {
            remove(element)
        }
    }
}

private var maxLengths = [Weak<UITextField>: Int]()
extension UITextField {
    
    var isEmpty: Bool { return text.isEmpty }
    
    @IBInspectable var maxLength: Int {
        
        get { return maxLengths[Weak(self), default: Int.max] }
        
        set {
        
            maxLengths[Weak(self)] = newValue
            addTarget(self, action: #selector(limitLength), for: .editingChanged)
        }
    }
    
    @objc func limitLength() {
        
        guard !text.isNil && text!.count > maxLength else { return }
        
        let oldSelection = selectedTextRange
        text = String(text![..<text!.index(text!.startIndex, offsetBy: maxLength)])
        selectedTextRange = oldSelection
    }
}
extension Dictionary where Key == String {
    
    func toAttributedStringKeys() -> [NSAttributedStringKey: Value] {
        return Dictionary<NSAttributedStringKey, Value>(uniqueKeysWithValues: map {
            key, value in (NSAttributedStringKey(key), value)
        })
    }
}

extension UILabel {
    
    var isEmpty: Bool { return text.isEmpty }
}

private var highlightedBackgroundColors = [UIButton:UIColor]()
private var unhighlightedBackgroundColors = [UIButton:UIColor]()
extension UIButton {
    
    @IBInspectable var highlightedBackgroundColor: UIColor? {
        get {
            return highlightedBackgroundColors[self]
        }
        
        set {
            highlightedBackgroundColors[self] = newValue
        }
    }
    
    override open var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        
        set {
            unhighlightedBackgroundColors[self] = newValue
            super.backgroundColor = newValue
        }
    }
    
    override open var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        
        set {
            if highlightedBackgroundColor != nil {
                super.backgroundColor = newValue ? highlightedBackgroundColor : unhighlightedBackgroundColors[self]
            }
            super.isHighlighted = newValue
        }
    }
}

extension UIViewController {
    
    func getFirstResponder()->UIView? {
        return view.getFirstResponder()
    }
}

extension UIView {
    
    var selfCenter: CGPoint { return CGPoint(x: frame.size.width / 2, y: frame.size.height / 2) }
    
    var rootView: UIView? {
        
        // Guard from view not having a superview
        guard var rootView = superview else {   return nil   }
        
        // Get the root view
        while rootView.superview != nil {
            
            rootView = rootView.superview!
        }
        
        return rootView
    }
    
    func getFirstResponder()->UIView? {
        if isFirstResponder {
            return self
        } else if subviews.count != 0 {
            for subview in subviews {
                if let firstResponder = subview.getFirstResponder() {
                    return firstResponder
                }
            }
        }
        return nil
    }
    
    @discardableResult
    func addBorder(edges: UIRectEdge, color: UIColor = UIColor.black, thickness: CGFloat = 1.0) -> [UIView] {
        
        var borders = [UIView]()
        
        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["bottom": bottom]))
            borders.append(bottom)
        }
        
        return borders
    }
    
    @objc func addSubviews(_ views: [UIView]) { views.forEach { addSubview($0) } }
    
    func ascendant(where predicate: (UIView) -> Bool) -> UIView? {
        
        var nextSuperview = superview
        while !nextSuperview.isNil { if predicate(nextSuperview!) { return nextSuperview }; nextSuperview = nextSuperview!.superview }
        
        return nil
    }
    
    func selfOrAscendant(where predicate: (UIView) -> Bool) -> UIView? {
        
        guard !predicate(self) else { return self }; return ascendant(where: predicate)
    }
}

extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}

extension UIStackView {
    
    func removeAll() {
        for view in subviews {
            remove(subview: view)
        }
    }
    
    func remove(subview: UIView) {
        removeArrangedSubview(subview)
        subview.removeFromSuperview()
    }    
}

extension UIImage {
    
    class func circle(diameter: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
    
}

extension UIImageView {
    
    @IBInspectable var imageColor: UIColor? {
        set (newValue) {
            if let image = image {
                if newValue != nil {
                    self.image = image.withRenderingMode(.alwaysTemplate)
                    tintColor = newValue
                } else {
                    self.image = image.withRenderingMode(.alwaysOriginal)
                    tintColor = UIColor.clear
                }
            }
        }
        get {
            return tintColor
        }
    }
}

extension UIFont {
    
    func withTraits(traits: UIFontDescriptorSymbolicTraits...) -> UIFont? {
        guard let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits)) else {return self}
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    func withoutTraits(traits: UIFontDescriptorSymbolicTraits...)->UIFont? {
        var symbolicTraits = fontDescriptor.symbolicTraits
        for trait in traits {
            symbolicTraits.remove(trait)
        }
        guard let descriptor = fontDescriptor.withSymbolicTraits(symbolicTraits) else {return self}
        return UIFont(descriptor: descriptor, size: 0)
    }
    
}

/// CAAnimation Delegation class implementation
class AnimationDelegate: NSObject, CAAnimationDelegate {
    /// start: A block (closure) object to be executed when the animation starts. This block has no return value and takes no argument.
    var start: (() -> Void)?
    
    /// completion: A block (closure) object to be executed when the animation ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished.
    var completion: ((Bool) -> Void)?
    
    /// startTime: animation start date
    private var startTime: Date!
    private var animationDuration: TimeInterval!
    private var animatingTimer: Timer!
    
    /// animating: A block (closure) object to be executed when the animation is animating. This block has no return value and takes a single CGFloat argument that indicates the progress of the animation (From 0 ..< 1)
    var animating: ((CGFloat) -> Void)? {
        willSet {
            if animatingTimer == nil {
                animatingTimer = Timer(timeInterval: 0, target: self, selector: "animationIsAnimating:", userInfo: nil, repeats: true)
           }
        }
    }
    
    /**
     Called when the animation begins its active duration.
     
     - parameter theAnimation: the animation about to start
     */
    func animationDidStart(_ anim: CAAnimation) {
        start?()
        if animating != nil {
            animationDuration = anim.duration
            startTime = Date()
            RunLoop.current.add(animatingTimer, forMode: RunLoopMode.defaultRunLoopMode)
        }
    }
    
    /**
     Called when the animation completes its active duration or is removed from the object it is attached to.
     
     - parameter theAnimation: the animation about to end
     - parameter finished:     A Boolean value indicates whether or not the animations actually finished.
     */
    func animationDidStop(_ anim: CAAnimation, finished: Bool) {
        completion?(finished)
        animatingTimer?.invalidate()
    }
    
    /**
     Called when the animation is executing
     
     - parameter timer: timer
     */
    func animationIsAnimating(timer: Timer) {
        let progress = CGFloat(NSDate().timeIntervalSince(startTime) / animationDuration)
        if progress <= 1.0 {
            animating?(progress)
        }
    }
}

extension CAAnimation {
    /// A block (closure) object to be executed when the animation starts. This block has no return value and takes no argument.
    public var start: (() -> Void)? {
        set {
            if let animationDelegate = (delegate as? AnimationDelegate) {
                animationDelegate.start = newValue
            } else {
                let animationDelegate = AnimationDelegate()
                animationDelegate.start = newValue
                delegate = animationDelegate
            }
        }
        
        get {
            if let animationDelegate = delegate as? AnimationDelegate {
                return animationDelegate.start
            }
            
            return nil
        }
    }
    
    /// A block (closure) object to be executed when the animation ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished.
    public var completion: ((Bool) -> Void)? {
        set {
            if let animationDelegate = (delegate as? AnimationDelegate) {
                animationDelegate.completion = newValue
            } else {
                let animationDelegate = AnimationDelegate()
                animationDelegate.completion = newValue
                delegate = animationDelegate
            }
        }
        
        get {
            if let animationDelegate = (delegate as? AnimationDelegate) {
                return animationDelegate.completion
            }
            
            return nil
        }
    }
    
    /// A block (closure) object to be executed when the animation is animating. This block has no return value and takes a single CGFloat argument that indicates the progress of the animation (From 0 ..< 1)
    public var animating: ((CGFloat) -> Void)? {
        set {
            if let animationDelegate = (delegate as? AnimationDelegate) {
                animationDelegate.animating = newValue
            } else {
                let animationDelegate = AnimationDelegate()
                animationDelegate.animating = newValue
                delegate = animationDelegate
            }
        }
        
        get {
            if let animationDelegate = (delegate as? AnimationDelegate) {
                return animationDelegate.animating
            }
            
            return nil
        }
    }
    
    /// Alias to `animating`
    public var progress: ((CGFloat) -> Void)? {
        set {
            animating = newValue
        }
        
        get {
            return animating
        }
    }
}

public extension CALayer {
    /**
     Add the specified animation object to the layer’s render tree. Could provide a completion closure.
     
     - parameter anim:       The animation to be added to the render tree. This object is copied by the render tree, not referenced. Therefore, subsequent modifications to the object are not propagated into the render tree.
     - parameter key:        A string that identifies the animation. Only one animation per unique key is added to the layer. The special key kCATransition is automatically used for transition animations. You may specify nil for this parameter.
     - parameter completion: A block object to be executed when the animation ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called. Default value is nil.
     */
    func add(anim: CAAnimation, forKey key: String?, withCompletion completion: ((Bool) -> Void)?) {
        anim.completion = completion
        add(anim, forKey: key)
    }
}

extension String {
    
    func count(occurences s: String)->Int {
        return components(separatedBy: s).count - 1
    }
    
    func firstUppercased() -> String {
    
        // Guard from string being empty
        guard let first = first else {return ""}
        
        return String(first).uppercased() + dropFirst()
    }
    
    func extractInt() -> Int? {
        
        let components = self.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let intString = components.joined()
        
        return Int(intString)
    }
}

extension Optional where Wrapped == String {
    
    var isEmpty: Bool { return self == nil || self!.count == 0 }
    
    var emptyIfNil: String { return isNil ? "" : self! }
    
    func ifNotNil(_ editor: (String) -> String) -> String {
        
        return isNil ? "" : editor(self!)
    }
}

extension Optional {
    
    var isNil: Bool { return self == nil }
}

extension CGSize {
    
    static let greatestFiniteSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
}

extension UIScreen {
    
    var maxLength: CGFloat {return max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)}
    var minLength: CGFloat {return min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)}
    var portraitSize: CGSize {  return CGSize(width: minLength, height: maxLength)   }
    var landscapeSize: CGSize {   return CGSize(width: maxLength, height: minLength)   }
    
    var isInPortraitMode: Bool { return UIScreen.main.bounds.width < UIScreen.main.bounds.height }

    var safeAreaWidth: CGFloat {
        
        guard !isInPortraitMode else { return minLength }
        
        let window = UIApplication.shared.keyWindow
        let leftInset = window?.safeAreaInsets.left ?? 0
        let rightInset = window?.safeAreaInsets.right ?? 0
        
        return maxLength - leftInset - rightInset
    }
    
    var safeAreaHeight: CGFloat {
        
        guard isInPortraitMode else { return minLength }
        
        let window = UIApplication.shared.keyWindow
        let topInset = window?.safeAreaInsets.top ?? 0
        let bottomInset = window?.safeAreaInsets.bottom ?? 0
        
        return maxLength - topInset - bottomInset
    }
}

extension Int {
    
    func forEach(_ closure: () -> Void) {
        
        guard self >= 0 else { fatalError("Cannot execute a `forEach(_:)` on a negative `Int`") }
        
        (0 ..< self).forEach { (Int) -> Void in closure() }
    }
}

extension Double {
    
    var integerDigitCount: Int { return Int(log10(self)) + 1 }
    
    func rounded(toNthPlace n: Double) throws -> Double {
        
        // Guard from nth place not being a power of 10 >= 1
        guard n > 0 && log10(n).truncatingRemainder(dividingBy: 1) == 0 else {
            
            throw InvalidArgumentError()
        }
        
        return Darwin.round(self * n) / n
    }
}

func removeTrailing0s(_ d: Double) -> String {
    
    if d.truncatingRemainder(dividingBy: 1) == 0 {
        
        return String(Int(d))
        
    } else {
        
        let s = String(d)
        
        if d < 1 {
            
            return s.substring(from: s.index(s.startIndex, offsetBy: 1))
            
        } else {
            
            return s
        }
    }
}

extension Bool {
    
    static func rand()->Bool {
        return arc4random_uniform(2) == 0
    }
    
    static func rand(odds: Int32)->Bool {
        return arc4random_uniform(UInt32(odds + 1)) != 0
    }
}

// String extension to support pluralizing and singularizing a word
extension String {
    
    private static var uncountables = [ "access", "accommodation", "adulthood", "advertising", "advice",
                                        "aggression", "aid", "air", "alcohol", "anger", "applause",
                                        "arithmetic", "art", "assistance", "athletics", "attention",
                                        "bacon", "baggage", "ballet", "beauty", "beef", "beer", "biology",
                                        "botany", "bread", "butter", "carbon", "cash", "chaos", "cheese",
                                        "chess", "childhood", "clothing", "coal", "coffee", "commerce",
                                        "compassion", "comprehension", "content", "corruption", "cotton",
                                        "courage", "currency", "dancing", "danger", "data", "delight",
                                        "dignity", "dirt", "distribution", "dust", "economics", "education",
                                        "electricity", "employment", "engineering", "envy", "equipment",
                                        "ethics", "evidence", "evolution", "faith", "fame", "fish", "flour", "flu",
                                        "food", "freedom", "fuel", "fun", "furniture", "garbage", "garlic",
                                        "genetics", "gold", "golf", "gossip", "grammar", "gratitude", "grief",
                                        "ground", "guilt", "gymnastics", "hair", "happiness", "hardware",
                                        "harm", "hate", "hatred", "health", "heat", "height", "help",
                                        "honesty", "honey", "hospitality", "housework", "humour", "hunger",
                                        "hydrogen", "ice", "ice", "cream", "importance", "inflation", "information",
                                        "injustice", "innocence", "iron", "irony", "jealousy", "jelly", "judo",
                                        "karate", "kindness", "knowledge", "labour", "lack", "laughter", "lava",
                                        "leather", "leisure", "lightning", "linguistics", "litter", "livestock",
                                        "logic", "loneliness", "luck", "luggage", "machinery", "magic",
                                        "management", "mankind", "marble", "mathematics", "mayonnaise",
                                        "measles", "meat", "methane", "milk", "money", "mud", "music", "nature",
                                        "news", "nitrogen", "nonsense", "nurture", "nutrition", "obedience",
                                        "obesity", "oil", "oxygen", "passion", "pasta", "patience", "permission",
                                        "physics", "poetry", "pollution", "poverty", "power", "pronunciation",
                                        "psychology", "publicity", "quartz", "racism", "rain", "relaxation",
                                        "reliability", "research", "respect", "revenge", "rice", "rubbish",
                                        "rum", "salad", "satire", "seaside", "shame", "shopping", "silence",
                                        "sleep", "smoke", "smoking", "snow", "soap", "software", "soil",
                                        "sorrow", "soup", "speed", "spelling", "steam", "stuff", "stupidity",
                                        "sunshine", "symmetry", "tennis", "thirst", "thunder", "toast",
                                        "tolerance", "toys", "traffic", "transporation", "travel", "trust", "understanding",
                                        "unemployment", "unity", "validity", "veal", "vengeance", "violence"
    ]
    
    private static var unchangeables = ["sheep", "deer", "moose", "swine", "bison", "corps", "means", "series",
                                        "scissors", "species"
    ]
    
    private static let pluralityTemplates: [(singularPrefix: String, pluralPrefix: String)] = {
        
        var templates = [(singularPrefix: String, pluralPrefix: String)]()
        templates.append((singularPrefix: "$", pluralPrefix:"$1s"))
        templates.append((singularPrefix: "s$", pluralPrefix:"$1ses"))
        templates.append((singularPrefix: "(t|r|l|b)y$", pluralPrefix:"$1ies"))
        templates.append((singularPrefix: "x$", pluralPrefix:"$1xes"))
        templates.append((singularPrefix: "(sh|zz|ss)$", pluralPrefix:"$1es"))
        templates.append((singularPrefix: "(ax)is", pluralPrefix: "$1es"))
        templates.append((singularPrefix: "(cact|nucle|alumn|bacill|fung|radi|stimul|syllab)us$", pluralPrefix:"$1i"))
        templates.append((singularPrefix: "(corp)us$", pluralPrefix:"$1ora"))
        templates.append((singularPrefix: "sis$", pluralPrefix:"$1ses"))
        templates.append((singularPrefix: "ch$", pluralPrefix:"$1ches"))
        templates.append((singularPrefix: "o$", pluralPrefix:"$1os"))
        templates.append((singularPrefix: "(buffal|carg|mosquit|torped|zer|vet|her|ech)o$", pluralPrefix:"$1oes"))
        templates.append((singularPrefix: "fe$", pluralPrefix:"$1ves"))
        templates.append((singularPrefix: "(thie)f$", pluralPrefix:"$1ves"))
        templates.append((singularPrefix: "oaf$", pluralPrefix:"$1oaves"))
        templates.append((singularPrefix: "um$", pluralPrefix:"$1a"))
        templates.append((singularPrefix: "ium$", pluralPrefix:"$1ia"))
        templates.append((singularPrefix: "oof$", pluralPrefix:"$1ooves"))
        templates.append((singularPrefix: "(nebul)a", pluralPrefix:"$1ae"))
        templates.append((singularPrefix: "(criteri|phenomen)on$", pluralPrefix:"$1a"))
        templates.append((singularPrefix: "(potat|tomat|volcan)o$", pluralPrefix:"$1oes"))
        templates.append((singularPrefix: "^(|wo|work|fire)man$", pluralPrefix: "$1men"))
        templates.append((singularPrefix: "(f)oot$", pluralPrefix: "$1eet"))
        templates.append((singularPrefix: "lf$", pluralPrefix: "$1lves"))
        templates.append((singularPrefix: "(t)ooth$", pluralPrefix: "$1eeth"))
        templates.append((singularPrefix: "(g)oose$", pluralPrefix: "$1eese"))
        templates.append((singularPrefix: "^(c)hild$", pluralPrefix: "$1hildren"))
        templates.append((singularPrefix: "^(o)x$", pluralPrefix: "$1xen"))
        templates.append((singularPrefix: "^(p)erson$", pluralPrefix: "$1eople"))
        templates.append((singularPrefix: "(m|l)ouse$", pluralPrefix: "$1ice"))
        templates.append((singularPrefix: "^(d)ie$", pluralPrefix: "$1ice"))
        templates.append((singularPrefix: "^(alg|vertebr|vit)a$", pluralPrefix: "$1ae"))
        templates.append((singularPrefix: "^(a)lumna$", pluralPrefix: "$1lumnae"))
        templates.append((singularPrefix: "^(a)pparatus$", pluralPrefix: "$1pparatuses"))
        templates.append((singularPrefix: "^(ind)ex$", pluralPrefix: "$1ices"))
        templates.append((singularPrefix: "^(append|matr)ix$", pluralPrefix: "$1ices"))
        templates.append((singularPrefix: "^(b|tabl)eau$", pluralPrefix: "$1eaux"))
        templates.append((singularPrefix: "arf$", pluralPrefix: "$1arves"))
        templates.append((singularPrefix: "(embarg)o$", pluralPrefix: "$1oes"))
        templates.append((singularPrefix: "(gen)us$", pluralPrefix: "$1era"))
        templates.append((singularPrefix: "(r)oof$", pluralPrefix: "$1oofs"))
        templates.append((singularPrefix: "(l)eaf$", pluralPrefix: "$1eaves"))
        templates.append((singularPrefix: "(millen)ium$", pluralPrefix: "$1ia"))
        templates.append((singularPrefix: "(th)at$", pluralPrefix: "$1ose"))
        templates.append((singularPrefix: "(th)is$", pluralPrefix: "$1ese"))
        
        return templates
    }()
    
    private static let singularityTemplates: [(pluralPrefix: String, singularPrefix: String)] = {
        
        var templates = [(pluralPrefix: String, singularPrefix: String)]()
        templates.append((pluralPrefix: "s$", singularPrefix:"$1"))
        templates.append((pluralPrefix: "ses$", singularPrefix:"$1s"))
        templates.append((pluralPrefix: "(t|r|l|b|d)ies$", singularPrefix:"$1y"))
        templates.append((pluralPrefix: "xes$", singularPrefix:"$1x"))
        templates.append((pluralPrefix: "(sh|zz|ss)es$", singularPrefix:"$1"))
        templates.append((pluralPrefix: "(ax)es$", singularPrefix: "$1is"))
        templates.append((pluralPrefix: "(cact|nucle|alumn|bacill|fung|radi|stimul|syllab)i$", singularPrefix:"$1us"))
        templates.append((pluralPrefix: "(corp)ora$", singularPrefix:"$1us"))
        templates.append((pluralPrefix: "ses$", singularPrefix:"$1sis"))
        templates.append((pluralPrefix: "ches$", singularPrefix:"$1ch"))
        templates.append((pluralPrefix: "os$", singularPrefix:"$1o"))
        templates.append((pluralPrefix: "(embarg|buffal|carg|mosquit|torped|zer|vet|her|ech)oes$", singularPrefix:"$1o"))
        templates.append((pluralPrefix: "ves$", singularPrefix:"$1fe"))
        templates.append((pluralPrefix: "(thie)ves$", singularPrefix:"$1f"))
        templates.append((pluralPrefix: "oaves$", singularPrefix:"$1oaf"))
        templates.append((pluralPrefix: "a$", singularPrefix:"$1um"))
        templates.append((pluralPrefix: "ia$", singularPrefix:"$1ium"))
        templates.append((pluralPrefix: "ooves$", singularPrefix:"$1oof"))
        templates.append((pluralPrefix: "(nebul)ae", singularPrefix:"$1a"))
        templates.append((pluralPrefix: "(criteri|phenomen)a$", singularPrefix:"$1on"))
        templates.append((pluralPrefix: "(potat|tomat|volcan)oes$", singularPrefix:"$1o"))
        templates.append((pluralPrefix: "^(|wo|work|fire)men$", singularPrefix: "$1man"))
        templates.append((pluralPrefix: "(f)eet$", singularPrefix: "$1oot"))
        templates.append((pluralPrefix: "lves$", singularPrefix: "$1lf"))
        templates.append((pluralPrefix: "(t)eeth$", singularPrefix: "$1ooth"))
        templates.append((pluralPrefix: "(g)eese$", singularPrefix: "$1oose"))
        templates.append((pluralPrefix: "^(c)hildren$", singularPrefix: "$1hild"))
        templates.append((pluralPrefix: "^(o)xen$", singularPrefix: "$1x"))
        templates.append((pluralPrefix: "^(p)eople$", singularPrefix: "$1erson"))
        templates.append((pluralPrefix: "(m|l)ice$", singularPrefix: "$1ouse"))
        templates.append((pluralPrefix: "^(d)ice$", singularPrefix: "$1ie"))
        templates.append((pluralPrefix: "^(alg|vertebr|vit)ae$", singularPrefix: "$1a"))
        templates.append((pluralPrefix: "^(a)lumnae$", singularPrefix: "$1lumna"))
        templates.append((pluralPrefix: "^(a)pparatuses$", singularPrefix: "$1pparatus"))
        templates.append((pluralPrefix: "^(ind)ices$", singularPrefix: "$1ex"))
        templates.append((pluralPrefix: "^(append|matr)ices$", singularPrefix: "$1ix"))
        templates.append((pluralPrefix: "^(b|tabl)eaux$", singularPrefix: "$1eau"))
        templates.append((pluralPrefix: "arves$", singularPrefix: "$1arf"))
        templates.append((pluralPrefix: "(gen)era$", singularPrefix: "$1us"))
        templates.append((pluralPrefix: "(r)oofs$", singularPrefix: "$1oof"))
        templates.append((pluralPrefix: "(l)eaves$", singularPrefix: "$1eaf"))
        templates.append((pluralPrefix: "(millen)ia$", singularPrefix: "$1ium"))
        templates.append((pluralPrefix: "(th)ose$", singularPrefix: "$1at"))
        templates.append((pluralPrefix: "(th)is$", singularPrefix: "$1ese"))
        templates.append((pluralPrefix: "(exer)cises$", singularPrefix: "$1cise"))
        
        return templates
    }()
    
    static func pluralize(word: String) -> String {
        
        // Guard from the word being uncountable or unchangeable
        guard !uncountables.contains(word.lowercased()) && !unchangeables.contains(word.lowercased()) && word.count !=  0
            else { return word }
        
        // If a template exists for the word, replace the singular prefix with the plural prefix, otherwise, return the word
        for template in pluralityTemplates.reversed() {
            
            let newValue = regexReplace(oldPrefix: template.singularPrefix, in: word, with: template.pluralPrefix)
            if newValue != word { return newValue }
        }
        
        return word
    }
    
    static func singularize(word: String) -> String {
        
        // Guard from the word being uncountable or unchangeable
        guard !uncountables.contains(word.lowercased()) && !unchangeables.contains(word.lowercased()) && word.count !=  0
            else { return word }
        
        // If a template exists for the word, replace the plural prefix with the singular prefix, otherwise, return the word
        for template in singularityTemplates.reversed() {
            
            let newValue = regexReplace(oldPrefix: template.pluralPrefix, in: word, with: template.singularPrefix)
            if newValue != word { return newValue }
        }
        
        return word
    }
    
    private static func regexReplace(oldPrefix: String, in input: String, with newPrefix: String) -> String {
        
        let regex = try! NSRegularExpression(pattern: oldPrefix, options: .caseInsensitive)
        let range = NSRange(location: 0, length: input.count)
        let output = regex.stringByReplacingMatches(in: input, options: [], range: range, withTemplate: newPrefix)
        return output
    }
    
    func pluralized() -> String { return String.pluralize(word: self) }
    
    func singularized() -> String { return String.singularize(word: self) }
    
    // Assumes self is plural
    public func inflected(forGrammaticalNumber number: Int) -> String {
        
        guard number != 1 else { return self }
        return pluralized()
    }
}

class InvalidArgumentError: Error {}

//private var placeholders = [UILabel:String]()
//private var placeholderColors = [UILabel:String]()
//extension UILabel {
//    
//    @IBInspectable var placeholder: String? {
//        get {
//            return placeholders[self]
//        }
//        
//        set {
//            placeholders[self] = newValue
//        }
//    }
//    
////    @IBInspectable var placeholderColor: UIColor? {
////        get {
////
////        }
////        
////        set {
////            //set default placeholder color?
////        }
////    }
//    
//    var text: String? {
//        didSet {
//            placeholders[self] = placeholder
//        }
//    }
//    
//}
//
//class Label: UILabel {
//    override var text: String?
//}
