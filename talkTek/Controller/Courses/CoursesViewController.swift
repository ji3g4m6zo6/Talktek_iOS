//
//  CoursesViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/23.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CoursesViewController: ButtonBarPagerTabStripViewController {
  
  
  let tealish = UIColor.tealish()

  override func viewDidLoad() {
    
    settings.style.buttonBarBackgroundColor = .white
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.selectedBarBackgroundColor = UIColor.tealish()
    settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
    settings.style.selectedBarHeight = CGFloat(1.0)
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
    super.viewDidLoad()

    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  override func viewControllers (for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Bought") as! CoursesBoughtViewController
    
    
    let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Heart") as! CoursesHeartViewController
    
    
    return [child_1, child_2]
  }
  
  
  
  
}
