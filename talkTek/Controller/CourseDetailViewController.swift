//
//  CourseDetailViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/21.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  enum DetailViewSection: Int{
    case main = 0
    case courseInfo = 1
    case teacherInfo = 2
    case courses = 3
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
}
