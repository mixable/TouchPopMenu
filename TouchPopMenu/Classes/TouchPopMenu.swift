//
//  TouchPopMenu.swift
//  Example
//
//  Created by Mathias Lipowski on 01.04.19.
//  Copyright © 2019 Mathias Lipowski. All rights reserved.
//

import UIKit

public class TouchPopMenu : TouchHandlerView, TouchHandlerDelegate
{
    /*
     Position of the menu
     */
    public enum Position {
        case auto
        // Main positions
        case left
        case up
        case right
        case down
        // More precise positions
        case leftUp
        case leftDown
        case upLeft
        case upRight
        case rightUp
        case rightDown
        case downLeft
        case downRight
    }

    /*
     Type of source
     */
    public enum SourceType {
        case view
        case button
        case barButtonItem
    }

    /*
     Position relative to source view
     */
    public var position : Position = .auto {
        didSet {
            applyPosition()
        }
    }

    /*
     Corner radius of menu view
     */
    public var cornerRadius : CGFloat = 10.0

    /*
     Background color of the overlay view
     */
    public var overlayColor : UIColor = UIColor(white: 0.0, alpha: 0.05) {
        didSet {
            applyTheme()
        }
    }

    /*
     Background color of the menu view
     */
    public var menuColor : UIColor = .white {
        didSet {
            applyTheme()
        }
    }

