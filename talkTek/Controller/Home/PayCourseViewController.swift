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
import ObjectMapper

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
  var courseCategoryArray = [CourseCategory]()
  var courseArray = [Course]()
  var arrayCourse = [Array<Course>]()
  
  var root = [String]()
  func fetchData(){
    // Get the number and root of collectionview
    self.databaseRef.child("CourseCategory").observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: AnyObject]{
        print("dictionary is \(dictionary)")
        
        let courseCategory = CourseCategory()
        
        
        courseCategory.keyName = dictionary["keyName"] as? String ?? ""
        courseCategory.presentName = dictionary["presentName"] as? String ?? ""
        
        //self.root.append(courseCategory.keyName!)
        
        //self.courseCategoryArray.append(courseCategory)

        
        
        
      }
      
      //self.fetchDetail(key: self.root)
    }
    
  }
  func fetchDetail(key: Array<String>){
    for eachRoot in key{
      self.databaseRef.child(eachRoot).observe(.childAdded, with: { (snapshot) in
        if let dictionary = snapshot.value as? [String: AnyObject]{
          print("Detail is \(dictionary)")
          let course = Course()
          
          course.title = dictionary["title"] as? String ?? ""
          print("course title is \(course.title ?? "")")
          
          self.arrayCourse.append(self.courseArray)
          print("wtf??? \(self.arrayCourse)")
          
          DispatchQueue.main.async {
            self.tableView.reloadData()
          }
          
        }
        
      })
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
