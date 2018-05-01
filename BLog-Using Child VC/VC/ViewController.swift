//
//  ViewController.swift
//  BLog-Using Child VC
//
//  Created by macache on 2018/4/25.
//  Copyright © 2018年 macache. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var dataLoader = DataLoader()
  let errorVC = ErrorHandlerViewController()
  
  @IBOutlet weak var resultTextView: UITextView!
  @IBOutlet weak var loadDataButton: UIButton!
  @IBOutlet weak var loadButton: UIButton!
  
  @IBAction func loadItems(_ sender: UIButton) {
    let loadingVC = LoadingViewController()
    self.add(loadingVC)

    //开始网络请求，加载数据
    dataLoader.loadItems(failedWithError: { [weak self] (error) in
      //拿到返回结果之后remove掉菊花
      loadingVC.remove()
      //展示错误视图
      if (error != nil) {
          self?.showError()
      } else {
        //没有错误，提示成功
        self?.errorVC.remove()
        self?.resultTextView.text = "这是我获取的正确数据：请关注我的简书Blog：https://www.jianshu.com/u/395eedc160ca"
        self?.loadDataButton.isHidden = true
      }
    })
  }
  
  func showError() {
    errorVC.reloadHandler = {[weak self] in
      self?.errorVC.remove()
      self?.loadItems(self!.loadButton)
    }
    self.add(errorVC)
  }
}

