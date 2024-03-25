//
//  Functions.swift
//  Panda-time
//
//  Created by 奥尔良小短腿 on 2023/7/19.
//

import UIKit

func configure<T: AnyObject>(_ object: T, closure: (T) -> Void) -> T {
    closure(object)
    return object
}
