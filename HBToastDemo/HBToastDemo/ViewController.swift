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

    @IBAction func showToast(_ sender: Any) {
        let toast = HBToast.show("666", in: view.window)
        toast.canTouchThrough = true
        toast.textColor = .red
        toast.font = .systemFont(ofSize: 40)
    }
    
    @IBAction func dismissToast(_ sender: Any) {
        HBToast.dismiss()
    }
    

}

