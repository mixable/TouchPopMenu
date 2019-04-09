//
//  TouchHandler.swift
//  TouchPopMenu
//
//  Created by Mathias Lipowski on 03.04.19.
//  Copyright © 2019 mixable. All rights reserved.
//

import Foundation

public protocol TouchHandlerDelegate: class
{
    func menuTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    func menuTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    func menuTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
}

public class TouchHandlerView : UIView
{
    public weak var touchDelegate: TouchHandlerDelegate?

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        touchDelegate?.menuTouchesBegan(touches, with: event)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        touchDelegate?.menuTouchesMoved(touches, with: event)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        touchDelegate?.menuTouchesEnded(touches, with: event)
    }
}
