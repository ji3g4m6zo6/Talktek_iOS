//
//  MainTabBarViewController.swift
//  talkTek
//
//  Created by 李昀 on 2018/5/13.
//  Copyright © 2018 Talktek Inc. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
 var previousIndex = 0
  var tabBarTitle = ["home", "course", "setting"]
  
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    guard let items = tabBar.items else { return }
    if let tabIndex = items.index(of: item) {
      Analytics.logEvent("\(tabBarTitle[previousIndex])2\(tabBarTitle[tabIndex])_bnav_open", parameters: nil)
      previousIndex = tabIndex
    }
    
  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
