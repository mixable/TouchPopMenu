//
//  TouchPopMenu.swift
//  Example
//
//  Created by Mathias Lipowski on 01.04.19.
//  Copyright © 2019 Mathias Lipowski. All rights reserved.
//

import UIKit

public class TouchPopMenu : UIView, TouchHandlerDelegate
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
    public enum Source {
        case view
        case button
        case barButtonItem
    }

    /*
     Position relative to source view
     */
    public var position : Position = .auto

    /*
     Corner radius of menu content view
     */
    public var cornerRadius : CGFloat = 10.0

    /*
     Background color of the overlay view
     */
    public var overlayColor : UIColor = UIColor(white: 0.0, alpha: 0.05)

    /*
     Background color of the menu content view
     */
    public var menuColor : UIColor = .white

    /*
     Background color of the selected action
     */
    public var selectedColor : UIColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)

    /*
     Text color of the menu actions
     */
    public var textColor : UIColor = .black
    
    /*
     Text color of the menu action divider
     */
    public var dividerColor : UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    
    /*
     Size of the arrow triangle
     */
    public var arrowLength : CGFloat = 15.0
    
    /*
     Height of action labels
     */
    public var labelHeight : CGFloat = 40.0
    
    /*
     Horizontal spacing of label text
     */
    public var labelInset : CGFloat = 15.0

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
    
    /*
     Source to attach the menu
     */
    private var source : Source = .view
    
    private var sourceView : UIView?
    private var sourceButton : UIButton?
    private var sourceBarButtonItem : UIBarButtonItem?

    /*
     Actions
     */
    private var actions : [TouchPopMenuAction] = [TouchPopMenuAction]()

    /*
     Menu views
     */
    private var containerView : UIView?
    private var touchView : TouchHandlerView = TouchHandlerView()
    private var contentView : UIView?
    private var arrowView : ArrowView?

    private var contentSize : CGSize = CGSize.zero
    
    /*
     Init
     */
    public init(pointTo view: UIView)
    {
        source = .view
        sourceView = view
        
        super.init(frame: UIScreen.main.bounds)

        layoutMenu()
    }

    public init(pointTo button: UIButton)
    {
        source = .button
        sourceButton = button

        super.init(frame: UIScreen.main.bounds)
        
        layoutMenu()
    }
    
    public init(pointTo barButtonItem: UIBarButtonItem)
    {
        source = .barButtonItem
        sourceBarButtonItem = barButtonItem

        super.init(frame: UIScreen.main.bounds)
        
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
        isHidden = true
        clipsToBounds = false
        layer.masksToBounds = false
        layer.backgroundColor = overlayColor.cgColor
        
        // Create touch view
        touchView.frame = sourceFrame
        touchView.backgroundColor = .clear
        touchView.touchDelegate = self
        
        if source == .view {
            sourceView?.superview?.addSubview(touchView)
            sourceView?.superview?.bringSubviewToFront(touchView)
        }
        if source == .button {
            sourceButton?.superview?.addSubview(touchView)
            sourceButton?.superview?.bringSubviewToFront(touchView)
        }
        
        // Create container view
        containerView = UIView(frame: UIScreen.main.bounds)
        containerView!.layer.masksToBounds = false
        containerView!.layer.backgroundColor = UIColor.clear.cgColor
        containerView!.layer.shadowColor = UIColor.black.cgColor
        containerView!.layer.shadowOffset = CGSize.zero
        containerView!.layer.shadowOpacity = 0.1
        containerView!.layer.shadowRadius = 25.0
        containerView!.layer.shouldRasterize = true
        addSubview(containerView!)
        
        // Create content view
        contentView = UIView()
        contentView!.layer.cornerRadius = cornerRadius;
        contentView!.layer.masksToBounds = true;
        contentView!.backgroundColor = menuColor
        containerView!.addSubview(contentView!)
            
        // Create arrow view
        arrowView = ArrowView(origin: CGPoint(x: arrowOrigin.x, y: arrowOrigin.y),
                              position: menuPosition,
                              length: arrowLength,
                              color: self.menuColor)
        containerView!.addSubview(arrowView!)

        // TODO: required?
        sourceButton?.isUserInteractionEnabled = true
        isUserInteractionEnabled = true

        if source == .view {
            sourceView?.superview?.addSubview(self)
            sourceView?.superview?.sendSubviewToBack(self)
            setNeedsLayout()
        }
        if source == .button {
            sourceButton?.superview?.addSubview(self)
            sourceButton?.superview?.sendSubviewToBack(self)
            setNeedsLayout()
        }
    }
    
    /*
     Show menu
     */
    public func show()
    {
        if source == .view {
            sourceView?.superview?.bringSubviewToFront(self)
        }
        if source == .button {
            sourceButton?.superview?.bringSubviewToFront(self)
        }

        if menuPosition == .left || menuPosition == .leftUp || menuPosition == .leftDown
        {
            containerView!.layer.opacity = 0
            containerView!.frame.origin.x = animationOffset
            layer.opacity = 0
            isHidden = false
        }
        else if menuPosition == .up || menuPosition == .upLeft || menuPosition == .upRight
        {
            containerView!.layer.opacity = 0
            containerView!.frame.origin.y = animationOffset
            layer.opacity = 0
            isHidden = false
        }
        else if menuPosition == .right || menuPosition == .rightUp || menuPosition == .rightDown
        {
            containerView!.layer.opacity = 0
            containerView!.frame.origin.x = -animationOffset
            layer.opacity = 0
            isHidden = false
        }
        else if menuPosition == .down || menuPosition == .downLeft || menuPosition == .downRight
        {
            containerView!.layer.opacity = 0
            containerView!.frame.origin.y = -animationOffset
            layer.opacity = 0
            isHidden = false
        }
        
        UIView.animate(withDuration: self.animationDuration, delay: 0, options: [.curveEaseIn], animations: {
            self.containerView!.frame.origin.x = 0
            self.containerView!.frame.origin.y = 0
            self.containerView!.layer.opacity = 1
            self.layer.opacity = 1
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
    public func hide()
    {
        containerView!.layer.opacity = 1
        layer.opacity = 1

        UIView.animate(withDuration: self.animationDuration, delay: 0, options: [.curveEaseIn], animations: {
            if self.menuPosition == .left || self.menuPosition == .leftUp || self.menuPosition == .leftDown
            {
                self.containerView!.layer.opacity = 0
                self.containerView!.frame.origin.x = self.animationOffset
                self.layer.opacity = 0
            }
            else if self.menuPosition == .up || self.menuPosition == .upLeft || self.menuPosition == .upRight
            {
                self.containerView!.layer.opacity = 0
                self.containerView!.frame.origin.y = self.animationOffset
                self.layer.opacity = 0
            }
            else if self.menuPosition == .right || self.menuPosition == .rightUp || self.menuPosition == .rightDown
            {
                self.containerView!.layer.opacity = 0
                self.containerView!.frame.origin.x = -self.animationOffset
                self.layer.opacity = 0
            }
            else if self.menuPosition == .down || self.menuPosition == .downLeft || self.menuPosition == .downRight
            {
                self.containerView!.layer.opacity = 0
                self.containerView!.frame.origin.y = -self.animationOffset
                self.layer.opacity = 0
            }
        }, completion: { (finished: Bool) in
            self.isHidden = true
            
            if self.source == .view {
                self.sourceView?.superview?.sendSubviewToBack(self)
            }
            if self.source == .button {
                self.sourceButton?.superview?.sendSubviewToBack(self)
            }
        })

        isOpen = false
    }
    
    /*
     Frame of the source view
     */
    private var sourceFrame : CGRect {
        get {
            if source == .view {
                return sourceView!.frame
            }
            if source == .button {
                return sourceButton!.frame
            }
            if source == .barButtonItem {
                return (sourceBarButtonItem!.value(forKey: "view") as? UIView)!.frame
            }
            return CGRect.zero
        }
    }
    
    /*
     Center point of source view
     */
    private var sourceCenter: CGPoint {
        get {
            let source = sourceFrame
            return CGPoint(x: source.origin.x + source.size.width / 2,
                           y: source.origin.y + source.size.height / 2)
        }
    }

    /*
     Origin of arrow view
     */
    private var arrowOrigin : CGPoint {
        get {
            let sourceSize = sourceFrame.size
            
            if menuPosition == .left || menuPosition == .leftUp || menuPosition == .leftDown {
                return CGPoint(x: sourceCenter.x - (sourceSize.width / 2) - arrowLength,
                               y: sourceCenter.y - arrowLength)
            }
            if menuPosition == .up || menuPosition == .upLeft || menuPosition == .upRight {
                return CGPoint(x: sourceCenter.x - arrowLength,
                               y: sourceCenter.y - (sourceSize.height / 2) - arrowLength)
            }
            if menuPosition == .right || menuPosition == .rightUp || menuPosition == .rightDown {
                return CGPoint(x: sourceCenter.x + (sourceSize.width / 2),
                               y: sourceCenter.y - arrowLength)
            }
            if menuPosition == .down || menuPosition == .downLeft || menuPosition == .downRight {
                return CGPoint(x: sourceCenter.x - arrowLength,
                               y: sourceCenter.y + (sourceSize.height / 2))
            }
            return CGPoint.zero
        }
    }

    /*
     Calculated position
     */
    private var menuPosition: Position {
        get {
            if position == .auto {
                // Calculate position of menu
                let screenSize = UIScreen.main.bounds
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
     Origin of content view
     */
    private var contentOrigin : CGPoint {
        get {
            let screenSize = UIScreen.main.bounds
            let sourceSize = sourceFrame.size

            if menuPosition == .left {
                let x = sourceCenter.x - (sourceSize.width / 2) - arrowLength - contentSize.width
                var y = sourceCenter.y - (contentSize.height / 2)
                if y < screenInset {
                    y = screenInset
                }
                if y + contentSize.height > screenSize.height - screenInset {
                    y = screenSize.height - contentSize.height - screenInset
                }
                return CGPoint(x: x, y: y)
            }
            else if menuPosition == .leftUp {
                let x = sourceCenter.x - (sourceSize.width / 2) - arrowLength - contentSize.width
                let y = sourceCenter.y - contentSize.height + arrowLength + cornerRadius
                return CGPoint(x: x, y: y)
            }
            else if menuPosition == .leftDown {
                let x = sourceCenter.x - (sourceSize.width / 2) - arrowLength - contentSize.width
                let y = sourceCenter.y - arrowLength - cornerRadius
                return CGPoint(x: x, y: y)
            }
            else if menuPosition == .up {
                var x = sourceCenter.x - (contentSize.width / 2)
                let y = sourceCenter.y - (sourceSize.height / 2) - arrowLength - contentSize.height
                if x < screenInset {
                    x = screenInset
                }
                if x + contentSize.width > screenSize.width - screenInset {
                    x = screenSize.width - contentSize.width - screenInset
                }
                return CGPoint(x: x, y: y)
            }
            else if menuPosition == .upLeft {
                let x = sourceCenter.x - contentSize.width + arrowLength + cornerRadius
                let y = sourceCenter.y - (sourceSize.height / 2) - arrowLength - contentSize.height
                return CGPoint(x: x, y: y)
            }
            else if menuPosition == .upRight {
                let x = sourceCenter.x - arrowLength - cornerRadius
                let y = sourceCenter.y - (sourceSize.height / 2) - arrowLength - contentSize.height
                return CGPoint(x: x, y: y)
            }
            else if menuPosition == .right {
                let x = sourceCenter.x + (sourceSize.width / 2) + arrowLength
                var y = sourceCenter.y - (contentSize.height / 2)
                if y < screenInset {
                    y = screenInset
                }
                if y + contentSize.height > screenSize.height - screenInset {
                    y = screenSize.height - contentSize.height - screenInset
                }
                return CGPoint(x: x, y: y)
            }
            else if menuPosition == .rightUp {
                let x = sourceCenter.x + (sourceSize.width / 2) + arrowLength
                let y = sourceCenter.y - contentSize.height + arrowLength + cornerRadius
                return CGPoint(x: x, y: y)
            }
            else if menuPosition == .rightDown {
                let x = sourceCenter.x + (sourceSize.width / 2) + arrowLength
                let y = sourceCenter.y - arrowLength - cornerRadius
                return CGPoint(x: x, y: y)
            }
            else if menuPosition == .down {
                var x = sourceCenter.x - (contentSize.width / 2)
                let y = sourceCenter.y + (sourceSize.height / 2) + arrowLength
                if x < screenInset {
                    x = screenInset
                }
                if x + contentSize.width > screenSize.width - screenInset {
                    x = screenSize.width - contentSize.width - screenInset
                }
                return CGPoint(x: x, y: y)
            }
            else if menuPosition == .downLeft {
                let x = sourceCenter.x - contentSize.width + arrowLength + cornerRadius
                let y = sourceCenter.y + (sourceSize.height / 2) + arrowLength
                return CGPoint(x: x, y: y)
            }
            else if menuPosition == .downRight {
                let x = sourceCenter.x - arrowLength - cornerRadius
                let y = sourceCenter.y + (sourceSize.height / 2) + arrowLength
                return CGPoint(x: x, y: y)
            }
            return CGPoint.zero
        }
    }
    
    /*
     Add an action to the menu
     */
    public func addAction(action: TouchPopMenuAction)
    {
        self.actions.append(action)
        self.initActions()
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
        contentView!.subviews.forEach({ $0.removeFromSuperview() })
        contentSize = CGSize.zero

        // Create views for each action
        for (index, action) in actions.enumerated()
        {
            let size: CGSize = action.title.size(withAttributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)
            ])
            let actionView = UIView(frame: CGRect(x: 0,
                                                  y: contentSize.height,
                                                  width: size.width + labelInset * 2,
                                                  height: labelHeight))

            // Use tag to retrieve action for this view
            actionView.tag = index

            let label = UILabel(frame: CGRect(x: labelInset,
                                              y: 0,
                                              width: size.width,
                                              height: labelHeight))
            label.font = UIFont.systemFont(ofSize: 14.0)
            label.text = action.title
            label.textColor = textColor
            actionView.addSubview(label)
            
            // Add border (= top border of label)
            if index > 0 {
                let borderLayer = CALayer()
                borderLayer.frame = CGRect(x: 0, y: contentSize.height, width: label.frame.width, height: 1)
                borderLayer.backgroundColor = dividerColor.cgColor
                contentView!.layer.addSublayer(borderLayer)
            }

            contentView!.addSubview(actionView)
            contentSize.height += labelHeight
            if size.width + (labelInset * 2) > contentSize.width {
                contentSize.width = size.width + (labelInset * 2)
            }
        }
        setNeedsDisplay()
    }

    override public func layoutSubviews()
    {
        super.layoutSubviews()

        // Update frames
        frame = UIScreen.main.bounds
        touchView.frame = sourceFrame
        containerView!.frame = UIScreen.main.bounds
        contentView!.frame = CGRect(x: contentOrigin.x,
                                    y: contentOrigin.y,
                                    width: contentSize.width,
                                    height: contentSize.height)
        
        for divider in contentView!.layer.sublayers! {
            divider.frame.size.width = contentSize.width
        }
        for subviews in contentView!.subviews {
            subviews.frame.size.width = contentSize.width
        }

        arrowView!.origin = arrowOrigin
        arrowView!.position = menuPosition
        arrowView!.setNeedsLayout()
        arrowView!.setNeedsDisplay()
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            touchBegan(touch)
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            touchMoved(touch)
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            touchEnded(touch)
        }
    }

    public func menuTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            touchBegan(touch)
        }
    }
    
    public func menuTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            touchMoved(touch)
        }
    }
    
    public func menuTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            touchEnded(touch)
        }
    }
    
    private var movedOutOfSourceButton = false
    
    private func touchBegan(_ touch: UITouch)
    {
        let point = touch.location(in: self)
        if touchView.frame.contains(point) {
            if !isOpen {
                show()
            }
            else {
                hide()
            }
        }
        
        movedOutOfSourceButton = false
    }
    
    private func touchMoved(_ touch: UITouch)
    {
        let point = touch.location(in: self)
        if (sourceFrame.contains(point)) {
            movedOutOfSourceButton = true
        }
        // Check if action is selected
        if isOpen {
            for subview in contentView!.subviews {
                let subviewInSelf = subview.convert(subview.bounds, to: self)
                if subviewInSelf.contains(point)
                {
                    subview.backgroundColor = selectedColor

                    // Haptic feedback
                    if #available(iOS 10.0, *) {
                        let generator = UISelectionFeedbackGenerator()
                        generator.selectionChanged()
                    }
                }
                else {
                    subview.backgroundColor = .clear
                }
            }
        }
    }
    
    private func touchEnded(_ touch: UITouch)
    {
        let point = touch.location(in: self)
        
        let contentFrame = contentView?.frame
        let arrowFrame = arrowView?.frame
        let touchFrame = touchView.frame
        
        // Hide when on "source" view
        if touchFrame.contains(point) {
            if isOpen && movedOutOfSourceButton {
                hide()
            }
        }
        // Hide when moved outside of menu
        if !arrowFrame!.contains(point) && !contentFrame!.contains(point) && !touchFrame.contains(point) {
            if isOpen {
                hide()
            }
        }
        // Check if action is selected
        if isOpen {
            for subview in contentView!.subviews {
                let subviewInSelf = subview.convert(subview.bounds, to: self)
                if subviewInSelf.contains(point) {
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
