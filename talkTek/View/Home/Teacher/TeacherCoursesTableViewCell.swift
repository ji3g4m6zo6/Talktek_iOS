//
//  TeacherCoursesTableViewCell.swift
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


class TeacherCoursesTableViewCell: UITableViewCell {
  
  @IBOutlet weak var tableView: UITableView!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setDatasource(teacherId: String){
    teacherCourses(teacherId: teacherId)
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
        
        
        
        self.homeCourses_Array.append(homeCourses)
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
  }
  
}
