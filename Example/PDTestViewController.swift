//
//  PDTestViewController.swift
//  Example
//
//  Created by 奥尔良小短腿 on 2024/4/3.
//

import UIKit
import Panda

class PDTestViewController: PDViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.canSideBack = true
        self.pd_backgroundColor(.random)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print(self.navigationBar.frame)
        print(SizeUtils.navigationFullHeight)
        print(self.navigationBar.isHidden)
        
    }

}
