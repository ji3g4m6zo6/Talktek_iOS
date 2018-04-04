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

class LifeViewController: UIViewController, IndicatorInfoProvider {
  
  // MARK: - XLPagerTab Indicator Info
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "生活")
  }
  
  // MARK: - Firebase Outlets
  var databaseRef: DatabaseReference!
  var homeCourses_Array = [HomeCourses]()
  var homeCouresToPass = HomeCourses()
  
  // MARK: - UICollectionView
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: - viewDidLoad, didReceiveMemoryWarning
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // MARK: - collection view datasource & delegate
    collectionView.dataSource = self
    collectionView.delegate = self
    
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
  
  // MARK: - Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "identifierDetail"{
      let destinationViewController = segue.destination as! CourseDetailViewController
      destinationViewController.detailToGet = self.homeCouresToPass
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
    
    if let priceNum = homeCourses_Array[indexPath.item].price{
      let priceLabel = priceNum + "點"
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
    cell.title_Label.text = homeCourses_Array[indexPath.item].title

    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    homeCouresToPass = homeCourses_Array[indexPath.item]
    performSegue(withIdentifier: "identifierDetail", sender: self)
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
        homeCourses.authorImage = dictionary["authorImage"] as? String
        homeCourses.authorName = dictionary["authorName"] as? String
        homeCourses.courseDescription = dictionary["courseDescription"] as? String
        homeCourses.hour = dictionary["hour"] as? String
        homeCourses.overViewImage = dictionary["overViewImage"] as? String
        homeCourses.price = dictionary["price"] as? String
        homeCourses.score = dictionary["score"] as? String
        homeCourses.studentNumber = dictionary["studentNumber"] as? Int
        homeCourses.title = dictionary["title"] as? String
        homeCourses.courseId = dictionary["courseId"] as? String
        homeCourses.teacherID = dictionary["teacherID"] as? String
        homeCourses.onSalesPrice = dictionary["onSalesPrice"] as? String
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
    }
  }
}
