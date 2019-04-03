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
        
        let handlerBlock: () -> () = {
            print("Selected action!")
        }
        
        let menu = TouchPopMenu(pointTo: buttonCenter!)
        menu.position = .auto
        menu.addAction(action: TouchPopMenuAction(title: "Copy", selected: handlerBlock))
        menu.addAction(action: TouchPopMenuAction(title: "Paste", selected: handlerBlock))
        menu.addAction(action: TouchPopMenuAction(title: "Undo last action", selected: handlerBlock))
        menu.show()

        let menu1 = TouchPopMenu(pointTo: buttonTopLeft)
        menu1.position = .auto
        menu1.addAction(action: TouchPopMenuAction(title: "Copy", selected: handlerBlock))
        menu1.addAction(action: TouchPopMenuAction(title: "Paste", selected: handlerBlock))
        menu1.addAction(action: TouchPopMenuAction(title: "Undo last action", selected: handlerBlock))

        let menu2 = TouchPopMenu(pointTo: buttonTopRight)
        menu2.position = .auto
        menu2.addAction(action: TouchPopMenuAction(title: "Copy", selected: handlerBlock))
        menu2.addAction(action: TouchPopMenuAction(title: "Paste", selected: handlerBlock))
        menu2.addAction(action: TouchPopMenuAction(title: "Undo last action", selected: handlerBlock))

        let menu3 = TouchPopMenu(pointTo: buttonBottomLeft)
        menu3.position = .auto
        menu3.addAction(action: TouchPopMenuAction(title: "Copy", selected: handlerBlock))
        menu3.addAction(action: TouchPopMenuAction(title: "Paste", selected: handlerBlock))
        menu3.addAction(action: TouchPopMenuAction(title: "Undo last action", selected: handlerBlock))

        let menu4 = TouchPopMenu(pointTo: buttonBottomRight)
        menu4.position = .auto
        menu4.addAction(action: TouchPopMenuAction(title: "Copy", selected: handlerBlock))
        menu4.addAction(action: TouchPopMenuAction(title: "Paste", selected: handlerBlock))
        menu4.addAction(action: TouchPopMenuAction(title: "Undo last action", selected: handlerBlock))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

