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
  var titleOfBoughtCourses = [String]()
  var uid: String?
  var idToPass = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.tableFooterView = UIView()
    
    // uid from userdefaults, database init
    uid = UserDefaults.standard.string(forKey: "uid")
    databaseRef = Database.database().reference()

    

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    fetchData()
    tableView.es.addPullToRefresh {
      [unowned self] in
      self.fetchData()
    }
  }
  var homeCourses_Array = [HomeCourses]()
  var homeCouresToPass = HomeCourses()
  func fetchData(){
    guard let uid = self.uid else { return }
    self.databaseRef.child("BoughtCourses").observeSingleEvent(of: .value) { (snapshot) in
      if snapshot.hasChild(uid){
        self.tableView.isHidden = false
        self.databaseRef.child("BoughtCourses").child(uid).observe(.value) { (snapshot) in
          if let array = snapshot.value as? [String]{
            self.titleOfBoughtCourses = array
          }
          self.fetchAllCourses()
        }
        return
      } else {
        self.tableView.isHidden = true
        return
      }
    }
  }
  
  func fetchAllCourses(){
    
    databaseRef = Database.database().reference()
    self.homeCourses_Array.removeAll()

    databaseRef.child("AllCourses").observe(.childAdded) { (snapshot) in
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
        homeCourses.scoreTotal = dictionary["scoreTotal"] as? Double
        homeCourses.studentNumber = dictionary["studentNumber"] as? Int
        homeCourses.tags = dictionary["tags"] as! [String]
        
        self.titleOfBoughtCourses.forEach({ (value) in
          if value == homeCourses.courseId {
            self.homeCourses_Array.append(homeCourses)
            DispatchQueue.main.async {
              self.tableView.reloadData()
            }
            return
          }
        })
        
        self.tableView.es.stopPullToRefresh()
      }
    }
    
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "identifierDetail"{
      let destinationViewController = segue.destination as! CoursePageViewController
      destinationViewController.detailToGet = self.homeCouresToPass
      destinationViewController.hidesBottomBarWhenPushed = true
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoreTableViewCell
    
    cell.authorImageView.layer.borderColor = UIColor.white.cgColor
    if let iconUrl = homeCourses_Array[indexPath.row].overViewImage{
      let url = URL(string: iconUrl)
      cell.overviewImageView.kf.setImage(with: url)
    }
    if let iconUrl = homeCourses_Array[indexPath.row].authorImage{
      let url = URL(string: iconUrl)
      cell.authorImageView.kf.setImage(with: url)
    }
    cell.authorNameLabel.text = homeCourses_Array[indexPath.row].authorName
    cell.titleLabel.text = homeCourses_Array[indexPath.row].courseTitle
    
    ////////// waiting for price on sale UI
    if let priceOrigin = homeCourses_Array[indexPath.row].priceOrigin{
      cell.money_Label.text = "\(priceOrigin)"
    }
    
    
    if let studentNumber = homeCourses_Array[indexPath.row].studentNumber {
      cell.studentNumberLabel.text = "\(studentNumber)"
    }
    
    if let scorePeople = homeCourses_Array[indexPath.row].scorePeople {
      cell.commentNumberLabel.text = "\(scorePeople)"
    }
    
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    homeCouresToPass = homeCourses_Array[indexPath.row]
    performSegue(withIdentifier: "identifierDetail", sender: self)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 129
  }
}



