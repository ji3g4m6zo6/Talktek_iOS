//
//  CourseDetailViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/21.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController {
  
  var detailToGet = HomeCourses()
  
  @IBOutlet weak var buy_View: UIView!
  
  @IBOutlet weak var buy_Button: UIButton!
  
  @IBAction func buy_Button_Tapped(_ sender: UIButton) {
  }
  
  @IBOutlet weak var cost_Label: UILabel!
  
  
  @IBOutlet weak var tableView: UITableView!
  enum DetailViewSection: Int{
    case main = 0
    case courseInfo = 1
    case teacherInfo = 2
    case courses = 3
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    print(detailToGet.title ?? "")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
  
}
extension CourseDetailViewController: UITableViewDelegate, UITableViewDataSource{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case DetailViewSection.main.rawValue:
      return 1
    case DetailViewSection.courseInfo.rawValue:
      return 1
    case DetailViewSection.teacherInfo.rawValue:
      return 1
    case DetailViewSection.courses.rawValue:
      return 1
    default: fatalError()
    }
    
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case DetailViewSection.main.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: "main", for: indexPath) as! MainTableViewCell
      
      
      return cell
    case DetailViewSection.courseInfo.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: "courseInfo", for: indexPath) as! CourseInfoTableViewCell
     
      
      return cell
    case DetailViewSection.teacherInfo.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: "teacherInfo", for: indexPath) as! TeacherInfoTableViewCell
      
      return cell
    case DetailViewSection.courses.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: "courses", for: indexPath) as! CoursesTableViewCell
      
      return cell
    default: fatalError()
    }
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case DetailViewSection.main.rawValue:
      return 357.0
    case DetailViewSection.courseInfo.rawValue:
      return 200.0
    case DetailViewSection.teacherInfo.rawValue:
      return 249.0
    case DetailViewSection.courses.rawValue:
      return 591.0
    default:
      fatalError()
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case DetailViewSection.main.rawValue: break
      
    case DetailViewSection.courseInfo.rawValue: break
      
    case DetailViewSection.teacherInfo.rawValue:
      performSegue(withIdentifier: "identifierTeacher", sender: self)
    case DetailViewSection.courses.rawValue: break
      
    default: fatalError()
    }
  }
}
