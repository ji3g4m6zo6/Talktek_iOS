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
import ESPullToRefresh
import XLPagerTabStrip
import SVProgressHUD

class CoursesHeartViewController: UIViewController, IndicatorInfoProvider {
  
  
  // MARK: - XLPagerTab Indicator Info
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "心願")
  }
  
  var databaseRef: DatabaseReference!
  var uid: String?
  var titleOfHeartCourses = [String]()

  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
    
    // uid from userdefaults, database init
    uid = UserDefaults.standard.string(forKey: "uid")
    databaseRef = Database.database().reference()

  
    fetchData()
    tableView.es.addPullToRefresh {
      [unowned self] in
      self.fetchData()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
  }
  
  var homeCourses_Array = [HomeCourses]()
  var homeCoursesToPass = HomeCourses()
  
  func fetchData(){
    guard let uid = self.uid else { return }
    self.databaseRef.child("HeartCourses").observe(.value) { (snapshot) in
      if snapshot.hasChild(uid){
        self.tableView.isHidden = false
        self.databaseRef.child("HeartCourses").child(uid).observe(.value) { (snapshot) in
          if let array = snapshot.value as? [String]{
            self.titleOfHeartCourses = array
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
    homeCourses_Array.removeAll()
    
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
        homeCourses.heart = true
        
        self.titleOfHeartCourses.forEach({ (value) in
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
  
}

extension CoursesHeartViewController: UITableViewDataSource, UITableViewDelegate{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("home array \(homeCourses_Array.count)")
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
    
    
    // hide a few button
    cell.iconImageView.isHidden = true
    cell.money_Label.isHidden = true
    cell.studentNumberLabel.isHidden = true
    cell.commentNumberLabel.isHidden = true
    
    
    ////////// waiting for price on sale UI
    if let priceOrigin = homeCourses_Array[indexPath.row].priceOrigin{
      cell.money_Label.text = "\(priceOrigin)點"
    }
    
    
    if let studentNumber = homeCourses_Array[indexPath.row].studentNumber {
      cell.studentNumberLabel.text = "\(studentNumber)人購買"
    }
    
    if let scorePeople = homeCourses_Array[indexPath.row].scorePeople {
      cell.commentNumberLabel.text = "(\(scorePeople))"
    }
    
    
    if homeCourses_Array[indexPath.item].heart {
      cell.heartButton.setImage(UIImage(named: "heartFill"), for: .normal)
    } else {
      cell.heartButton.setImage(UIImage(named: "heartEmpty"), for: .normal)
    }
    
    cell.heartButton.tag = indexPath.row
    cell.heartButton.addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside)
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 129
  }
  
  @objc func heartButtonTapped(_ sender: UIButton){
    if homeCourses_Array[sender.tag].heart { // if true(已收藏) -> 移除收藏
      
      // firebase set value of array
      homeCourses_Array[sender.tag].heart = !homeCourses_Array[sender.tag].heart
      if let courseId = homeCourses_Array[sender.tag].courseId {
        if let title = titleOfHeartCourses.index(of: courseId) {
          titleOfHeartCourses.remove(at: title)
          updateHeartToNetwork(updatedTitleOfHeartCourses: titleOfHeartCourses)
        }
        
      }
      
      
    } else { // if false(未收藏) -> 加入收藏
      
      homeCourses_Array[sender.tag].heart = !homeCourses_Array[sender.tag].heart
      if let courseId = homeCourses_Array[sender.tag].courseId {
        titleOfHeartCourses.append(courseId)
        updateHeartToNetwork(updatedTitleOfHeartCourses: titleOfHeartCourses)
      }
      tableView.reloadData()
      
    }
    
  }
  func updateHeartToNetwork(updatedTitleOfHeartCourses: [String]){
    guard let uid = self.uid else { return }
    databaseRef.child("HeartCourses").child(uid).setValue(updatedTitleOfHeartCourses) { (error, _) in
      if error != nil {
        SVProgressHUD.showError(withStatus: "設定失敗")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
          SVProgressHUD.dismiss()
        })
      } else {
        self.fetchData()
        print("Successfully update heart")
      }
      
    }
  }
}
