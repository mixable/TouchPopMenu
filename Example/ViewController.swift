//
//  ViewController.swift
//  TouchPopMenu
//
//  Created by Mathias Lipowski on 01.04.19.
//  Copyright © 2019 Mathias Lipowski. All rights reserved.
//

import UIKit

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
        
        let menu = TouchPopMenu(for: buttonCenter)
        menu.position = .auto
        menu.addAction(action: TouchPopMenuAction(title: "Image"))
        menu.addAction(action: TouchPopMenuAction(title: "File / Attachment"))
        menu.attach()
        
        let menu1 = TouchPopMenu(for: buttonTopLeft)
        menu1.position = .auto
        menu1.addAction(action: TouchPopMenuAction(title: "Image"))
        menu1.addAction(action: TouchPopMenuAction(title: "File / Attachment"))
        menu1.attach()

        let menu2 = TouchPopMenu(for: buttonTopRight)
        menu2.position = .auto
        menu2.addAction(action: TouchPopMenuAction(title: "Image"))
        menu2.addAction(action: TouchPopMenuAction(title: "File / Attachment"))
        menu2.attach()

        let menu3 = TouchPopMenu(for: buttonBottomLeft)
        menu3.position = .auto
        menu3.addAction(action: TouchPopMenuAction(title: "Image"))
        menu3.addAction(action: TouchPopMenuAction(title: "File / Attachment"))
        menu3.attach()

        let menu4 = TouchPopMenu(for: buttonBottomRight)
        menu4.position = .auto
        menu4.addAction(action: TouchPopMenuAction(title: "Image"))
        menu4.addAction(action: TouchPopMenuAction(title: "File / Attachment"))
        menu4.attach()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

