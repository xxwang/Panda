//
//  ViewController.swift
//  Example
//
//  Created by xxwang on 2023/6/3.
//

import Panda
import UIKit

class ViewController: PDViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pd_backgroundColor(.green)
        Panda.sayHello()
    }
}

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let testVC = PDTestViewController()
        testVC.canSideBack = true
        self.push(viewController: testVC)
        
    }
}
