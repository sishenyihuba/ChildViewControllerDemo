//
//  UIViewController + Extension.swift
//  BLog-Using Child VC
//
//  Created by macache on 2018/4/25.
//  Copyright © 2018年 macache. All rights reserved.
//

import UIKit

extension UIViewController {
  func add(_ child : UIViewController) {
    self.addChildViewController(child)
    view.addSubview(child.view)
    child.didMove(toParentViewController: self)
  }
  
  func remove() {
    guard parent != nil else {
      return
    }
    willMove(toParentViewController: nil)
    removeFromParentViewController()
    view.removeFromSuperview()
    
  }
}
