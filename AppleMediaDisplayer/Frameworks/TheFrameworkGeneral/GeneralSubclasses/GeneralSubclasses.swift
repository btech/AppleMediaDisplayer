//
//  GeneralSubclasses.swift
//  ClassMate
//
//  Created by me on 2/14/17.
//  Copyright © 2017 b. All rights reserved.
//

import Foundation
import UIKit

class AdjustPanViewController: UIViewController {
    
    private(set) var mKeyboardIsShown = false
    private(set) var mInterfaceOrientation: UIInterfaceOrientation!

    private var mNewInterfaceOrientation: UIInterfaceOrientation?
    private(set) var mInterfaceIsChangingOrientation = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mInterfaceOrientation = (view.frame.size.width > view.frame.size.height) ? UIInterfaceOrientation.landscapeRight : UIInterfaceOrientation.portrait
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow),
                                               name: .UIKeyboardDidShow,
                                               object: nil
        )
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide),
                                               name: .UIKeyboardDidHide,
                                               object: nil
        )
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideFilter),
                                               name: .UIKeyboardWillHide,
                                               object: nil
        )
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowFilter),
                                               name: .UIKeyboardWillShow,
                                               object: nil
        )
        NotificationCenter.default.addObserver(self, selector: #selector(onInterfaceWillChangeOrientationFilter),
                                               name: .UIApplicationWillChangeStatusBarOrientation,
                                               object: nil
        )
        NotificationCenter.default.addObserver(self, selector: #selector(onInterfaceDidChangeOrientationFilter),
                                               name: .UIApplicationDidChangeStatusBarOrientation,
                                               object: nil
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardDidShow(_ notification: NSNotification) {
        print("keyboard did show: \(view.window!.frame.size.height)")
        
        let keyboardHeight = keyboardSize(from: notification)!.height
        view.frame.size.height = UIScreen.main.bounds.size.height - keyboardHeight
    }
    
    @objc func keyboardDidHide(_ notification: NSNotification) {
        print("keyboard did hide: \(view.window!.frame.size.height)")

    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        print("keyboard will show: \(view.window!.frame.size.height)")
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        print("keyboard will hide: \(view.window!.frame.size.height)")
        //Once keyboard disappears, restore original positions
        view.frame.size.height = UIScreen.main.bounds.size.height
    }
    
    @objc private func keyboardWillShowFilter(_ notification: NSNotification) {
        if mKeyboardIsShown || mInterfaceIsChangingOrientation {return}
        mKeyboardIsShown = true
        keyboardWillShow(notification)
    }
    
    @objc private func keyboardWillHideFilter(_ notification: NSNotification) {
        if !mKeyboardIsShown || mInterfaceIsChangingOrientation {return}
        mKeyboardIsShown = false
        keyboardWillHide(notification)
    }
    
    func onInterfaceWillChangeOrientation(newOrientation: UIInterfaceOrientation) {}
    func onInterfaceDidChangeOrientation(oldOrientation: UIInterfaceOrientation) {}
    
    @objc private func onInterfaceDidChangeOrientationFilter(_ notification: NSNotification) {
        print("interface did change orientation")
        mInterfaceIsChangingOrientation = false
        mInterfaceOrientation = mNewInterfaceOrientation!
        onInterfaceDidChangeOrientation(oldOrientation: UIInterfaceOrientation(rawValue: ((notification.userInfo![UIApplicationStatusBarOrientationUserInfoKey] as? Int))!)!)
    }
    
    @objc private func onInterfaceWillChangeOrientationFilter(_ notification: NSNotification) {
        print("interface will change orientation")
        mInterfaceIsChangingOrientation = true
        let newOrientation = UIInterfaceOrientation(rawValue: ((notification.userInfo![UIApplicationStatusBarOrientationUserInfoKey] as? Int))!)!
        mNewInterfaceOrientation = newOrientation
        onInterfaceWillChangeOrientation(newOrientation: newOrientation)
    }
}

class ScrollView: UIScrollView {
    
    private var disableScrollRectToVisible = true
    
    override func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
        
        guard !disableScrollRectToVisible else { return }
        
        super.scrollRectToVisible(rect, animated: animated)
    }
}
