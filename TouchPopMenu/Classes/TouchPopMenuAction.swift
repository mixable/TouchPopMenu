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
    public var selected : (_ menu : TouchPopMenu) -> ()

    public init(title: String,
                selected: @escaping (_ menu : TouchPopMenu) -> () )
    {
        self.title = title
        self.selected = selected
    }
}
