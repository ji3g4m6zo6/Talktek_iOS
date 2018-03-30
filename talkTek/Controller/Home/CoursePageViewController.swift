//
//  CoursePageViewController.swift
//  talkTek
//
//  Created by 李昀 on 2018/3/28.
//  Copyright © 2018年 Talktek Inc. All rights reserved.
//

import UIKit

class CoursePageViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var audioDictionary = [Int: [AudioItem]]()

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  enum DetailViewSection: Int{
    case main = 0
    case courseInfo = 1
    case teacherInfo = 2
    case courses = 3
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

extension CoursePageViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case DetailViewSection.main.rawValue:
      return 1
    case DetailViewSection.courseInfo.rawValue:
      return 3
    case DetailViewSection.teacherInfo.rawValue:
      return 3
    case DetailViewSection.courses.rawValue:
      return 1 + audioDictionary.count + 1
    // header + sections + audiofiles + footer
    default:
      return 0
    }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    return UITableViewCell()
  }
}
