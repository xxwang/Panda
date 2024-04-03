//
//  ViewController.swift
//  Example
//
//  Created by xxwang on 2023/6/3.
//

import Panda
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pd_backgroundColor(.green)
        Panda.sayHello()
    }
}
