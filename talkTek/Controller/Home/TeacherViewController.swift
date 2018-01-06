//
//  TeacherViewController.swift
//  talkTek
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit

class TeacherViewController: UIViewController {
  
  
  @IBOutlet weak var tableView: UITableView!
  var idToGet = ""
  var courseToGet = HomeCourses()
  
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
  override func viewWillAppear(_ animated: Bool) {
    if let index = self.tableView.indexPathForSelectedRow{
      self.tableView.deselectRow(at: index, animated: true)
    }
  }
  enum DetailViewSection: Int{
    case main = 0
    case description = 1
    case courses = 2
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
extension TeacherViewController: UITableViewDataSource, UITableViewDelegate{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case DetailViewSection.main.rawValue:
      return 1
    case DetailViewSection.description.rawValue:
      return 1
    case DetailViewSection.courses.rawValue:
      return 1
    default: fatalError()
    }
    
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case DetailViewSection.main.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! TeacherMainTableViewCell
      cell.time_Label.text = courseToGet.hour
      if let iconUrl = courseToGet.authorImage{
        let url = URL(string: iconUrl)
        cell.teacher_ImageView.kf.setImage(with: url)
      }
      cell.teacher_Label.text = courseToGet.authorName
      return cell
    case DetailViewSection.description.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! TeacherDescriptionTableViewCell
      cell.description_TextView.text = courseToGet.authorDescription
      return cell
    case DetailViewSection.courses.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: "coursesCell", for: indexPath) as! TeacherCoursesTableViewCell
      cell.setDatasource(teacherId: idToGet)
      return cell
    default:
      fatalError()
    }
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case DetailViewSection.main.rawValue:
      return 352
    case DetailViewSection.description.rawValue:
      return 204
    case DetailViewSection.courses.rawValue:
      return 468
    default:
      fatalError()
    }
  }
}
