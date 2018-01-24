//
//  TeacherViewController.swift
//  talkTek
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseDatabase
import FirebaseAuth

class TeacherViewController: UIViewController {
  
  var selectedRowIndex = -1

  @IBOutlet weak var tableView: UITableView!
  var idToGet = ""
  var courseToGet = HomeCourses()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.tableFooterView = UIView()
    
    teacherCourses(teacherId: idToGet)
    
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
  
  var homeCourses_Array = [HomeCourses]()
  
  func teacherCourses(teacherId: String){
    var databaseRef: DatabaseReference!
    databaseRef = Database.database().reference()
    databaseRef.child("TeacherCourses").child(teacherId).observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: String]{
        let homeCourses = HomeCourses()
        
        homeCourses.authorDescription = dictionary["authorDescription"]
        homeCourses.authorImage = dictionary["authorImage"]
        homeCourses.authorName = dictionary["authorName"]
        homeCourses.courseDescription = dictionary["courseDescription"]
        homeCourses.hour = dictionary["hour"]
        homeCourses.overViewImage = dictionary["overViewImage"]
        homeCourses.price = dictionary["price"]
        homeCourses.score = dictionary["score"]
        homeCourses.studentNumber = dictionary["studentNumber"]
        homeCourses.title = dictionary["title"]
        homeCourses.courseId = dictionary["courseId"]
        homeCourses.teacherID = dictionary["teacherID"]
        
        
        print("homecourses is \(homeCourses.title ?? "")")
        self.homeCourses_Array.append(homeCourses)
        print("homeCourses_Array is \(self.homeCourses_Array)")
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
  }
  enum DetailViewSection: Int{
    case main = 0
    case description = 1
    case courses = 2
  }
  var detailToPass = HomeCourses()
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "identifierCourse" {
      let destination = segue.destination as! CourseDetailViewController
      destination.detailToGet = detailToPass
    }
  }
  
  
}
extension TeacherViewController: UITableViewDataSource, UITableViewDelegate{
  func numberOfSections(in tableView: UITableView) -> Int {
    if tableView.tag == 100{
      return 3
    }
    if tableView.tag == 90 {
      return 1
    }
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView.tag == 100 {
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
    if tableView.tag == 90{
      return homeCourses_Array.count
    }
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if tableView.tag == 100 {
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
        cell.description_Label.text = courseToGet.authorDescription
        return cell
      case DetailViewSection.courses.rawValue:
        let cell = tableView.dequeueReusableCell(withIdentifier: "coursesCell", for: indexPath) as! TeacherCoursesTableViewCell
        if homeCourses_Array.count <= 3 {
          cell.tableViewHeight_Constraint.constant = CGFloat(119 * homeCourses_Array.count)
        } else {
          cell.tableViewHeight_Constraint.constant = 357.0
        }
        cell.tableView.reloadData()
        //cell.setDatasource(teacherId: idToGet)
        return cell
      default:
        fatalError()
        
      }
    }
    if tableView.tag == 90 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TeacherCoursesItemsTableViewCell
      if let overviewUrl = homeCourses_Array[indexPath.row].overViewImage{
        let url = URL(string: overviewUrl)
        cell.overview_ImageView.kf.setImage(with: url)
      }
      
      if let authorUrl = homeCourses_Array[indexPath.row].authorImage{
        let url = URL(string: authorUrl)
        cell.author_ImageView.kf.setImage(with: url)
      }
      
      cell.courseTitle_Label.text = homeCourses_Array[indexPath.row].title
      cell.authorName_Label.text = homeCourses_Array[indexPath.row].authorName
      
      
      return cell
    }
    return UITableViewCell()
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView.tag == 100 {
      switch indexPath.section {
      case DetailViewSection.main.rawValue: break
        
      case DetailViewSection.description.rawValue:
        let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! TeacherDescriptionTableViewCell
        if selectedRowIndex == indexPath.section {
          selectedRowIndex = -1
          cell.expand_Button.setImage(UIImage(named: "往上"), for: .normal)
        } else {
          selectedRowIndex = indexPath.section
          cell.expand_Button.setImage(UIImage(named: "往上"), for: .normal)
        }
        self.tableView.beginUpdates()
        let index = IndexPath(item: 0, section: 1)
        tableView.reloadRows(at: [index], with: .automatic)
        self.tableView.endUpdates()
        
      case DetailViewSection.courses.rawValue: break
        
      default:
        fatalError()
      }
    }
    if tableView.tag == 90{
      self.detailToPass = homeCourses_Array[indexPath.row]
      self.performSegue(withIdentifier: "identifierCourse", sender: self)
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if tableView.tag == 100 {
      switch indexPath.section {
      case DetailViewSection.main.rawValue:
        return 352
      case DetailViewSection.description.rawValue:
        if indexPath.section == selectedRowIndex {
          return UITableViewAutomaticDimension //Expanded
        }
        return 204.0 //Not expanded
      case DetailViewSection.courses.rawValue:
        if homeCourses_Array.count <= 3 {
          return 468.0 - CGFloat(119 * (3 - homeCourses_Array.count))
        } else {
          return 468
        }
      default:
        fatalError()
      }
    }
    
    if tableView.tag == 90 {
      return 119.0
    }
    
    return 119
  }
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    if tableView.tag == 100 {
      switch indexPath.section {
      case DetailViewSection.main.rawValue:
        return 352
      case DetailViewSection.description.rawValue:
        if indexPath.section == selectedRowIndex {
          return 400 //Expanded
        }
        return 0 //Not expanded
      case DetailViewSection.courses.rawValue:
        return 0.0
      default:
        fatalError()
      }
    }
    if tableView.tag == 90 {
      return 0
    }
    return 0
    
  }
}
