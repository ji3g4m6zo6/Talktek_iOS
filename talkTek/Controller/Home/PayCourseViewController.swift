//
//  PayCourseViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/21.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PayCourseViewController: UIViewController {
  
  var databaseRef: DatabaseReference!
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    
    databaseRef = Database.database().reference()
    fetchData()

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  var courseCategory_Array = [CourseCategory]()
  var homeCourses_Array = [HomeCourses]()
  
  func fetchData(){
    // Get the number and root of collectionview
    self.databaseRef.child("CourseCategory").child("最新課程").observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: String]{
        print("dictionary is \(dictionary)")
        
        
        
        
      }
      
    }
    
  }
  
  
}

extension PayCourseViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
//  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    return categories[section]
//  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return courseCategoryArray.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PayCategoryCell
    cell.topic_Label.text = courseCategoryArray[indexPath.row].presentName
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 253
  }
}

extension PayCourseViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 12 //coursesOfEachCategory!.course.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseCell", for: indexPath) as! PayCollectionViewCell
    
    //    if let coursesOfEachCategory = coursesOfEachCategory{
    //      cell.Topic_Label.text = coursesOfEachCategory.course[indexPath.row].title
    //    }
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 160, height: 190)
  }
  
}
