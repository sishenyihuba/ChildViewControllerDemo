//
//  DataLoader.swift
//  BLog-Using Child VC
//
//  Created by macache on 2018/4/27.
//  Copyright © 2018年 macache. All rights reserved.
//

import Foundation

class DataLoader {
  
  func loadItems(failedWithError: @escaping (NSError?) -> Void) {
    if (Constants.currentLoad <= 2) {
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
        let error = NSError(domain: "失败", code: 100, userInfo: nil)
        failedWithError(error)
      }
    } else {
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
        failedWithError(nil)
      }
    }
    Constants.currentLoad += 1
  }
}
