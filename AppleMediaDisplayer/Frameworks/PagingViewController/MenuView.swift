//
//  MenuView.swift
//  PagingMenuController
//
//  Created by Yusuke Kita on 5/9/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

open class MenuView: UIScrollView {
    
    public fileprivate(set) var currentMenuItemView: MenuItemView!
    
    internal fileprivate(set) var menuItemViews = [MenuItemView]()
    
    internal var onMove: ((MenuMoveState) -> Void)?
    
    private(set) var options: MenuViewCustomizable
    
    fileprivate var sortedMenuItemViews = [MenuItemView]()
    
    fileprivate let contentView: UIView = {
        
        $0.translatesAutoresizingMaskIntoConstraints = false; return $0
        
    }(UIView(frame: .zero))
    
    lazy fileprivate var underlineView = UIView(frame: .zero)
    
    lazy fileprivate var roundRectView: UIView = {
        
        $0.isUserInteractionEnabled = true; return $0
        
    }(UIView(frame: .zero))
    
    fileprivate var menuViewBounces: Bool {
        
        switch options.displayMode {
            
        case .standard(_, _, .scrollEnabledAndBouces),
             .infinite(_, .scrollEnabledAndBouces):
            
            return true
            
        default: return false
        }
    }
    
    fileprivate var menuViewScrollEnabled: Bool {
        
        switch options.displayMode {
            
        case .standard(_, _, .scrollEnabledAndBouces),
             .standard(_, _, .scrollEnabled),
             .infinite(_, .scrollEnabledAndBouces),
             .infinite(_, .scrollEnabled):
            
            return true
            
        default: return false
        }
    }
    
    fileprivate var contentOffsetX: CGFloat {
        
        switch options.displayMode {
            
        case .standard(_, let centerItem, _) where centerItem:
            
            return centerOfScreenWidth
            
        case .standard(_, let centerItem, _) where !centerItem:
            
            if self.contentView.frame.width < self.frame.width {
                
                return contentOffset.x
            
            } else { return contentOffsetXForCurrentPage }
            
        case .segmentedControl: return contentOffset.x
        
        case .infinite: return centerOfScreenWidth
        
        default: return contentOffsetXForCurrentPage
        }
    }
    
    fileprivate var centerOfScreenWidth: CGFloat {
        
        let screenWidth: CGFloat = {
            
            if let width = UIApplication.shared.keyWindow?.bounds.width {
                
                return width
                
            } else { return UIScreen.main.bounds.width }
        }()
        
        return menuItemViews[currentPage].frame.midX - (screenWidth / 2)
    }
    
    fileprivate var contentOffsetXForCurrentPage: CGFloat {
        
        guard menuItemCount > MinimumSupportedViewCount else { return 0.0 }
        
        let ratio = CGFloat(currentPage) / CGFloat(menuItemCount - 1)
        return (contentSize.width - frame.width) * ratio
    }
    
    fileprivate var currentIndex: Int = 0
    
    // MARK: - Internal method
    
    internal func move(toPage page: Int, animated: Bool = true) {
        
        // Hide menu view when constructing itself
        if !animated { alpha = 0 }
        
        let menuItemView = menuItemViews[page]
        let previousPage = currentPage
        let previousMenuItemView = currentMenuItemView
        
        if let previousMenuItemView = previousMenuItemView, page != previousPage {
            
            onMove?(.willMoveItem(to: menuItemView, from: previousMenuItemView))
        }
        
        update(currentPage: page)
        
        let duration = animated ? options.animationDuration : 0
        UIView.animate(withDuration: duration, animations: { [unowned self] () -> Void in
            
            self.focusMenuItem()
            if self.options.selectedItemCenter { self.positionMenuItemViews() }
            
        }, completion: { [weak self] (Bool) -> Void in
            
            guard let strongSelf = self else { return }
            
            // Relayout menu item views dynamically
            if case .infinite = strongSelf.options.displayMode { strongSelf.relayoutMenuItemViews() }
            
            if strongSelf.options.selectedItemCenter { strongSelf.positionMenuItemViews() }
            
            strongSelf.setNeedsLayout(); strongSelf.layoutIfNeeded()
            
            // Show menu view when constructing is done
            if !animated { strongSelf.alpha = 1 }
            
            if let previousMenuItemView = previousMenuItemView, page != previousPage {
                
                strongSelf.onMove?(.didMoveItem(to: strongSelf.currentMenuItemView, from: previousMenuItemView))
            }
        })
    }
    
