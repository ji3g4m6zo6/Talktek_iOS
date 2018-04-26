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
import ARNTransitionAnimator

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
  var titleOfBoughtCourses = [String]()
  var audioItem_Array = [AudioItem?]()
  var audioItemFromDatabase = [AudioItem]()
  var sections = [String]()
  var detailToPass = [AudioItem?]()
  
  // MARK: - CashFlow
  var cashFlow = CashFlow()


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
  var thisCourseHasBought: Bool?
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
  
  // MARK: - Firebase Analytics
  var homeCourseType: String?
  
  // MARK: - viewDidLoad, didReceiveMemoryWarning, viewWillDisappear
  override func viewDidLoad() {
    super.viewDidLoad()

    
    // uid from userdefaults, database init
    uid = UserDefaults.standard.string(forKey: "uid")
    databaseRef = Database.database().reference()
    
    // Tableview
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    
    // updateBuyView, fetchMoney, ifUserHasCourse
    updateBuyView()
    fetchMoney()
    //getMoney()
    ifUserHasCourse()
    
    Analytics.logEvent("facebook_login", parameters: nil)


    // fetchAudioFiles
    if let courseId = detailToGet.courseId {
      Analytics.logEvent("all_\(courseId)_home_click", parameters: nil)
      fetchSectionTitle(withCourseId: courseId)
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    if let homeCourseType = homeCourseType, let courseId = detailToGet.courseId {
      Analytics.logEvent("\(homeCourseType)_\(courseId)_course_open", parameters: nil)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    if self.isMovingFromParentViewController{
      if let homeCourseType = homeCourseType, let courseId = detailToGet.courseId {
        Analytics.logEvent("\(homeCourseType)_\(courseId)_home_click", parameters: nil)
      }
    }
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
          if let courseId = detailToGet.courseId, let homeCourseType = homeCourseType {
            Analytics.logEvent("\(homeCourseType)_\(courseId)_courseinfo_open", parameters: nil)
          }
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
        if let courseId = detailToGet.courseId, let homeCourseType = homeCourseType {
          Analytics.logEvent("\(homeCourseType)_\(courseId)_click", parameters: nil)
        }
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
  
  // Try out audio
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
  
  // fetch data from firebase check if user exist in CashFlow
  func fetchMoney(){
    guard let uid = uid else { return }
    databaseRef.child("CashFlow").observe(.value) { (value) in
      if value.hasChild(uid) {
        self.fetchCash()
      } else {
        self.cashFlow.CashValue = 0
        self.cashFlow.RewardPoints = 0
      }
    }
  }
  // fetch user's money
  func fetchCash(){
    guard let uid = uid else { return }
    databaseRef.child("CashFlow/\(uid)/Total").observe(.value, with: { (snapshot) in
      if let dictionary = snapshot.value as? [String: Int] {
        if let cashValue = dictionary["CashValue"], let rewardPoints = dictionary["RewardPoints"]{
          self.cashFlow.CashValue = cashValue
          self.cashFlow.RewardPoints = rewardPoints
        }
      }
    })
  }
  
  // MARK: - User Course
  // check if user has this course
  func ifUserHasCourse(){
    guard let uid = self.uid, let courseId = detailToGet.courseId else { return }
    databaseRef.child("BoughtCourses").observeSingleEvent(of: .value) { (snapshot) in
      if snapshot.hasChild(uid){
        self.databaseRef.child("BoughtCourses").child(uid).observe(.value) { (snapshot) in
          
          if let array = snapshot.value as? [String]{
            self.titleOfBoughtCourses = array
            array.forEach({ (value) in
              if value == courseId {
                self.thisCourseHasBought = true
              }
            })
          }
          
          if let _ = self.thisCourseHasBought {
            
          } else {
            self.thisCourseHasBought = false
          }

        }
      } else {
        self.thisCourseHasBought = false
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
        audioItem.RowPriority = dictionary["RowPriority"] as? Int
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
    guard let uid = self.uid, let money = cashFlow.RewardPoints, let courseId = detailToGet.courseId else { return }
    if let priceOnSales = detailToGet.priceOnSales, let priceOrigin = detailToGet.priceOrigin{
      
      // Depend on priceOnSales or priceOrigin
      var courseMoneyInt = 0
      if priceOnSales >= 0 {
        courseMoneyInt = priceOnSales
      } else {
        courseMoneyInt = priceOrigin
      }
      
      if money >= courseMoneyInt{
        
        // Add to BoughtCourses of each person
        titleOfBoughtCourses.append(courseId)
        databaseRef.child("BoughtCourses").child(uid).setValue(self.titleOfBoughtCourses)
        
        // Add to Money
//        let moneyLeft = String(money - courseMoneyInt)
//        self.myMoney = moneyLeft
//        self.databaseRef.child("Money").child(uid).child("money").setValue(self.myMoney)
        addRewardPoints(addRewardPoints: courseMoneyInt)
        addPointsToHistory()
        
        // Alert Success
        SVProgressHUD.showSuccess(withStatus: "購買成功")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
          SVProgressHUD.dismiss()
        })
        thisCourseHasBought = true
        
      } else {
        //Alert not enough money
        SVProgressHUD.showError(withStatus: "購買失敗")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
          SVProgressHUD.dismiss()
        })
      }
      
      
    }
  }
  
  // update point
  func addRewardPoints(addRewardPoints: Int){
    guard let uid = uid, let rewardPoints = cashFlow.RewardPoints else { return }
    databaseRef.child("CashFlow/\(uid)/Total").child("RewardPoints").setValue(rewardPoints - addRewardPoints)
  }
  
  // add point to history
  func addPointsToHistory(){
    guard let uid = uid, let courseId = detailToGet.courseId, let priceOnSales = detailToGet.priceOnSales, let priceOrigin = detailToGet.priceOrigin else { return }
    let currentTime = getCurrentTime()
    if priceOnSales >= 0 {
      let parameter = ["Time": currentTime, "CashType": "購買課程\(courseId)", "Value": -priceOnSales, "Unit": "點數"] as [String : Any]
      databaseRef.child("CashFlow/\(uid)/History").childByAutoId().setValue(parameter)
    } else {
      let parameter = ["Time": currentTime, "CashType": "購買課程\(courseId)", "Value": -priceOrigin, "Unit": "點數"] as [String : Any]
      databaseRef.child("CashFlow/\(uid)/History").childByAutoId().setValue(parameter)
    }
  }
  
  // get current time for history usage
  func getCurrentTime() -> String{
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return formatter.string(from: date)
  }
  
  
}
