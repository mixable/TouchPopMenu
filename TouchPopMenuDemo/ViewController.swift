//
//  ViewController.swift
//  TouchPopMenu
//
//  Created by Mathias Lipowski on 01.04.19.
//  Copyright © 2019 Mathias Lipowski. All rights reserved.
//

import UIKit
import TouchPopMenu

class ViewController: UIViewController
{
    @IBOutlet weak var buttonCenter: UIButton!
    @IBOutlet weak var buttonTopLeft: UIButton!
    @IBOutlet weak var buttonTopRight: UIButton!
    @IBOutlet weak var buttonBottomLeft: UIButton!
    @IBOutlet weak var buttonBottomRight: UIButton!
    
    override func loadView()
    {
        super.loadView()
        
        let menu1 = TouchPopMenu(pointTo: buttonTopLeft, inController: self)
        menu1.position = .auto
        menu1.addAction(action: TouchPopMenuAction(title: "Copy", selected: { menu in print("Hello Copy") }))
        menu1.addAction(action: TouchPopMenuAction(title: "Paste", selected: { menu in print("Hello Paste") }))
        menu1.addAction(action: TouchPopMenuAction(title: "Undo last action", selected: { menu in print("Hello Undo") }))

        let menu2 = TouchPopMenu(pointTo: buttonTopRight, inController: self)
        menu2.position = .auto
        menu2.addAction(action: TouchPopMenuAction(title: "Copy", selected: { menu in print("Hello Copy") }))
        menu2.addAction(action: TouchPopMenuAction(title: "Paste", selected: { menu in print("Hello Paste") }))
        menu2.addAction(action: TouchPopMenuAction(title: "Undo last action", selected: { menu in print("Hello Undo") }))

        let menu3 = TouchPopMenu(pointTo: buttonBottomLeft, inController: self)
        menu3.position = .auto
        menu3.addAction(action: TouchPopMenuAction(title: "Copy", selected: { menu in print("Hello Copy") }))
        menu3.addAction(action: TouchPopMenuAction(title: "Paste", selected: { menu in print("Hello Paste") }))
        menu3.addAction(action: TouchPopMenuAction(title: "Undo last action", selected: { menu in print("Hello Undo") }))

        let menu4 = TouchPopMenu(pointTo: buttonBottomRight, inController: self)
        menu4.position = .auto
        menu4.addAction(action: TouchPopMenuAction(title: "Copy", selected: { menu in print("Hello Copy") }))
        menu4.addAction(action: TouchPopMenuAction(title: "Paste", selected: { menu in print("Hello Paste") }))
        menu4.addAction(action: TouchPopMenuAction(title: "Undo last action", selected: { menu in print("Hello Undo") }))

        let menu = TouchPopMenu(pointTo: buttonCenter, inController: self)
        menu.position = .down
        menu.addAction(action: TouchPopMenuAction(title: "Move to .leftUp", selected: { menu in menu.position = .leftUp }))
        menu.addAction(action: TouchPopMenuAction(title: "Move to .left", selected: { menu in menu.position = .left }))
        menu.addAction(action: TouchPopMenuAction(title: "Move to .leftDown", selected: { menu in menu.position = .leftDown }))
//        menu.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