    internal func updateMenuViewConstraints(_ size: CGSize) {
        
        if case .segmentedControl = options.displayMode {
            
            menuItemViews.forEach { $0.updateConstraints(size) }
        }
        
        setNeedsLayout(); layoutIfNeeded()
        
        animateUnderlineViewIfNeeded(); animateRoundRectViewIfNeeded()
    }
    
    // MARK: - Private method
    
    fileprivate func sortMenuItemViews() {
        if !sortedMenuItemViews.isEmpty {
            sortedMenuItemViews.removeAll()
        }
        
        if case .infinite = options.displayMode {
            for i in 0..<menuItemCount {
                let page = rawPage(i)
                sortedMenuItemViews.append(menuItemViews[page])
            }
        } else {
            sortedMenuItemViews = menuItemViews
        }
    }
    
    fileprivate func layoutMenuItemViews() {
        NSLayoutConstraint.deactivate(contentView.constraints)
        
        for (index, menuItemView) in sortedMenuItemViews.enumerated() {
            if index == 0 {
                // H:|[menuItemView]
                menuItemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            } else  {
                if index == sortedMenuItemViews.count - 1 {
                    // H:[menuItemView]|
                    menuItemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
                }
                // H:[previousMenuItemView][menuItemView]
                let previousMenuItemView = sortedMenuItemViews[index - 1]
                previousMenuItemView.trailingAnchor.constraint(equalTo: menuItemView.leadingAnchor, constant: 0).isActive = true
            }
            
            // V:|[menuItemView]|
            NSLayoutConstraint.activate([
                menuItemView.topAnchor.constraint(equalTo: contentView.topAnchor),
                menuItemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                ])
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    fileprivate func animateUnderlineViewIfNeeded() {
        guard case .underline(_, _, let horizontalPadding, _) = options.focusMode else { return }
        
        let targetFrame = menuItemViews[currentPage].frame
        underlineView.frame.origin.x = targetFrame.minX + horizontalPadding
        underlineView.frame.size.width = targetFrame.width - horizontalPadding * 2
    }
    
    fileprivate func animateRoundRectViewIfNeeded() {
        guard case .roundRect(_, let horizontalPadding, _, _) = options.focusMode else { return }
        
        let targetFrame = menuItemViews[currentPage].frame
        roundRectView.frame.origin.x = targetFrame.minX + horizontalPadding
        roundRectView.frame.size.width = targetFrame.width - horizontalPadding * 2
    }

    fileprivate func relayoutMenuItemViews() {
        sortMenuItemViews()
        layoutMenuItemViews()
    }

    fileprivate func positionMenuItemViews() {
        contentOffset.x = contentOffsetX
        animateUnderlineViewIfNeeded()
        animateRoundRectViewIfNeeded()
    }
    
    fileprivate func adjustmentContentInsetIfNeeded() {
        switch options.displayMode {
        case .standard(_, let centerItem, _) where centerItem: break
        default: return
        }
        
        guard let firstMenuView = menuItemViews.first,
            let lastMenuView = menuItemViews.last else { return }
        
        var inset = contentInset
        let halfWidth = frame.width / 2
        inset.left = halfWidth - firstMenuView.frame.width / 2
        inset.right = halfWidth - lastMenuView.frame.width / 2
        contentInset = inset
    }
    
    fileprivate func focusMenuItem() {
        let isSelected: (MenuItemView) -> Bool = { self.menuItemViews.index(of: $0) == self.currentPage }
        
        // make selected item focused
        menuItemViews.forEach {
            $0.isSelected = isSelected($0)
            if $0.isSelected {
                self.currentMenuItemView = $0
            }
        }

        // make selected item foreground
        sortedMenuItemViews.forEach { $0.layer.zPosition = isSelected($0) ? 0 : -1 }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        adjustmentContentInsetIfNeeded()
    }
    
    internal init(options: MenuViewCustomizable) {
        
        self.options = options
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: options.height))
        
        func setupScrollView() {
            
            backgroundColor = options.backgroundColor
            showsHorizontalScrollIndicator = false
            showsVerticalScrollIndicator = false
            bounces = menuViewBounces
            isScrollEnabled = menuViewScrollEnabled
            isDirectionalLockEnabled = true
            decelerationRate = options.deceleratingRate
            scrollsToTop = false
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        func layoutScrollView() {
            
            let viewsDictionary = ["menuView": self]
            let metrics = ["height": options.height]
            NSLayoutConstraint.activate(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[menuView(height)]", options: [], metrics: metrics, views: viewsDictionary)
            )
        }
        
        func setupContentView() { addSubview(contentView) }
        
        func layoutContentView() {
            
            // H:|[contentView]|
            // V:|[contentView(==scrollView)]|
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                contentView.topAnchor.constraint(equalTo: topAnchor),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
                contentView.heightAnchor.constraint(equalTo: heightAnchor)
                ])
        }
        
