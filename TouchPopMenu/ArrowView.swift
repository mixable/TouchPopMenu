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
    var origin: CGPoint = CGPoint.zero
    var position: TouchPopMenu.Position = .left
    var length: CGFloat = 15.0
    var color: UIColor = .lightGray

    init(origin: CGPoint,
         position: TouchPopMenu.Position,
         length: CGFloat = 15.0,
         color: UIColor = .lightGray)
    {
        self.origin = origin
        self.position = position
        self.length = length
        self.color = color

        super.init(frame: CGRect.zero) // The correct frame is calculated later
        
        frame = CGRect(x: origin.x,
                       y: origin.y,
                       width: arrowSize.width,
                       height: arrowSize.height)

        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    var arrowSize : CGSize {
        get {
            if position == .left || position == .right {
                return CGSize(width: length, height: length * 2)
            }
            if position == .top || position == .bottom {
                return CGSize(width: length * 2, height: length)
            }
            return CGSize.zero
        }
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()

        // Update frame
        frame = CGRect(x: origin.x,
                       y: origin.y,
                       width: arrowSize.width,
                       height: arrowSize.height)
    }
    
    override func draw(_ rect: CGRect)
    {
        // Draw in graphics context
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
    
        if (position == .left) {
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY / 2))
            context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
        if (position == .top) {
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX / 2, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }
        if (position == .right) {
            context.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY / 2))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }
        if (position == .bottom) {
            context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX / 2, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }
    
        context.closePath()
        context.setFillColor(color.cgColor)
        context.fillPath()
    }
}
