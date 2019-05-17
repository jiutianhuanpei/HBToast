//
//  ViewController.swift
//  HBToastDemo
//
//  Created by 沈红榜 on 2019/5/17.
//  Copyright © 2019 沈红榜. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        
        HBToast.show("666666").dismiss(4).canTouchThrough = true
        
    }
    

}