    /*
     Background color of the selected action
     */
    public var selectedColor : UIColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)

    /*
     Text color of the menu actions
     */
    public var textColor : UIColor = .black {
        didSet {
            applyTheme()
        }
    }
    
    /*
     Text color of the menu action divider
     */
    public var dividerColor : UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0) {
        didSet {
            applyTheme()
        }
    }
    
    /*
     Size of the arrow triangle
     */
    public var arrowLength : CGFloat = 15.0
    
    /*
     Height of action labels
     */
    public var labelHeight : CGFloat = 46.0
    
    /*
     Horizontal spacing of label text
     */
    public var labelInset : CGFloat = 15.0

    /*
     Font of action labels
     */
    public var labelFont : UIFont = UIFont.systemFont(ofSize: 16.0) {
        didSet {
            applyTheme()
        }
    }
    
    /*
     Space between menu and screen edges
     */
    public var screenInset : CGFloat = 8.0

    /*
     Duration of the show/hide animations
     */
    public var animationDuration : TimeInterval = 0.15

    /*
     Moving offset of the show/hide animations
     */
    public var animationOffset : CGFloat = 10

    /*
     Returns true if menu is open
     */
    public var isOpen : Bool = false
    
    // MARK: Private parameters

    /*
     Controller to attach the menu
     */
    private var controller : UIViewController
    
    /*
     Source to attach the menu
     */
    private var sourceType : SourceType = .view
    
    private var sourceView : UIView?
    private var sourceButton : UIButton?
    private var sourceBarButtonItem : UIBarButtonItem?
    
    private var source : Any? {
        get {
            switch sourceType {
            case .view:
                return sourceView
            case .button:
                return sourceButton
            case .barButtonItem:
                return sourceBarButtonItem
            }
        }
    }
    
    private var sourceSuperview : UIView? {
        get {
            switch sourceType {
            case .view:
                return sourceView?.superview
            case .button:
                return sourceButton?.superview
            case .barButtonItem:
                return (sourceBarButtonItem!.value(forKey: "view") as? UIView)!.superview
            }
        }
    }

    /*
     Actions
     */
    private var actions : [TouchPopMenuAction] = [TouchPopMenuAction]()

    /*
     Menu views
     */
    private var overlayView : TouchHandlerView?
    private var shadowView : UIView?
    private var positionView : UIView?
    private var contentView : UIView?
    private var menuView : UIView?
    private var arrowView : ArrowView?
    
    private var menuSize : CGSize = CGSize.zero
    
    /*
     Window to add menu
     */
    private var sourceWindow : UIWindow? {
        get {
            return (UIApplication.shared.delegate?.window)!
        }
    }
    
    // MARK: Init
    
    /*
     Init
     */
    public init(pointTo view: UIView, inController controller: UIViewController)
    {
        self.sourceType = .view
        self.sourceView = view
        self.controller = controller
        
        super.init(frame: CGRect.zero)

        layoutMenu()
    }

    public init(pointTo button: UIButton, inController controller: UIViewController)
    {
        self.sourceType = .button
        self.sourceButton = button
        self.controller = controller

        super.init(frame: CGRect.zero)
        
        layoutMenu()
    }
    
    public init(pointTo barButtonItem: UIBarButtonItem, inController controller: UIViewController)
    {
        self.sourceType = .barButtonItem
        self.sourceBarButtonItem = barButtonItem
        self.controller = controller

        super.init(frame: CGRect.zero)
        
        layoutMenu()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
     Init all menu views and gesture recognizers
     */
    private func layoutMenu()
    {
        // Create touch view (self)
        clipsToBounds = false
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        layer.masksToBounds = false
        touchDelegate = self
        
        // Check if position changes and menu needs to be repositioned
        addObserver(self, forKeyPath: "center", options: .new, context: nil)

        sourceSuperview?.addSubview(self)
        sourceSuperview?.bringSubviewToFront(self)
        sourceSuperview?.addConstraints([
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: source, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: source, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: source, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: source, attribute: .bottom, multiplier: 1, constant: 0)
            ])

        // Create overlay view
        overlayView = TouchHandlerView(frame: controller.view.bounds)
        overlayView!.layer.backgroundColor = overlayColor.cgColor
        overlayView!.isHidden = true
        overlayView!.touchDelegate = self
        sourceWindow!.addSubview(overlayView!)

        overlayView!.translatesAutoresizingMaskIntoConstraints = false
        overlayView!.leftAnchor.constraint(equalTo: sourceWindow!.leftAnchor, constant: 0).isActive = true
        overlayView!.topAnchor.constraint(equalTo: sourceWindow!.topAnchor, constant: 0).isActive = true
        overlayView!.rightAnchor.constraint(equalTo: sourceWindow!.rightAnchor, constant: 0).isActive = true
        overlayView!.bottomAnchor.constraint(equalTo: sourceWindow!.bottomAnchor, constant: 0).isActive = true
        
        // Create shadow view
        shadowView = UIView(frame: UIScreen.main.bounds)
        shadowView!.layer.masksToBounds = false
        shadowView!.layer.backgroundColor = UIColor.clear.cgColor
        shadowView!.layer.shadowColor = UIColor.black.cgColor
        shadowView!.layer.shadowOffset = CGSize.zero
        shadowView!.layer.shadowOpacity = 0.1
        shadowView!.layer.shadowRadius = 25.0
        overlayView!.addSubview(shadowView!)

        shadowView!.translatesAutoresizingMaskIntoConstraints = false
        shadowView!.leftAnchor.constraint(equalTo: overlayView!.leftAnchor, constant: 0).isActive = true
        shadowView!.topAnchor.constraint(equalTo: overlayView!.topAnchor, constant: 0).isActive = true
        shadowView!.rightAnchor.constraint(equalTo: overlayView!.rightAnchor, constant: 0).isActive = true
        shadowView!.bottomAnchor.constraint(equalTo: overlayView!.bottomAnchor, constant: 0).isActive = true
        
        // Create shadow view
        positionView = UIView(frame: convert(self.bounds, to: overlayView))
        positionView!.backgroundColor = .clear
        shadowView!.addSubview(positionView!)

        // Create content view
        contentView = UIView()
        contentView!.layer.masksToBounds = false
        contentView!.translatesAutoresizingMaskIntoConstraints = false
        contentView!.backgroundColor = .clear
        shadowView!.addSubview(contentView!)

        // Create arrow view
        arrowView = ArrowView(pointTo: positionView!,
                              position: menuPosition,
                              length: arrowLength,
                              color: self.menuColor)
        contentView!.addSubview(arrowView!)
        initArrowConstraints()

        // Create menu view
        menuView = UIView()
        menuView!.layer.cornerRadius = cornerRadius;
        menuView!.layer.masksToBounds = true;
        menuView!.backgroundColor = menuColor
        contentView!.addSubview(menuView!)
        initMenuConstraints()
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is TouchPopMenu && keyPath == "center" {
            // Recalculate frame of positionView
            applyPosition()
        }
    }
    
    private func applyPosition()
    {
        positionView!.frame = convert(self.bounds, to: overlayView)
        arrowView!.position = menuPosition
        
        layoutArrowConstraints()
        layoutMenuConstraints()
        setNeedsLayout()
    }
    
    // MARK: Constraints
    
    /*
     Handle arrow constraints
     */
    var arrowLeftXConstraint : NSLayoutConstraint?
    var arrowLeftYConstraint : NSLayoutConstraint?
    var arrowUpXConstraint : NSLayoutConstraint?
    var arrowUpYConstraint : NSLayoutConstraint?
    var arrowRightXConstraint : NSLayoutConstraint?
    var arrowRightYConstraint : NSLayoutConstraint?
    var arrowDownXConstraint : NSLayoutConstraint?
    var arrowDownYConstraint : NSLayoutConstraint?

    private func initArrowConstraints()
    {
        arrowLeftXConstraint = (arrowView?.rightAnchor.constraint(equalTo: positionView!.leftAnchor, constant: 0))!
        arrowLeftYConstraint = (arrowView?.centerYAnchor.constraint(equalTo: positionView!.centerYAnchor, constant: 0))!
        arrowUpXConstraint = (arrowView?.centerXAnchor.constraint(equalTo: positionView!.centerXAnchor, constant: 0))!
        arrowUpYConstraint = (arrowView?.bottomAnchor.constraint(equalTo: positionView!.topAnchor, constant: 0))!
        arrowRightXConstraint = (arrowView?.leftAnchor.constraint(equalTo: positionView!.rightAnchor, constant: 0))!
        arrowRightYConstraint = (arrowView?.centerYAnchor.constraint(equalTo: positionView!.centerYAnchor, constant: 0))!
        arrowDownXConstraint = (arrowView?.centerXAnchor.constraint(equalTo: positionView!.centerXAnchor, constant: 0))!
        arrowDownYConstraint = (arrowView?.topAnchor.constraint(equalTo: positionView!.bottomAnchor, constant: 0))!
        
        layoutArrowConstraints()
    }
    
    private func layoutArrowConstraints()
    {
        arrowLeftXConstraint?.isActive = false
        arrowLeftYConstraint?.isActive = false
        arrowUpXConstraint?.isActive = false
        arrowUpYConstraint?.isActive = false
        arrowRightXConstraint?.isActive = false
        arrowRightYConstraint?.isActive = false
        arrowDownXConstraint?.isActive = false
        arrowDownYConstraint?.isActive = false

        if menuPosition == .left || menuPosition == .leftUp || menuPosition == .leftDown {
            arrowLeftXConstraint?.isActive = true
            arrowLeftYConstraint?.isActive = true
        }
        if menuPosition == .up || menuPosition == .upLeft || menuPosition == .upRight {
            arrowUpXConstraint?.isActive = true
            arrowUpYConstraint?.isActive = true
        }
        if menuPosition == .right || menuPosition == .rightUp || menuPosition == .rightDown {
            arrowRightXConstraint?.isActive = true
            arrowRightYConstraint?.isActive = true
        }
        if menuPosition == .down || menuPosition == .downLeft || menuPosition == .downRight {
            arrowDownXConstraint?.isActive = true
            arrowDownYConstraint?.isActive = true
        }
    }
    
    /*
     Handle menu constraints
     */
    var menuHeightConstraint : NSLayoutConstraint?
    var menuWidthConstraint : NSLayoutConstraint?
    var menuLeftXConstraint : NSLayoutConstraint?
    var menuLeftYConstraint : NSLayoutConstraint?
    var menuUpXConstraint : NSLayoutConstraint?
    var menuUpYConstraint : NSLayoutConstraint?
    var menuRightXConstraint : NSLayoutConstraint?
    var menuRightYConstraint : NSLayoutConstraint?
    var menuDownXConstraint : NSLayoutConstraint?
    var menuDownYConstraint : NSLayoutConstraint?
    
    private func initMenuConstraints()
    {
        menuView!.translatesAutoresizingMaskIntoConstraints = false

        menuHeightConstraint = menuView!.heightAnchor.constraint(equalToConstant: 0)
        menuHeightConstraint?.isActive = true
        menuWidthConstraint = menuView!.widthAnchor.constraint(equalToConstant: 0)
        menuWidthConstraint?.isActive = true
        menuLeftXConstraint = menuView!.rightAnchor.constraint(equalTo: arrowView!.leftAnchor, constant: 0)
        menuLeftYConstraint = menuView!.centerYAnchor.constraint(equalTo: arrowView!.centerYAnchor, constant: 0)
        menuUpXConstraint = menuView!.centerXAnchor.constraint(equalTo: arrowView!.centerXAnchor, constant: 0)
        menuUpYConstraint = menuView!.bottomAnchor.constraint(equalTo: arrowView!.topAnchor, constant: 0)
        menuRightXConstraint = menuView!.leftAnchor.constraint(equalTo: arrowView!.rightAnchor, constant: 0)
        menuRightYConstraint = menuView!.centerYAnchor.constraint(equalTo: arrowView!.centerYAnchor, constant: 0)
        menuDownXConstraint = menuView!.centerXAnchor.constraint(equalTo: arrowView!.centerXAnchor, constant: 0)
        menuDownYConstraint = menuView!.topAnchor.constraint(equalTo: arrowView!.bottomAnchor, constant: 0)
        
        layoutMenuConstraints()
    }
    
    private func layoutMenuConstraints()
    {
        menuLeftXConstraint?.isActive = false
        menuLeftYConstraint?.isActive = false
        menuUpXConstraint?.isActive = false
        menuUpYConstraint?.isActive = false
        menuRightXConstraint?.isActive = false
        menuRightYConstraint?.isActive = false
        menuDownXConstraint?.isActive = false
        menuDownYConstraint?.isActive = false

        if menuPosition == .left || menuPosition == .leftUp || menuPosition == .leftDown {
            menuLeftXConstraint?.isActive = true
            menuLeftYConstraint?.isActive = true
        }
        if menuPosition == .up || menuPosition == .upLeft || menuPosition == .upRight {
            menuUpXConstraint?.isActive = true
            menuUpYConstraint?.isActive = true
        }
        if menuPosition == .right || menuPosition == .rightUp || menuPosition == .rightDown {
            menuRightXConstraint?.isActive = true
            menuRightYConstraint?.isActive = true
        }
        if menuPosition == .down || menuPosition == .downLeft || menuPosition == .downRight {
            menuDownXConstraint?.isActive = true
            menuDownYConstraint?.isActive = true
        }
        
        // Optimize menu position
        let screenSize = overlayView?.bounds.size
        var offset : CGPoint = CGPoint(x: 0, y: 0)

        NSLog("menuPosition \(menuPosition)")
        if menuPosition == .left {
            if #available(iOS 11.0, *) {
                // Handle safeAreaInsets
                if sourceCenter.y - menuSize.height / 2 < screenInset + (overlayView?.safeAreaInsets.top)! {
                    offset.y = screenInset + (overlayView?.safeAreaInsets.top)! + menuSize.height / 2 - sourceCenter.y
                }
                if sourceCenter.y + menuSize.height / 2 > screenSize!.height - screenInset - (overlayView?.safeAreaInsets.bottom)! {
                    offset.y = screenSize!.height - screenInset - (overlayView?.safeAreaInsets.bottom)! - menuSize.height / 2 - sourceCenter.y
                }
            } else {
                // Fallback on earlier versions
                if sourceCenter.y - menuSize.height / 2 < screenInset {
                    offset.y = screenInset + menuSize.height / 2 - sourceCenter.y
                }
                if sourceCenter.y + menuSize.height / 2 > screenSize!.height - screenInset {
                    offset.y = screenSize!.height - screenInset - menuSize.height / 2 - sourceCenter.y
                }
            }
            menuLeftYConstraint?.constant = offset.y
        }
        else if menuPosition == .leftUp {
            offset.y = -menuSize.height / 2 + arrowLength + cornerRadius
            menuLeftYConstraint?.constant = offset.y
        }
        else if menuPosition == .leftDown {
            offset.y = menuSize.height / 2 - arrowLength - cornerRadius
            menuLeftYConstraint?.constant = offset.y
        }
        else if menuPosition == .up {
            if #available(iOS 11.0, *) {
                // Handle safeAreaInsets
                if sourceCenter.x - menuSize.width / 2 < screenInset + (overlayView?.safeAreaInsets.left)! {
                    offset.x = screenInset + (overlayView?.safeAreaInsets.left)! + menuSize.width / 2 - sourceCenter.x
                }
                if sourceCenter.x + menuSize.width / 2 > screenSize!.width - screenInset - (overlayView?.safeAreaInsets.right)! {
                    offset.x = screenSize!.width - screenInset - (overlayView?.safeAreaInsets.right)! - menuSize.width / 2 - sourceCenter.x
                }
            } else {
                // Fallback on earlier versions
                if sourceCenter.x - menuSize.width / 2 < screenInset {
                    offset.x = screenInset + menuSize.width / 2 - sourceCenter.x
                }
                if sourceCenter.x + menuSize.width / 2 > screenSize!.width - screenInset {
                    offset.x = screenSize!.width - screenInset - menuSize.width / 2 - sourceCenter.x
                }
            }
            menuUpXConstraint?.constant = offset.x
        }
        else if menuPosition == .upLeft {
            offset.x = -menuSize.width / 2 + arrowLength + cornerRadius
            menuUpXConstraint?.constant = offset.x
        }
        else if menuPosition == .upRight {
            offset.x = menuSize.width / 2 - arrowLength - cornerRadius
            menuUpXConstraint?.constant = offset.x
        }
        else if menuPosition == .right {
            if #available(iOS 11.0, *) {
                // Handle safeAreaInsets
                if sourceCenter.y - menuSize.height / 2 < screenInset + (overlayView?.safeAreaInsets.top)! {
                    offset.y = screenInset + (overlayView?.safeAreaInsets.top)! + menuSize.height / 2 - sourceCenter.y
                }
                if sourceCenter.y + menuSize.height / 2 > screenSize!.height - screenInset - (overlayView?.safeAreaInsets.bottom)! {
                    offset.y = screenSize!.height - screenInset - (overlayView?.safeAreaInsets.bottom)! - menuSize.height / 2 - sourceCenter.y
                }
            } else {
                // Fallback on earlier versions
                if sourceCenter.y - menuSize.height / 2 < screenInset {
                    offset.y = screenInset + menuSize.height / 2 - sourceCenter.y
                }
                if sourceCenter.y + menuSize.height / 2 > screenSize!.height - screenInset {
                    offset.y = screenSize!.height - screenInset - menuSize.height / 2 - sourceCenter.y
                }
            }
            menuRightYConstraint?.constant = offset.y
        }
        else if menuPosition == .rightUp {
            offset.y = -menuSize.height / 2 + arrowLength + cornerRadius
            menuRightYConstraint?.constant = offset.y
        }
        else if menuPosition == .rightDown {
            offset.y = menuSize.height / 2 - arrowLength - cornerRadius
            menuRightYConstraint?.constant = offset.y
        }
        else if menuPosition == .down
        {
            if #available(iOS 11.0, *) {
                // Handle safeAreaInsets
                if sourceCenter.x - menuSize.width / 2 < screenInset + (overlayView?.safeAreaInsets.left)! {
                    offset.x = screenInset + (overlayView?.safeAreaInsets.left)! + menuSize.width / 2 - sourceCenter.x
                }
                if sourceCenter.x + menuSize.width / 2 > screenSize!.width - screenInset - (overlayView?.safeAreaInsets.right)! {
                    offset.x = screenSize!.width - screenInset - (overlayView?.safeAreaInsets.right)! - menuSize.width / 2 - sourceCenter.x
                }
            } else {
                // Fallback on earlier versions
                if sourceCenter.x - menuSize.width / 2 < screenInset {
                    offset.x = screenInset + menuSize.width / 2 - sourceCenter.x
                }
                if sourceCenter.x + menuSize.width / 2 > screenSize!.width - screenInset {
                    offset.x = screenSize!.width - screenInset - menuSize.width / 2 - sourceCenter.x
                }
            }
            menuDownXConstraint?.constant = offset.x
        }
        else if menuPosition == .downLeft {
            offset.x = -menuSize.width / 2 + arrowLength + cornerRadius
            menuDownXConstraint?.constant = offset.x
        }
        else if menuPosition == .downRight {
            offset.x = menuSize.width / 2 - arrowLength - cornerRadius
            menuDownXConstraint?.constant = offset.x
        }
    }

    // MARK: Menu actions
    
    /*
     Show menu
     */
    public func show()
    {
        setNeedsUpdateConstraints()
        sourceWindow!.bringSubviewToFront(overlayView!)
        
        if menuPosition == .left || menuPosition == .leftUp || menuPosition == .leftDown
        {
            shadowView!.layer.opacity = 0
            shadowView!.frame.origin.x = animationOffset
            overlayView!.layer.opacity = 0
            overlayView!.isHidden = false
        }
        else if menuPosition == .up || menuPosition == .upLeft || menuPosition == .upRight
        {
            shadowView!.layer.opacity = 0
            shadowView!.frame.origin.y = animationOffset
            overlayView!.layer.opacity = 0
            overlayView!.isHidden = false
        }
        else if menuPosition == .right || menuPosition == .rightUp || menuPosition == .rightDown
        {
            shadowView!.layer.opacity = 0
            shadowView!.frame.origin.x = -animationOffset
            overlayView!.layer.opacity = 0
            overlayView!.isHidden = false
        }
        else if menuPosition == .down || menuPosition == .downLeft || menuPosition == .downRight
        {
            shadowView!.layer.opacity = 0
            shadowView!.frame.origin.y = -animationOffset
            overlayView!.layer.opacity = 0
            overlayView!.isHidden = false
        }
        
        UIView.animate(withDuration: self.animationDuration, delay: 0, options: [.curveEaseIn], animations: {
            self.shadowView!.frame.origin.x = 0
            self.shadowView!.frame.origin.y = 0
            self.shadowView!.layer.opacity = 1
            self.overlayView!.layer.opacity = 1
        })

        isOpen = true
        
        // Haptic feedback
        if #available(iOS 10.0, *) {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
    
    /*
     Hide menu
     */
    public func hide(_ completion: @escaping (_ menu : TouchPopMenu) -> () = { _ in })
    {
        shadowView!.layer.opacity = 1
        overlayView!.layer.opacity = 1

        UIView.animate(withDuration: self.animationDuration, delay: 0, options: [.curveEaseIn], animations: {
            if self.menuPosition == .left || self.menuPosition == .leftUp || self.menuPosition == .leftDown
            {
                self.shadowView!.layer.opacity = 0
                self.shadowView!.frame.origin.x = self.animationOffset
                self.overlayView!.layer.opacity = 0
            }
            else if self.menuPosition == .up || self.menuPosition == .upLeft || self.menuPosition == .upRight
            {
                self.shadowView!.layer.opacity = 0
                self.shadowView!.frame.origin.y = self.animationOffset
                self.overlayView!.layer.opacity = 0
            }
            else if self.menuPosition == .right || self.menuPosition == .rightUp || self.menuPosition == .rightDown
            {
                self.shadowView!.layer.opacity = 0
                self.shadowView!.frame.origin.x = -self.animationOffset
                self.overlayView!.layer.opacity = 0
            }
            else if self.menuPosition == .down || self.menuPosition == .downLeft || self.menuPosition == .downRight
            {
                self.shadowView!.layer.opacity = 0
                self.shadowView!.frame.origin.y = -self.animationOffset
                self.overlayView!.layer.opacity = 0
            }
        }, completion: { (finished: Bool) in
            self.overlayView!.isHidden = true
            self.sourceWindow!.sendSubviewToBack(self.overlayView!)
            completion(self)
        })

        isOpen = false
    }
    
    /*
     Center point of source view
     */
    private var sourceCenter: CGPoint {
        get {
            return CGPoint(x: frame.origin.x + frame.size.width / 2,
                           y: frame.origin.y + frame.size.height / 2)
        }
    }

    /*
     Calculated position
     */
    private var menuPosition: Position {
        get {
            if position == .auto {
                // Calculate position of menu
                let screenSize = (overlayView?.bounds.size)!
                if screenSize.width > screenSize.height {
                    if sourceCenter.x < screenSize.width / 2 {
                        return .right
                    } else {
                        return .left
                    }
                }
                else {
                    if sourceCenter.y < screenSize.height / 2 {
                        return .down
                    } else {
                        return .up
                    }
                }
            }
            else {
                return position
            }
        }
    }
    
    /*
     Add an action to the menu
     */
    public func addAction(action: TouchPopMenuAction)
    {
        actions.append(action)
        initActions()
    }
    
    /*
     Remove an action from the menu
     */
    public func removeAction(action: TouchPopMenuAction)
    {
        actions = actions.filter() { $0 !== action }
        initActions()
    }
    
    /*
     Remove all actions from the menu
     */
    public func removeAllActions()
    {
        actions.removeAll()
        initActions()
    }

    private func initActions()
    {
        // Remove all subviews
        menuView!.subviews.forEach({ $0.removeFromSuperview() })
        menuSize = CGSize.zero

        // Create views for each action
        for (index, action) in actions.enumerated()
        {
            let size: CGSize = action.title.size(withAttributes: [
                NSAttributedString.Key.font: labelFont
            ])
            let actionView = UIView(frame: CGRect(x: 0,
                                                  y: menuSize.height,
                                                  width: size.width + labelInset * 2,
                                                  height: labelHeight))

            // Use tag to retrieve action for this view
            actionView.tag = index

            let label = UILabel(frame: CGRect(x: labelInset,
                                              y: 0,
                                              width: size.width,
                                              height: labelHeight))
            label.tag = 1
            label.font = labelFont
            label.text = action.title
            label.textColor = textColor
            actionView.addSubview(label)
            
            // Add border (= top border of label)
            if index > 0 {
                let borderLayer = CALayer()
                borderLayer.frame = CGRect(x: 0, y: menuSize.height, width: label.frame.width, height: 1)
                borderLayer.backgroundColor = dividerColor.cgColor
                menuView!.layer.addSublayer(borderLayer)
            }

            menuView!.addSubview(actionView)
            menuSize.height += labelHeight
            if size.width + (labelInset * 2) > menuSize.width {
                menuSize.width = size.width + (labelInset * 2)
            }
        }
        menuWidthConstraint?.constant = menuSize.width
        menuHeightConstraint?.constant = menuSize.height
        
        setNeedsDisplay()
        setNeedsUpdateConstraints()
    }

    override public func layoutSubviews()
    {
        super.layoutSubviews()
        
        for divider in menuView!.layer.sublayers! {
            divider.frame.size.width = menuSize.width
        }
        for subviews in menuView!.subviews {
            subviews.frame.size.width = menuSize.width
        }

        arrowView!.setNeedsLayout()
        arrowView!.setNeedsDisplay()
    }
    
    // MARK: Apply theme changes
    
    /*
     Apply all changes for parameters that are related to the design (theme) of the menu
     */
    private func applyTheme()
    {
        for divider in menuView!.layer.sublayers! {
            divider.backgroundColor = dividerColor.cgColor
        }
        for actionViews in menuView!.subviews {
            for subview in actionViews.subviews {
                if let label = subview as? UILabel {
                    if label.tag == 1 {
                        label.textColor = textColor
                        label.font = labelFont
                    }
                }
            }
        }
        
        overlayView?.backgroundColor = overlayColor

        arrowView?.color = menuColor
        arrowView!.setNeedsDisplay()
        
        menuView!.backgroundColor = menuColor
    }

    // MARK: Touch handler
    
    /*
     Did we moved out of the touch area?
     */
    private var movedOutOfSourceButton = false
    
    /*
     Selected action
     */
    private var selectedAction : Int? = nil
    
    /*
     touchesBegan()
     */
    public func menuTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            if bounds.contains(point) {
                if !isOpen {
                    show()
                }
                else {
                    hide()
                }
            }
            
            movedOutOfSourceButton = false
        }
    }
    
    /*
     touchesMoved()
     */
    public func menuTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            if !bounds.contains(point) {
                movedOutOfSourceButton = true
            }
            // Check if action is selected
            if isOpen {
                var selectedNow : Int? = nil
                for subview in menuView!.subviews {
                    let subviewInSelf = subview.convert(subview.bounds, to: self)
                    if subviewInSelf.contains(point)
                    {
                        subview.backgroundColor = selectedColor
                        selectedNow = subview.tag
                    }
                    else {
                        subview.backgroundColor = .clear
                    }
                }

                if selectedNow != selectedAction {
                    // Haptic feedback
                    if #available(iOS 10.0, *) {
                        if selectedNow != nil {
                            let generator = UISelectionFeedbackGenerator()
                            generator.selectionChanged()
                        }
                    }
                    selectedAction = selectedNow
                }
            }
        }
    }
    
    /*
     touchesEnded()
     */
    public func menuTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            
            let menuArea = menuView?.convert(menuView!.bounds, to: self)
            let arrowArea = arrowView?.convert(menuView!.bounds, to: self)
            let touchArea = bounds
            
            // Hide when on "source" view
            if bounds.contains(point) {
                if isOpen && movedOutOfSourceButton {
                    hide()
                }
            }
            // Hide when moved outside of menu
            if !arrowArea!.contains(point) && !menuArea!.contains(point) && !touchArea.contains(point) {
                if isOpen {
                    hide()
                }
            }
            // Check if action is selected
            if isOpen {
                for subview in menuView!.subviews {
                    let subviewArea = subview.convert(subview.bounds, to: self)
                    if subviewArea.contains(point) {
                        if actions.indices.contains(subview.tag) {
                            let action = actions[subview.tag]
                            action.selected(self)
                        }
                        subview.backgroundColor = .clear
                        hide()
                        break
                    }
                }
            }
        }
    }
}
