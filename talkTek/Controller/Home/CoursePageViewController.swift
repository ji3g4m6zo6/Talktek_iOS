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
import SVProgressHUD

class CoursePageViewController: UIViewController {
  
  // MARK: - tableview
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var tableviewToBottom: NSLayoutConstraint!
  var selectedRow = IndexPath(item: -1, section: -1)
  enum DetailViewSection: Int{
    case main = 0
    case courseInfo = 1
    case teacherInfo = 2
    case courses = 3
  }
  
  // MARK: - API save
  var detailToGet = HomeCourses()
  var audioItem_Array = [AudioItem?]()
  var audioItemFromDatabase = [AudioItem]()
  var sections = [String]()
  var detailToPass = [AudioItem?]()

  // MARK: - Buy View
  @IBOutlet weak var buy_View: UIView!
  @IBOutlet weak var buyButton: UIButton!
  @IBOutlet weak var originalIconImage: UIImageView!
  @IBOutlet weak var originalCost_Label: UILabel!
  @IBOutlet weak var onsaleIconImage: UIImageView!
  @IBOutlet weak var onsale_Label: UILabel!
  @IBOutlet weak var deletionView: UIView!
  @IBOutlet weak var onlyIconImage: UIImageView!
  @IBOutlet weak var onlyMoneyLabel: UILabel!
  var thisCourseHasBought = false
  {
    didSet
    {
      if thisCourseHasBought == true {
        tableviewToBottom.constant = 0
        buy_View.isHidden = true
        tableView.reloadData()
      } else {
        tableviewToBottom.constant = 50
        buy_View.isHidden = false
        tableView.reloadData()
      }
    }
  }
  
  // MARK: - Firebase
  var uid: String?
  var myMoney: String?
  var databaseRef: DatabaseReference!
  var thisSong = 0
  
  // MARK: - viewDidLoad, didReceiveMemoryWarning
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // uid from userdefaults, database init
    uid = UserDefaults.standard.string(forKey: "uid")
    databaseRef = Database.database().reference()

    // Tableview
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    
    // updateBuyView, getMoney, ifUserHasCourse
    updateBuyView()
    getMoney()
    ifUserHasCourse()
    
    // fetchAudioFiles
    if let courseId = detailToGet.courseId {
      fetchSectionTitle(withCourseId: courseId)
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
  
  
  // MARK: - Buy Button Tapped
  @IBAction func buy_Button_Tapped(_ sender: UIButton) {
    guard let uid = self.uid else { return }
    if uid != "guest"{
      SVProgressHUD.show(withStatus: "支付中...")
      buy()
    } else {
      SVProgressHUD.showError(withStatus: "尚未登入")
      DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
        SVProgressHUD.dismiss()
      })
    }
  }
  
  // MARK: - Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "identifierTeacher" {
      let destination = segue.destination as! TeacherPageViewController
      destination.courseToGet = detailToGet
    } else if segue.identifier == "identifierPlayer" {
      let destination = segue.destination as! PlayerViewController
      destination.audioData = detailToPass
      destination.thisSong = thisSong
    }
  }
  
}
// MARK: - UITableViewDataSource, UITableViewDelegate
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
          cell.scoreNumberLabel.text = String(format: "%.1f", scorePeople)
        } else {
          let average = scoreTotal / Double(scorePeople)
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
        if selectedRow != indexPath {
          cell.expandButton.isHidden = false
        } else {
          cell.expandButton.isHidden = true
        }
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
          
          if thisCourseHasBought == true {
            cell.tryoutButton.isHidden = true
          } else {
            if let tryOutEnable = particularItem.TryOutEnable{
              if tryOutEnable == -1 {
                cell.tryoutButton.isHidden = true
              } else {
                cell.tryoutButton.isHidden = false
              }
            }
          }
          cell.tryoutButton.tag = indexPath.row - 1
          cell.tryoutButton.addTarget(self, action: #selector(tryOutButtonTapped(_:)), for: .touchUpInside)
          
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
        if selectedRow == IndexPath(item: 2, section: 1){
          return UITableViewAutomaticDimension // expanded
        } else {
          return 107
        }
      } else {
        if selectedRow == IndexPath(item: 2, section: 1){
          return 20
        } else {
          return 39
        }
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
        return 39
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
        if selectedRow == IndexPath(item: 2, section: 1){
          return 400
        } else {
          return 0
        }
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
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case DetailViewSection.main.rawValue:
      break
    case DetailViewSection.courseInfo.rawValue:
      if indexPath.row == 0 {
        break
      } else if indexPath.row == 1 {
        break
      } else {
        if selectedRow != indexPath {
          selectedRow = indexPath
          tableView.reloadData()
        } else {
          break
        }
      }
    case DetailViewSection.teacherInfo.rawValue:
      if indexPath.row == 0 {
        break
      } else if indexPath.row == 1 {
        break
      } else {
        performSegue(withIdentifier: "identifierTeacher", sender: self)
      }
    case DetailViewSection.courses.rawValue:
      if indexPath.row == 0 {
        break
      } else if indexPath.row == audioItem_Array.count + 1  {
        break
      } else {
        if thisCourseHasBought == true{
          if let _ = audioItem_Array[indexPath.row-1]{
            self.thisSong = indexPath.row - 1
            self.detailToPass = audioItem_Array
            performSegue(withIdentifier: "identifierPlayer", sender: self)
          } else {
            break
          }
        } else {
          SVProgressHUD.showError(withStatus: "尚未購買")
          DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            SVProgressHUD.dismiss()
          })
        }
        
      }
    default:
      break
    }
  }
}

