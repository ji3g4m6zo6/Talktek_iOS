//
//  TeacherPageViewController.swift
//  talkTek
//
//  Created by 李昀 on 2018/4/5.
//  Copyright © 2018年 Talktek Inc. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseDatabase
import FirebaseAuth
class TeacherPageViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var databaseRef: DatabaseReference!
  var homeCourses_Array = [HomeCourses]()
  var courseToGet = HomeCourses()
  var studentNumber = 0
  var scoreAverage = 0.0
  
  
  enum DetailViewSection: Int{
    case main = 0
    case teacherInfo = 1
    case courses = 2
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    databaseRef = Database.database().reference()

    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    
    if let authorId = courseToGet.authorId {
      teacherCoursesName(authorId: authorId)
    }
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func teacherCoursesName(authorId: String){
   
    databaseRef.child("TeacherCourses").child(authorId).observe(.value) { (snapshot) in
      if let array = snapshot.value as? [String]{
        array.forEach({ (courseId) in
          self.fetchTeacherCourses(withCourseId: courseId)
        })
        
      }
    }
    
  }
  func fetchTeacherCourses(withCourseId: String){
    databaseRef.child("AllCourses").child(withCourseId).observe(.value) { (snapshot) in
      if let dictionary = snapshot.value as? [String: Any]{
        
        let homeCourses = HomeCourses()
        
        homeCourses.authorDescription = dictionary["authorDescription"] as? String
        homeCourses.authorId = dictionary["authorId"] as? String
        homeCourses.authorImage = dictionary["authorImage"] as? String
        homeCourses.authorName = dictionary["authorName"] as? String
        homeCourses.courseDescription = dictionary["courseDescription"] as? String
        homeCourses.courseId = dictionary["courseId"] as? String
        homeCourses.courseTitle = dictionary["courseTitle"] as? String
        homeCourses.overViewImage = dictionary["overViewImage"] as? String
        homeCourses.priceOnSales = dictionary["priceOnSales"] as? Int
        homeCourses.priceOrigin = dictionary["priceOrigin"] as? Int
        homeCourses.scorePeople = dictionary["scorePeople"] as? Int
        homeCourses.scoreTotal = dictionary["scoreTotal"] as? Int
        homeCourses.studentNumber = dictionary["studentNumber"] as? Int
        homeCourses.tags = dictionary["tags"] as! [String]
        
        if let studentNumber = homeCourses.studentNumber{
          self.studentNumber += studentNumber
        }
        if let scoreTotal = homeCourses.scoreTotal, let scorePeople = homeCourses.scorePeople{
          if scorePeople != 0 {
            self.scoreAverage = Double(scoreTotal) / Double(scorePeople)
          }
        }
        
        self.homeCourses_Array.append(homeCourses)
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
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
extension TeacherPageViewController: UITableViewDelegate, UITableViewDataSource{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case DetailViewSection.main.rawValue:
      return 1
    case DetailViewSection.teacherInfo.rawValue:
      return 3
    case DetailViewSection.courses.rawValue:
      return 2 + homeCourses_Array.prefix(3).count
    default:
      return 0
    }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case DetailViewSection.main.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! TeacherPageOverviewTableViewCell
      if let iconUrl = courseToGet.authorImage{
        let url = URL(string: iconUrl)
        cell.teacherImageView.kf.setImage(with: url)
      }
      cell.teacherNameLabel.text = courseToGet.authorName
      cell.studentNumberLabel.text = "\(studentNumber)"
      cell.coursesNumberLabel.text = "\(homeCourses_Array.count)"
      
      return cell
    case DetailViewSection.teacherInfo.rawValue:
      if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! CoursePageHeaderTableViewCell
        cell.titleSectionLabel.text = "講師資訊"
        return cell
      } else if indexPath.row == 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "intro", for: indexPath) as! CoursePageIntroTableViewCell
        cell.introLabel.text = courseToGet.authorDescription
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expand", for: indexPath)
        return cell
      }
      
    case DetailViewSection.courses.rawValue:
      if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! CoursePageHeaderTableViewCell
        cell.titleSectionLabel.text = "已開課程"
        return cell
      } else if indexPath.row == homeCourses_Array.prefix(3).count + 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showall", for: indexPath) as! CoursePageShowAllTableViewCell
        
        if homeCourses_Array.count > 3 {
          cell.showAllButton.isHidden = false
        } else {
          cell.showAllButton.isHidden = true
        }
        
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoreTableViewCell
        
        cell.authorImageView.layer.borderColor = UIColor.designableGray().cgColor
        if let iconUrl = homeCourses_Array[indexPath.row-1].overViewImage{
          let url = URL(string: iconUrl)
          cell.overviewImageView.kf.setImage(with: url)
        }
        if let iconUrl = homeCourses_Array[indexPath.row-1].authorImage{
          let url = URL(string: iconUrl)
          cell.authorImageView.kf.setImage(with: url)
        }
        cell.authorNameLabel.text = homeCourses_Array[indexPath.row-1].authorName
        cell.titleLabel.text = homeCourses_Array[indexPath.row-1].courseTitle
        
        ////////// waiting for price on sale UI
        if let priceOrigin = homeCourses_Array[indexPath.row-1].priceOrigin{
          cell.money_Label.text = "\(priceOrigin)"
        }
        
        
        if let studentNumber = homeCourses_Array[indexPath.row-1].studentNumber {
          cell.studentNumberLabel.text = "\(studentNumber)"
        }
        
        if let scorePeople = homeCourses_Array[indexPath.row-1].scorePeople {
          cell.commentNumberLabel.text = "\(scorePeople)"
        }
        
        
        return cell
      }
      
    default:
      return UITableViewCell()
    }
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case DetailViewSection.main.rawValue:
      return 350 //377
    case DetailViewSection.teacherInfo.rawValue:
      if indexPath.row == 0 {
        return 64
      } else if indexPath.row == 1 {
        return 107
      } else {
        return 39
      }
    case DetailViewSection.courses.rawValue:
      if indexPath.row == 0 {
        return 79
      } else if indexPath.row == 1 + homeCourses_Array.prefix(3).count {
        if homeCourses_Array.count > 3 {
          return 40
        } else {
          return 30
        }
      } else {
        return 119
      }
    default:
      return 0
    }
  }
  
  /*
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case DetailViewSection.main.rawValue:
        return 0
    case DetailViewSection.teacherInfo.rawValue:
      if indexPath.row == 0 {
        return 0
      } else if indexPath.row == 1 {
        return 0
      } else {
        return 0
      }
    case DetailViewSection.courses.rawValue:
      if indexPath.row == 0 {
        return 0
      } else if indexPath.row == 1 + homeCourses_Array.prefix(3).count {
        return 0
      } else {
        return 0
      }
    default:
      return 0
    }
  }*/
  
}