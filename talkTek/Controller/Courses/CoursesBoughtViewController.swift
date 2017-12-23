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
  var idToPass = ""
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.tableFooterView = UIView()
    
    guard let uid = Auth.auth().currentUser?.uid else { return }
    userID = uid

    databaseRef = Database.database().reference()

    fetchData()

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  var homeCourses_Array = [HomeCourses]()
  var homeCouresToPass = HomeCourses()
  func fetchData(){
    // Get the number and root of collectionview
    self.databaseRef.child("BoughtCourses").child(userID).observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: String]{
        print("dictionary is \(dictionary)")
        
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
        
        
        
        
        self.homeCourses_Array.append(homeCourses)
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "identifierDetail"{
      let destinationViewController = segue.destination as! CourseDetailViewController
      destinationViewController.detailToGet = self.homeCouresToPass
    }
  }
}
extension CoursesBoughtViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return homeCourses_Array.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CoursesBoughtTableViewCell
    
    if let overviewUrl = homeCourses_Array[indexPath.row].overViewImage{
      let url = URL(string: overviewUrl)
      cell.overview_ImageView.kf.setImage(with: url)
    }
    
    if let authorUrl = homeCourses_Array[indexPath.row].authorImage{
      let url = URL(string: authorUrl)
      cell.author_ImageView.kf.setImage(with: url)
    }
    
    cell.title_Label.text = homeCourses_Array[indexPath.row].title
    cell.teacherName_Label.text = homeCourses_Array[indexPath.row].authorName
    
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    homeCouresToPass = homeCourses_Array[indexPath.item]
    performSegue(withIdentifier: "identifierDetail", sender: self)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 109
  }
}



