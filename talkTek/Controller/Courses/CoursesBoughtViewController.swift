//
//  CoursesBoughtViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/23.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CoursesBoughtViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  var databaseRef: DatabaseReference!
  var userID = ""
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.tableFooterView = UIView()
    
    guard let uid = Auth.auth().currentUser?.uid else { return }
    userID = uid

    fetchData()

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  var boughtCourses_Array = [BoughtCourses]()
  var boughtCouresToPass = BoughtCourses()
  func fetchData(){
    self.databaseRef = Database.database().reference()
    self.databaseRef.child("BoughtCourses/\(self.userID)").observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: String]{
        print("dictionary is \(dictionary)")
        
        let boughtCourses = BoughtCourses()
        boughtCourses.authorDescription = dictionary["authorDescription"]
        boughtCourses.authorImage = dictionary["authorImage"]
        boughtCourses.authorName = dictionary["authorName"]
        boughtCourses.courseDescription = dictionary["courseDescription"]
        boughtCourses.hour = dictionary["hour"]
        boughtCourses.overViewImage = dictionary["overViewImage"]
        boughtCourses.price = dictionary["price"]
        boughtCourses.score = dictionary["score"]
        boughtCourses.studentNumber = dictionary["studentNumber"]
        boughtCourses.title = dictionary["title"]
        
        self.boughtCourses_Array.append(boughtCourses)
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
        
      }
      
    }
  }
  
  
}
extension CoursesBoughtViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return boughtCourses_Array.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CoursesBoughtTableViewCell
    
    if let overviewUrl = boughtCourses_Array[indexPath.row].overViewImage{
      let url = URL(string: overviewUrl)
      cell.overview_ImageView.kf.setImage(with: url)
    }
    
    if let authorUrl = boughtCourses_Array[indexPath.row].authorImage{
      let url = URL(string: authorUrl)
      cell.author_ImageView.kf.setImage(with: url)
    }
    
    cell.title_Label.text = boughtCourses_Array[indexPath.row].title
    cell.teacherName_Label.text = boughtCourses_Array[indexPath.row].authorName
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 109
  }
}



