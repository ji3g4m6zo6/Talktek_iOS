//
//  LifeViewController.swift
//  talkTek
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import FirebaseDatabase
import Kingfisher
import ESPullToRefresh
import SVProgressHUD

class LifeViewController: UIViewController, IndicatorInfoProvider {
  
  // MARK: - XLPagerTab Indicator Info
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "生活")
  }
  
  // MARK: - Firebase Outlets
  var uid: String?
  var userIsAnonymous: Bool?
  var databaseRef: DatabaseReference!
  var homeCourses_Array = [HomeCourses]()
  var homeCouresToPass = HomeCourses()
  var titleOfHeartCourses = [String]()

  // MARK: - UICollectionView
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: - viewDidLoad, didReceiveMemoryWarning
  override func viewDidLoad() {
    super.viewDidLoad()
    

    // MARK: - collection view datasource & delegate
    collectionView.dataSource = self
    collectionView.delegate = self
    
    // uid from userdefaults, database init
    uid = UserDefaults.standard.string(forKey: "uid")
    userIsAnonymous = Auth.auth().currentUser?.isAnonymous ?? false
    databaseRef = Database.database().reference()
    
    // MARK: - fetch data from firebase & split from tags
    fetchData()
    
    // MARK: - ESPullToRefresh
    collectionView.es.addPullToRefresh {
      [unowned self] in
      self.homeCourses_Array.removeAll()
      self.fetchData()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    fetchHeartCourse()
  }
  
  // MARK: - Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "identifierDetail"{
      let destinationViewController = segue.destination as! CoursePageViewController
      destinationViewController.detailToGet = self.homeCouresToPass
      destinationViewController.titleOfHeartCourses = titleOfHeartCourses
      destinationViewController.homeCourseType = "life"
      destinationViewController.hidesBottomBarWhenPushed = true

    }
  }
  
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension LifeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return homeCourses_Array.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LifeCollectionViewCell
    
    cell.author_Label.text = homeCourses_Array[indexPath.item].authorName
    
    if let priceNum = homeCourses_Array[indexPath.item].priceOrigin{
      let priceLabel = String(priceNum) + "點"
      cell.price_Label.text = priceLabel
    }
    if let studentNum = homeCourses_Array[indexPath.item].studentNumber{
      let studentLabel = String(studentNum) + "人購買"
      cell.peopleBought_Label.text = studentLabel
    }
    if let overviewUrl = homeCourses_Array[indexPath.item].overViewImage{
      let url = URL(string: overviewUrl)
      cell.overview_ImageView.kf.setImage(with: url)
    }
    if let authorUrl = homeCourses_Array[indexPath.item].authorImage{
      let url = URL(string: authorUrl)
      cell.author_ImageView.kf.setImage(with: url)
    }
    
    
    cell.title_Label.text = homeCourses_Array[indexPath.item].courseTitle

    if homeCourses_Array[indexPath.item].heart {
      cell.heart_Button.setImage(UIImage(named: "heartFill"), for: .normal)
    } else {
      cell.heart_Button.setImage(UIImage(named: "heartEmpty"), for: .normal)
    }
    
    cell.heart_Button.tag = indexPath.item
    cell.heart_Button.addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside)
    
    
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    homeCouresToPass = homeCourses_Array[indexPath.item]
    performSegue(withIdentifier: "identifierDetail", sender: self)
  }
  
  @objc func heartButtonTapped(_ sender: UIButton){
    guard let _ = self.uid else { return }
    if let userIsAnonymous = userIsAnonymous {
      if userIsAnonymous {
        ShowAnonymousShouldLogInAlert()
        return
      }
    } else {
      ShowAnonymousShouldLogInAlert()
      return
    }

    if homeCourses_Array[sender.tag].heart { // if true(已收藏) -> 移除收藏
      
      // firebase set value of array
      
      homeCourses_Array[sender.tag].heart = !homeCourses_Array[sender.tag].heart
      if let courseId = homeCourses_Array[sender.tag].courseId {
        if let title = titleOfHeartCourses.index(of: courseId) {
          titleOfHeartCourses.remove(at: title)
          updateHeartToNetwork(updatedTitleOfHeartCourses: titleOfHeartCourses)
          collectionView.reloadData()
        }
        
      }
      
    } else { // if false(未收藏) -> 加入收藏
      
      homeCourses_Array[sender.tag].heart = !homeCourses_Array[sender.tag].heart
      if let courseId = homeCourses_Array[sender.tag].courseId {
        titleOfHeartCourses.append(courseId)
        updateHeartToNetwork(updatedTitleOfHeartCourses: titleOfHeartCourses)
      }
      collectionView.reloadData()
      
    }
    
  }
}

extension LifeViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 160, height: 190)
  }
}

// MARK: - API calls
extension LifeViewController {
  func fetchData(){
    databaseRef = Database.database().reference()
    
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
        
        
        self.tagsSplit(tags: homeCourses.tags, homecourse: homeCourses)
        
      }
    }
  }
  
  func tagsSplit(tags: [String?], homecourse: HomeCourses){
    for (_, value) in tags.enumerated() {
      guard let value = value else { return }
      if value.contains("Life"){
        homeCourses_Array.append(homecourse)
      }
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
      fetchHeartCourse()
    }
  }
  func fetchHeartCourse(){
    guard let uid = self.uid else { return }
    for course in self.homeCourses_Array{
      course.heart = false
    }
    databaseRef.child("HeartCourses").observe(.value) { (snapshot) in
      if snapshot.hasChild(uid){
        self.databaseRef.child("HeartCourses").child(uid).observe(.value) { (snapshot) in
          if let array = snapshot.value as? [String]{
            self.titleOfHeartCourses = array
            self.loopThroughHeart()
          }
        }
        return
      } else {
        self.collectionView.reloadData()
        return
      }
    }
  }
  func loopThroughHeart(){
    for course in homeCourses_Array {
      for heart in titleOfHeartCourses {
        if course.courseId == heart {
          course.heart = true
          collectionView.reloadData()
        }
      }
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
        print("Successfully update heart")
      }
      
    }
  }
}
