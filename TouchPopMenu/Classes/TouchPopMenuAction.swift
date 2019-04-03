//
//  TouchPopMenuAction.swift
//  Example
//
//  Created by Mathias Lipowski on 01.04.19.
//  Copyright © 2019 Mathias Lipowski. All rights reserved.
//

import Foundation
import UIKit

public class TouchPopMenuAction
{
    public var title : String
    public var selected : () -> ()
    
    public init(title: String,
                selected: @escaping () -> () )
    {
        self.title = title
        self.selected = selected
    }
}
