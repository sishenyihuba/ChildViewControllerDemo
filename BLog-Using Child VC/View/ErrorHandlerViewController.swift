//
//  ErrorHandlerViewController.swift
//  BLog-Using Child VC
//
//  Created by macache on 2018/4/28.
//  Copyright © 2018年 macache. All rights reserved.
//

import UIKit
class ErrorHandlerViewController : UIViewController{
  
  var reloadHandler: () -> Void = {}
  
  private lazy var reloadButton : UIButton = {
    let button =  UIButton(type: UIButtonType.custom)
    button.backgroundColor = #colorLiteral(red: 0.171055764, green: 0.6274157763, blue: 0.5123413205, alpha: 1)
    button.setTitle("数据获取错误，请重试", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.926155746, green: 0.9410773516, blue: 0.9455420375, alpha: 1), for: .normal)
    button.layer.cornerRadius = 20
    button.layer.masksToBounds = true
    button.addTarget(self, action: #selector(reloadButtonDidTouch), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    reloadButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(reloadButton)
    NSLayoutConstraint.activate([
      reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      reloadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      reloadButton.widthAnchor.constraint(equalToConstant: 300),
      reloadButton.heightAnchor.constraint(equalToConstant: 40)
      ])
  }

  @objc func reloadButtonDidTouch() {
    reloadHandler()
  }
}
