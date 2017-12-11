//
//  HomeParentViewController.swift
//  talkTek
//
//  Created by Mac on 2017/12/9.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit

class HomeParentViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let LogInVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainLogInViewController") as! MainLogInViewController
    self.present(LogInVC, animated: true, completion: nil)
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
}