// MARK: - API call
extension CoursePageViewController {
  // MARK: - update buy view
  func updateBuyView(){
    
    originalIconImage.tintColor = UIColor.moneyYellow()
    onsaleIconImage.tintColor = UIColor.moneyYellow()
    onlyIconImage.tintColor = UIColor.moneyYellow()
    
    if let priceOnSales = detailToGet.priceOnSales, let priceOrigin = detailToGet.priceOrigin{
      if priceOnSales >= 0 {
        
        onlyIconImage.isHidden = true
        onlyMoneyLabel.isHidden = true
        onsale_Label.isHidden = false
        onsaleIconImage.isHidden = false
        deletionView.isHidden = false
        originalCost_Label.isHidden = false
        originalIconImage.isHidden = false
        
        originalCost_Label.text = "\(priceOrigin)點"
        onsale_Label.text = "\(priceOnSales)點"
      } else {
        onlyIconImage.isHidden = false
        onlyMoneyLabel.isHidden = false
        onsale_Label.isHidden = true
        onsaleIconImage.isHidden = true
        deletionView.isHidden = true
        originalCost_Label.isHidden = true
        originalIconImage.isHidden = true
        
        onlyMoneyLabel.text = "\(priceOrigin)點"
      }
    }
    
  }
  
  // MARK: - Money
  // Get Money
  func getMoney(){
    guard let uid = self.uid else { return }
    self.databaseRef.child("Money").observeSingleEvent(of: .value) { (snapshot) in
      if snapshot.hasChild(uid) {
        self.databaseRef.child("Money/\(uid)/money").observeSingleEvent(of: .value) { (snapshot) in
          if let money = snapshot.value as? String{
            self.myMoney = money
          }
        }
      }
    }
  }
  
  // MARK: - User Course
  // check if user has this course
  func ifUserHasCourse(){
    guard let uid = self.uid, let courseId = detailToGet.courseId else { return }
    databaseRef.child("BoughtCourses").observeSingleEvent(of: .value) { (snapshot) in
      if snapshot.hasChild(uid){
        self.databaseRef.child("BoughtCourses").child(uid).observe(.value) { (snapshot) in
          for child in snapshot.children{
            let snap = child as! DataSnapshot
            
            if snap.key == courseId {
              self.thisCourseHasBought = true
              return
            }
            
          }
        }
      }
    }
  }
  
  // MARK: - Audio
  // fetch audio files
  func fetchSectionTitle(withCourseId: String){
    databaseRef.child("AudioPlayerSection").child(withCourseId).observe(.value) { (snapshot) in
      if let array = snapshot.value as? [String]{
        self.sections = array
      }
      
    }
    self.fetchAudioFiles(withCourseId: withCourseId)
  }
  // fetch audio sections
  func fetchAudioFiles(withCourseId: String){
    var tempSection = -1
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
  
  
  // MARK: - Buy
  // depend on price onsale or origin, add to bought course, add to money, thisCourseHasBought update, alert success or error
  func buy(){
    guard let uid = self.uid, let money = myMoney, let courseId = detailToGet.courseId else { return }
    if let moneyInt = Int(money) {
      if let priceOnSales = detailToGet.priceOnSales, let priceOrigin = detailToGet.priceOrigin{
        
        // Depend on priceOnSales or priceOrigin
        var courseMoneyInt = 0
        if priceOnSales >= 0 {
          courseMoneyInt = priceOnSales
        } else {
          courseMoneyInt = priceOrigin
        }
        
        if moneyInt >= courseMoneyInt{
          
          // Add to BoughtCourses of each person
          let jsonEncoder = JSONEncoder()
          let jsonData = try? jsonEncoder.encode(detailToGet)
          let json = String(data: jsonData!, encoding: String.Encoding.utf8)
          let result = convertToDictionary(text: json!)
          databaseRef.child("BoughtCourses").child(uid).child(courseId).setValue(result)
          
          // Add to Money
          let moneyLeft = String(moneyInt - courseMoneyInt)
          self.myMoney = moneyLeft
          self.databaseRef.child("Money").child(uid).child("money").setValue(self.myMoney)
          
          // Alert Success
          SVProgressHUD.showSuccess(withStatus: "購買成功")
          DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            SVProgressHUD.dismiss()
          })
          self.thisCourseHasBought = true
          
        } else {
          //Alert not enough money
          SVProgressHUD.showError(withStatus: "購買失敗")
          DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            SVProgressHUD.dismiss()
          })
        }
        
      }
    }
  }
  // data convert to dictionary
  func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
      do {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
      } catch {
        print(error.localizedDescription)
      }
    }
    return nil
  }
  
  @objc func tryOutButtonTapped(_ sender: UIButton){
    self.thisSong = sender.tag
    self.detailToPass = audioItem_Array
    for (index, value) in detailToPass.enumerated() {
      if let audioItems = value {
        if let audioItemsTryOut = audioItems.TryOutEnable{
          if audioItemsTryOut == -1 {
            self.detailToPass[index] = nil
          }
        }
      }
    }
    
    performSegue(withIdentifier: "identifierPlayer", sender: self)
  }
}
