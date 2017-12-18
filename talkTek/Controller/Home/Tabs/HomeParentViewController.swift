//
//  HomeParentViewController.swift
//  talkTek
//
//  Created by Mac on 2017/12/9.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class HomeParentViewController: ButtonBarPagerTabStripViewController {
  
  let tealish = UIColor.tealish()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    settings.style.buttonBarBackgroundColor = .white
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.selectedBarBackgroundColor = UIColor.tealish()
    settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
    settings.style.selectedBarHeight = 1.0
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.buttonBarItemTitleColor = UIColor.tealish()
    settings.style.buttonBarItemsShouldFillAvailiableWidth = true
    settings.style.buttonBarLeftContentInset = 0
    settings.style.buttonBarRightContentInset = 0
    changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
      guard changeCurrentIndex == true else { return }
      oldCell?.label.textColor = UIColor.lightGray
      newCell?.label.textColor = self?.tealish
    }
    /*
     let LogInVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainLogInViewController") as! MainLogInViewController
     self.present(LogInVC, animated: true, completion: nil)*/
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Hot")
    let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Pro")
    let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Life")
    let child_4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Others")
    return [child_1, child_2, child_3, child_4]
  }
  
  
  
}
