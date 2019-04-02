//
//  TouchGestureRecognizer.swift
//  Example
//
//  Created by Mathias Lipowski on 01.04.19.
//  Copyright © 2019 Mathias Lipowski. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class TouchGestureRecognizer : UIGestureRecognizer
{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent)
    {
        if self.state == .possible {
            self.state = .recognized
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent)
    {
        self.state = .failed
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent)
    {
        self.state = .failed
    }
}
