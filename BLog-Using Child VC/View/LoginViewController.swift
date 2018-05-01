//
//  LoginViewController.swift
//  BLog-Using Child VC
//
//  Created by macache on 2018/4/25.
//  Copyright © 2018年 macache. All rights reserved.
//

import UIKit

class LoadingViewController : UIViewController {
  private var indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    indicator.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(indicator)
    NSLayoutConstraint.activate([
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      ])
    
    indicator.startAnimating()
  }
  
  
  override func removeFromParentViewController() {
    indicator.stopAnimating()
    super.removeFromParentViewController()
  }
}
