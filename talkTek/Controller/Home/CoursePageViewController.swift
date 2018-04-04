//
//  CoursePageViewController.swift
//  talkTek
//
//  Created by 李昀 on 2018/3/28.
//  Copyright © 2018年 Talktek Inc. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseDatabase
import FirebaseAuth


class CoursePageViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var detailToGet = HomeCourses()
  var audioItem_Array = [AudioItem?]()
  var audioItemFromDatabase = [AudioItem]()
  var sections = [String]()

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    
    if let courseId = detailToGet.courseId {
      fetchSectionTitle(withCourseId: courseId)
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
  
  enum DetailViewSection: Int{
    case main = 0
    case courseInfo = 1
    case teacherInfo = 2
    case courses = 3
  }
  
  func fetchAudioFiles(withCourseId: String){
    var tempSection = -1
    var databaseRef: DatabaseReference!
    databaseRef = Database.database().reference()
    databaseRef.child("AudioPlayer").child(withCourseId).observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: Any]{
        let audioItem = AudioItem()
        audioItem.Audio = dictionary["Audio"] as? String
        audioItem.Time = dictionary["Time"] as? String
        audioItem.Title = dictionary["Title"] as? String
        audioItem.Topic = dictionary["Topic"] as? String
        audioItem.SectionPriority = dictionary["SectionPriority"] as? Int
        audioItem.TryOutEnable = dictionary["TryOutEnable"] as? Int
        
        self.audioItemFromDatabase.append(audioItem)
        
        if tempSection != audioItem.SectionPriority {
          if let sectionPriority = audioItem.SectionPriority {
            self.audioItem_Array.append(audioItem)
            print(self.audioItem_Array.count - 1)
            self.audioItem_Array.insert(nil, at: self.audioItem_Array.count - 1 )
            tempSection = sectionPriority
          }
          
        } else {
          self.audioItem_Array.append(audioItem)

        }
        
        
        DispatchQueue.main.async {
          
          self.tableView.reloadData()
          
        }
        
        
      }
    }
  }
  
  func fetchSectionTitle(withCourseId: String){
    var databaseRef: DatabaseReference!
    databaseRef = Database.database().reference()
   print("course id \(withCourseId)")
    databaseRef.child("AudioPlayerSection").child(withCourseId).observe(.value) { (snapshot) in
      if let array = snapshot.value as? [String]{
        self.sections = array
      }
      
    }
    self.fetchAudioFiles(withCourseId: withCourseId)


  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}

extension CoursePageViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case DetailViewSection.main.rawValue:
      return 1
    case DetailViewSection.courseInfo.rawValue:
      return 3
    case DetailViewSection.teacherInfo.rawValue:
      return 3
    case DetailViewSection.courses.rawValue:
      return 2 + audioItem_Array.count
        // (header + footer) + sections + audiofiles
    default:
      return 0
    }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case DetailViewSection.main.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: "overview", for: indexPath) as! CoursePageOverviewTableViewCell
      
      if let iconUrl = detailToGet.overViewImage{
        let url = URL(string: iconUrl)
        cell.overviewImageView.kf.setImage(with: url)
      }
      if let studentNumber = detailToGet.studentNumber {
        let studentNumberString = String(studentNumber)
        cell.studentNumberLabel.text = studentNumberString
      }
      
      if let scoreTotal = detailToGet.scoreTotal, let scorePeople = detailToGet.scorePeople {
        if scorePeople == 0 {
          cell.scoreNumberLabel.text = String(scorePeople)
        } else {
          let average = Float(scoreTotal) / Float(scorePeople)
          cell.scoreNumberLabel.text = String(format: "%.1f", average)
        }
      }
      
      let courseNumberString = String(audioItemFromDatabase.count)
      cell.coursesNumberLabel.text = courseNumberString
      
      
      cell.topicLabel.text = detailToGet.courseTitle
      
      return cell
    case DetailViewSection.courseInfo.rawValue:
      if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! CoursePageHeaderTableViewCell
        cell.titleSectionLabel.text = "課程資訊"
        return cell
      } else if indexPath.row == 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "intro", for: indexPath) as! CoursePageIntroTableViewCell
        cell.introLabel.text = detailToGet.courseDescription
        return cell

      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expand", for: indexPath) as! CoursePageExpandTableViewCell
        return cell
      }
    case DetailViewSection.teacherInfo.rawValue:
      if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! CoursePageHeaderTableViewCell
        cell.titleSectionLabel.text = "講師資訊"

        return cell
        
      } else if indexPath.row == 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacher", for: indexPath) as! CoursePageTeacherTableViewCell
        if let iconUrl = detailToGet.authorImage{
          let url = URL(string: iconUrl)
          cell.teacherImageView.kf.setImage(with: url)
        }
        cell.teacherNameLabel.text = detailToGet.authorName
        cell.teacherInfoLabel.text = detailToGet.authorDescription
        return cell

      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showall", for: indexPath) as! CoursePageShowAllTableViewCell
        return cell
      }
      
    case DetailViewSection.courses.rawValue:
      if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! CoursePageHeaderTableViewCell
        cell.titleSectionLabel.text = "課程列表"

        return cell
      } else if indexPath.row == audioItem_Array.count + 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expand", for: indexPath) as! CoursePageExpandTableViewCell
        cell.expandButton.isHidden = true
        return cell
      } else {
      
        
        if let particularItem = audioItem_Array[indexPath.row-1]{
          let cell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath) as! CoursePageListTableViewCell
          cell.titleLabel.text = particularItem.Title
          cell.timeLabel.text = particularItem.Time
          
          if let tryOutEnable = particularItem.TryOutEnable{
            if tryOutEnable == -1 {
              cell.tryoutButton.isHidden = true
            } else {
              cell.tryoutButton.isHidden = false
            }
          }
          return cell
        } else {
          let cell = tableView.dequeueReusableCell(withIdentifier: "topic", for: indexPath) as! CoursePageTopicTableViewCell
          if let particularItem = audioItem_Array[indexPath.row] {
            if let sectionPriority = particularItem.SectionPriority{
              cell.topicLabel.text = sections[sectionPriority]
              return cell
            }
          }
          
          
        }
        
      }
    default:
      return UITableViewCell()
    }
    return UITableViewCell()
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case DetailViewSection.main.rawValue:
      return UITableViewAutomaticDimension
    case DetailViewSection.courseInfo.rawValue:
      if indexPath.row == 0 {
        return 64
      } else if indexPath.row == 1 {
        return 107
      } else {
        return 54
      }
    case DetailViewSection.teacherInfo.rawValue:
      if indexPath.row == 0 {
        return 64
      } else if indexPath.row == 1 {
        return 132
      } else {
        return 51
      }
    case DetailViewSection.courses.rawValue:
      
      if indexPath.row == 0 {
        return 64
      } else if indexPath.row == audioItem_Array.count + 1  {
        return 54
      } else {
        return UITableViewAutomaticDimension
      }
    default:
      return 0
    }
  }
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case DetailViewSection.main.rawValue:
      return 377
    case DetailViewSection.courseInfo.rawValue:
      if indexPath.row == 0 {
        return 0
      } else if indexPath.row == 1 {
        return 0
      } else {
        return 0
      }
    case DetailViewSection.teacherInfo.rawValue:
      if indexPath.row == 0 {
        return 0
      } else if indexPath.row == 1 {
        return 0
      } else {
        return 0
      }
    case DetailViewSection.courses.rawValue:
      if indexPath.row == 0 {
        return 0
      } else if indexPath.row == audioItem_Array.count + 1  {
        return 0
      } else {
        return 52
      }
    default:
      return 0
    }
  }
}