        func setupRoundRectViewIfNeeded() {
            
            guard case let .roundRect(radius, _, verticalPadding, selectedColor) = options.focusMode else { return }
            
            let height = options.height - (verticalPadding * 2)
            roundRectView.frame = CGRect(x: 0, y: verticalPadding, width: 0, height: height)
            roundRectView.layer.cornerRadius = radius
            roundRectView.backgroundColor = selectedColor
            contentView.addSubview(roundRectView)
        }
        
        func constructMenuItemViews() {
            
            for index in 0..<menuItemCount {
                
                let menuItemView: MenuItemView = {
                    
                    let mv = MenuItemView(menuOptions: options,
                                          menuItemOptions: options.itemTraits[index % options.itemTraits.count],
                                          addDivider: index < (menuItemCount - 1)
                    )
                    mv.translatesAutoresizingMaskIntoConstraints = false
                    
                    return mv
                }()
                contentView.addSubview(menuItemView); menuItemViews.append(menuItemView)
            }
            
            sortMenuItemViews()
        }
        
        func setupUnderlineViewIfNeeded() {
            
            guard case let .underline(height, color, horizontalPadding, verticalPadding) = options.focusMode else { return }
            
            let width = menuItemViews[currentPage].bounds.width - (horizontalPadding * 2)
            underlineView.frame = CGRect(x: horizontalPadding, y: options.height - (height + verticalPadding), width: width, height: height)
            underlineView.backgroundColor = color
            contentView.addSubview(underlineView)
        }
        
        setupScrollView()
        layoutScrollView()
        setupContentView()
        layoutContentView()
        setupRoundRectViewIfNeeded()
        constructMenuItemViews()
        layoutMenuItemViews()
        setupUnderlineViewIfNeeded()
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) not implemented") }
}

extension MenuView: Pagable {
    var currentPage: Int {
        return currentIndex
    }
    var previousPage: Int {
        return currentPage - 1 < 0 ? menuItemCount - 1 : currentPage - 1
    }
    var nextPage: Int {
        return currentPage + 1 > menuItemCount - 1 ? 0 : currentPage + 1
    }
    func update(currentPage page: Int) {
        currentIndex = page
    }
}

extension MenuView {
    func cleanup() {
        contentView.removeFromSuperview()
        switch options.focusMode {
        case .underline: underlineView.removeFromSuperview()
        case .roundRect: roundRectView.removeFromSuperview()
        case .none: break
        }
        
        if !menuItemViews.isEmpty {
            menuItemViews.forEach {
                $0.cleanup()
                $0.removeFromSuperview()
            }
        }
    }
}

extension MenuView {
    var menuItemCount: Int {
        switch options.displayMode {
        case .infinite: return options.itemTraits.count * options.dummyItemViewsSet
        default: return options.itemTraits.count
        }
    }
    fileprivate func rawPage(_ page: Int) -> Int {
        let startIndex = currentPage - menuItemCount / 2
        return (startIndex + page + menuItemCount) % menuItemCount
    }
}
