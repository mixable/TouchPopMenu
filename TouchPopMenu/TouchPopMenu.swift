//
//  TouchPopMenu.swift
//  Example
//
//  Created by Mathias Lipowski on 01.04.19.
//  Copyright © 2019 Mathias Lipowski. All rights reserved.
//

import UIKit

class TouchPopMenu : UIView
{
    /*
     Position of the menu
     */
    public enum Position {
        case auto
        case left
        case top
        case right
        case bottom
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
    var position : Position = .auto

    /*
     Corner radius of menu content view
     */
    var cornerRadius : CGFloat = 10.0

    /*
     Background color of the overlay view
     */
    var overlayColor : UIColor = UIColor(white: 0.0, alpha: 0.05)

    /*
     Background color of the menu content view
     */
    var menuColor : UIColor = .white

    /*
     Text color of the menu actions
     */
    var textColor : UIColor = .black
    
    /*
     Size of the arrow triangle
     */
    var arrowLength : CGFloat = 15.0
    
    /*
     Height of action labels
     */
    var labelHeight : CGFloat = 40.0
    
    /*
     Horizontal spacing of label text
     */
    var labelInset : CGFloat = 15.0

    /*
     Space between menu and screen edges
     */
    var screenInset : CGFloat = 8.0

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
    private var contentView : UIView?
    private var arrowView : ArrowView?

    private var contentSize : CGSize = CGSize.zero
    
    /*
     Init
     */
    init(pointTo view: UIView)
    {
        source = .view
        sourceView = view
        
        super.init(frame: UIScreen.main.bounds)

        layoutMenu()
    }

    init(pointTo button: UIButton)
    {
        source = .button
        sourceButton = button

        super.init(frame: UIScreen.main.bounds)
        
        layoutMenu()
    }
    
    init(pointTo barButtonItem: UIBarButtonItem)
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
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 6.0
        layer.shouldRasterize = true
        
        // Create content view
        contentView = UIView()

        contentView!.layer.cornerRadius = cornerRadius;
        contentView!.layer.masksToBounds = true;
        contentView!.backgroundColor = menuColor
        addSubview(contentView!)
            
        // Create arrow view
        arrowView = ArrowView(origin: CGPoint(x: arrowOrigin.x, y: arrowOrigin.y),
                              position: menuPosition,
                              length: arrowLength,
                              color: self.menuColor)
        addSubview(arrowView!)

        // TODO: required?
        sourceButton?.isUserInteractionEnabled = true
        isUserInteractionEnabled = true

        if source == .view {
            sourceView?.superview?.addSubview(self)
            setNeedsLayout()

            let recognizer = TouchGestureRecognizer(target:self,
                                                    action:#selector(touched))
            sourceView?.addGestureRecognizer(recognizer)
        }
        if source == .button {
            sourceButton?.superview?.addSubview(self)
            setNeedsLayout()

            let recognizer = TouchGestureRecognizer(target:self,
                                                    action:#selector(touched))
            sourceButton?.addGestureRecognizer(recognizer)
        }
    }
    
    /*
     Show menu
     */
    func show() {
        isHidden = false
    }
    
    /*
     Hide menu
     */
    func hide() {
        isHidden = true
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
            
            if menuPosition == .left {
                return CGPoint(x: sourceCenter.x - (sourceSize.width / 2) - arrowLength,
                               y: sourceCenter.y - arrowLength)
            }
            if menuPosition == .top {
                return CGPoint(x: sourceCenter.x - arrowLength,
                               y: sourceCenter.y - (sourceSize.height / 2) - arrowLength)
            }
            if menuPosition == .right {
                return CGPoint(x: sourceCenter.x + (sourceSize.width / 2),
                               y: sourceCenter.y - arrowLength)
            }
            if menuPosition == .bottom {
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
                        return .bottom
                    } else {
                        return .top
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
            if menuPosition == .top {
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
            if menuPosition == .right {
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
            if menuPosition == .bottom {
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
            return CGPoint.zero
        }
    }
    
    /*
     Add an action to the menu
     */
    func addAction(action: TouchPopMenuAction)
    {
        actions.append(action)
        initActions()
    }
    
    /*
     Remove an action from the menu
     */
    func removeAction(action: TouchPopMenuAction)
    {
        actions = actions.filter() { $0 !== action }
        initActions()
    }
    
    /*
     Remove all actions from the menu
     */
    func removeAllActions()
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
        for action in actions
        {
            let size: CGSize = action.title.size(withAttributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)
            ])
            let label = UILabel(frame: CGRect(x: labelInset,
                                              y: contentSize.height,
                                              width: size.width,
                                              height: labelHeight))
            label.font = UIFont.systemFont(ofSize: 14.0)
            label.text = action.title
            label.textColor = textColor

            contentView!.addSubview(label)
            contentSize.height += labelHeight
            if size.width + (labelInset * 2) > contentSize.width {
                contentSize.width = size.width + (labelInset * 2)
            }
        }
        setNeedsDisplay()
    }

    override func layoutSubviews()
    {
        super.layoutSubviews()

        // Update frames
        frame = UIScreen.main.bounds

        contentView!.frame = CGRect(x: contentOrigin.x,
                                    y: contentOrigin.y,
                                    width: contentSize.width,
                                    height: contentSize.height)
                                    
        arrowView!.origin = arrowOrigin
        arrowView!.position = menuPosition
        arrowView!.setNeedsLayout()
        arrowView!.setNeedsDisplay()
    }

    @objc func touched()
    {
        // do something here
        show()
        NSLog("touched ...")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        NSLog("touchesBegan ...")
        if let touch = touches.first
        {
            let point = touch.location(in: self)
            if (sourceFrame.contains(point)) {
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        NSLog("touchesMoved ...")
        if let touch = touches.first
        {
            let point = touch.location(in: self)
            if (sourceFrame.contains(point)) {
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        NSLog("touchesEnded ...")
        if let touch = touches.first
        {
            let point = touch.location(in: self)

            // Hide when on sourceView
            if (sourceFrame.contains(point)) {
                hide()
            }
            // Hide when outside of menu
            let contentFrame = contentView?.frame
            let arrowFrame = arrowView?.frame
            if (!arrowFrame!.contains(point) && !contentFrame!.contains(point)) {
                hide()
            }
        }
    }
}
