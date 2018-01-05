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
        
        
        print("homecourses is \(homeCourses.title ?? "")")
        self.homeCourses_Array.append(homeCourses)
        print("homeCourses_Array is \(self.homeCourses_Array)")
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
  }
  
}

extension TeacherCoursesTableViewCell: UITableViewDataSource, UITableViewDelegate{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return homeCourses_Array.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 109
  }
  
  //  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
  //    let cell = tableView.dequeueReusableCell(withIdentifier: "audioSection") as! AudioSectionTableViewCell
  //    cell.setUpCell(title: categories[section])
  //    return cell
  //  }
  //  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
  //    return 49
  //  }
}
