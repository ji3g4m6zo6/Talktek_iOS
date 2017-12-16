//
//  CoursesHeartViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/23.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CoursesHeartViewController: UIViewController {
  
  var databaseRef: DatabaseReference!
  var userID = ""
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.tableFooterView = UIView()
    
    userID = Auth.auth().currentUser!.uid
    fetchData()

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  var heartCourses_Array = [HeartCourses]()
  var heartCoursesToPass = HeartCourses()
  func fetchData(){
    self.databaseRef = Database.database().reference()
    self.databaseRef.child("HeartCourses/\(self.userID)").observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: String]{
        print("dictionary is \(dictionary)")
        
        let heartCourses = HeartCourses()
        heartCourses.authorDescription = dictionary["authorDescription"]
        heartCourses.authorImage = dictionary["authorImage"]
        heartCourses.authorName = dictionary["authorName"]
        heartCourses.courseDescription = dictionary["courseDescription"]
        heartCourses.hour = dictionary["hour"]
        heartCourses.overViewImage = dictionary["overViewImage"]
        heartCourses.price = dictionary["price"]
        heartCourses.score = dictionary["score"]
        heartCourses.studentNumber = dictionary["studentNumber"]
        heartCourses.title = dictionary["title"]
        
        self.heartCourses_Array.append(heartCourses)
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
        
      }
      
    }
  }
  
 
  
}

extension CoursesHeartViewController: UITableViewDataSource, UITableViewDelegate{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return heartCourses_Array.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CoursesHeartTableViewCell
    if let overviewUrl = heartCourses_Array[indexPath.row].overViewImage{
      let url = URL(string: overviewUrl)
      cell.overview_ImageView.kf.setImage(with: url)
    }
    
    if let authorUrl = heartCourses_Array[indexPath.row].authorImage{
      let url = URL(string: authorUrl)
      cell.author_ImageView.kf.setImage(with: url)
    }
    
    cell.title_Label.text = heartCourses_Array[indexPath.row].title
    cell.teacherName_Label.text = heartCourses_Array[indexPath.row].authorName
    
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 109
  }
}
