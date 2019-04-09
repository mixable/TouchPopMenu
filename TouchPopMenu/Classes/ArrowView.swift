//
//  ArrowView.swift
//  Example
//
//  Created by Mathias Lipowski on 01.04.19.
//  Copyright © 2019 Mathias Lipowski. All rights reserved.
//

import UIKit

class ArrowView : UIView
{
    var pointTo: UIView?
    var position: TouchPopMenu.Position = .left
    var length: CGFloat = 15.0
    public var color: UIColor = .lightGray
    
    private var widthConstraint : NSLayoutConstraint?
    private var heightConstraint : NSLayoutConstraint?

    init(pointTo: UIView,
         position: TouchPopMenu.Position,
         length: CGFloat = 15.0,
         color: UIColor = .lightGray)
    {
        self.pointTo = pointTo
        self.position = position
        self.length = length
        self.color = color

        super.init(frame: CGRect.zero)

        translatesAutoresizingMaskIntoConstraints = false
        widthConstraint = widthAnchor.constraint(equalToConstant: size.width)
        widthConstraint!.isActive = true
        heightConstraint = heightAnchor.constraint(equalToConstant: size.height)
        heightConstraint!.isActive = true

        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public var size : CGSize {
        get {
            if position == .left || position == .leftUp || position == .leftDown
                || position == .right || position == .rightUp || position == .rightDown {
                return CGSize(width: length, height: length * 2)
            }
            if position == .up || position == .upLeft || position == .upRight
                || position == .down || position == .downLeft || position == .downRight {
                return CGSize(width: length * 2, height: length)
            }
            return CGSize.zero
        }
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        widthConstraint!.constant = size.width
        heightConstraint!.constant = size.height
    }
    
    override func draw(_ rect: CGRect)
    {
        // Draw in graphics context
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
    
        if (position == .left || position == .leftUp || position == .leftDown) {
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
        if (position == .up || position == .upLeft || position == .upRight) {
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }
        if (position == .right || position == .rightUp || position == .rightDown) {
            context.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }
        if (position == .down || position == .downLeft || position == .downRight) {
            context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }
    
        context.closePath()
        context.setFillColor(color.cgColor)
        context.fillPath()
    }
}
