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
import ESPullToRefresh


class CoursesBoughtViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var noCourseBought_ImageView: UIImageView!
  
  @IBOutlet weak var noCourseBought_Label: UILabel!
  
  @IBOutlet weak var noCourseBought_Button: UIButton!
  var databaseRef: DatabaseReference!
  var userID = ""
  var idToPass = ""
  override func viewDidLoad() {
    super.viewDidLoad()
    noCourseBought_ImageView.isHidden = true
    noCourseBought_Label.isHidden = true
    noCourseBought_Button.isHidden = true
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.tableFooterView = UIView()
    
    guard let uid = Auth.auth().currentUser?.uid else { return }
    userID = uid

    databaseRef = Database.database().reference()

    fetchData()
    tableView.es.addPullToRefresh {
      [unowned self] in
      self.homeCourses_Array.removeAll()
      self.fetchData()
    }

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
        homeCourses.teacherID = dictionary["teacherID"]
        
        
        
        self.homeCourses_Array.append(homeCourses)
        print("homecourses array \(self.homeCourses_Array)")
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
        self.tableView.es.stopPullToRefresh()
      }
    }
    if self.homeCourses_Array.isEmpty{
      self.hideNotBoughtView()
    }
  }
  func hideNotBoughtView(){
    noCourseBought_ImageView.isHidden = false
    noCourseBought_Label.isHidden = false
    noCourseBought_Button.isHidden = false
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
    return 129
  }
}



