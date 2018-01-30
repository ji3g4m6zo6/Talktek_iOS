//
//  ViewMoreViewController.swift
//  talkTek
//
//  Created by Mac on 2018/1/29.
//  Copyright © 2018年 Talktek Inc. All rights reserved.
//

import UIKit

class ViewMoreViewController: UIViewController {
  
  var homeCourses_Array = [HomeCourses]()

  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
