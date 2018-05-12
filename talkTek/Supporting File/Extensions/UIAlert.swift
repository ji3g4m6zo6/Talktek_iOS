//
//  UIAlert.swift
//  talkTek
//
//  Created by 李昀 on 2018/5/10.
//  Copyright © 2018年 Talktek Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  func ShowAnonymousShouldLogInAlert(){
    let alert = UIAlertController(title: "您尚未登入", message: "請先登入，才能使用此功能", preferredStyle: .alert)
    
    let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
    alert.addAction(cancel)
    
    let confirm = UIAlertAction(title: "登入", style: .default) { (action) in
      if let mainLogInViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainLogInViewController") as? MainLogInViewController {
        self.present(mainLogInViewController, animated: true, completion: nil)
      }

    }
    alert.addAction(confirm)
    
    present(alert, animated: true, completion: nil)

  }
}

