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
    private var position: TouchPopMenu.Position = .left
    private var color: UIColor = .lightGray

    init(origin: CGPoint,
         length: CGFloat,
         position: TouchPopMenu.Position,
         color: UIColor = .lightGray)
    {
        self.position = position
        self.color = color
        
        var width = length * 2
        var height = length
        if position == .left || position == .right {
            width = length
            height = length * 2
        }
        if position == .top || position == .bottom {
            width = length * 2
            height = length
        }
        let frame = CGRect(x: origin.x, y: origin.y, width: width, height: height)
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect)
    {
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
