//
//  CourseDetailViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/21.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CourseDetailViewController: UIViewController {
  
  var selectedRowIndex = -1

  var detailToGet = HomeCourses()
  var uid = ""
  
  @IBOutlet weak var tableviewToBottom: NSLayoutConstraint!
  @IBOutlet weak var buy_View: UIView!
  @IBOutlet weak var buy_Button: UIButton!
  @IBOutlet weak var mainIconImage: UIImageView!
  @IBOutlet weak var cost_Label: UILabel!
  @IBOutlet weak var accountIconImage: UIImageView!
  @IBOutlet weak var account_Label: UILabel!
  @IBOutlet weak var deletionView: UIView!
  
  
  @IBOutlet weak var onlyIconImage: UIImageView!
  @IBOutlet weak var onlyMoneyLabel: UILabel!
  
  @IBAction func buy_Button_Tapped(_ sender: UIButton) {
    if uid != "guest"{
      buy()
    } else {
      //Alert Not logged in yet
    }
  }
  
  
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
  var myMoney = "0"
  var courseId = ""
  func buy(){
    
    let moneyInt = Int(myMoney)
    if let courseMoneyString = detailToGet.price{
      let courseMoneyInt = Int(courseMoneyString)
      if moneyInt! >= courseMoneyInt!{
        
        
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(detailToGet)
        let json = String(data: jsonData!, encoding: String.Encoding.utf8)
     
        let result = convertToDictionary(text: json!)
        databaseRef.child("BoughtCourses").child(self.uid).child(courseId).setValue(result)
        let moneyLeft = String(moneyInt! - courseMoneyInt!)
        self.myMoney = moneyLeft
      self.databaseRef.child("Money").child(self.uid).child("money").setValue(self.myMoney)
        
        
        // ALERT Success
        self.alertSuccess()
        self.thisCourseHasBought = true
        self.buy_View.isHidden = true
        
        
      } else {
        //Alert not enough money
      }
    }
    
  }
  func money(){
    self.databaseRef.child("Money").child(uid).child("money").observeSingleEvent(of: .value) { (snapshot) in
      if let money = snapshot.value as? String{
        self.myMoney = money
      }
    }
  }
  
  
  var array_CourseID = [String]()
  var databaseRef: DatabaseReference!
  func usersCourses(){
    databaseRef.child("BoughtCourses").observeSingleEvent(of: .value) { (snapshot) in
      if snapshot.hasChild(self.uid){
        self.databaseRef.child("BoughtCourses").child(self.uid).observe(.value) { (snapshot) in
          for child in snapshot.children{
            let snap = child as! DataSnapshot
            self.array_CourseID.append(snap.key)
            
          }
          self.boughtOrNot()
        }
      } else {
        print("Hasn't bought anything yet")
      }
      
    }
  }
  func boughtOrNot(){
    for i in array_CourseID{
      if i == detailToGet.courseId{
        buy_View.isHidden = true
        thisCourseHasBought = true
      }
    }
    
  }
  var thisCourseHasBought = false
  {
    didSet
    {
      if thisCourseHasBought == true {
        tableviewToBottom.constant = 0
      } else {
        tableviewToBottom.constant = 50
      }
    }
  }
  
  @IBOutlet weak var tableView: UITableView!
  enum DetailViewSection: Int{
    case main = 0
    case courseInfo = 1
    case teacherInfo = 2
    case courses = 3
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self

    mainIconImage.tintColor = UIColor.moneyYellow()
    accountIconImage.tintColor = UIColor.moneyYellow()
    onlyIconImage.tintColor = UIColor.moneyYellow()
    
    if let onSalesPrice = detailToGet.onSalesPrice{
      if onSalesPrice == "-1"{
        account_Label.isHidden = true
        accountIconImage.isHidden = true
        deletionView.isHidden = true
        cost_Label.isHidden = true
        mainIconImage.isHidden = true
        
        onlyIconImage.isHidden = false
        onlyMoneyLabel.isHidden = false
        
        if let price = detailToGet.price {
          onlyMoneyLabel.text = "\(price)點"
        }
      } else {
        onlyIconImage.isHidden = true
        onlyMoneyLabel.isHidden = true
        
        account_Label.isHidden = false
        accountIconImage.isHidden = false
        deletionView.isHidden = false
        cost_Label.isHidden = false
        mainIconImage.isHidden = false
        
        if let price = detailToGet.price {
          cost_Label.text = "\(price)點"
        }
        account_Label.text = "\(onSalesPrice)點"
      }
      
    }
    

    
    databaseRef = Database.database().reference()
    let userDefaults = UserDefaults.standard
    uid = userDefaults.string(forKey: "uid") ?? ""
    print("uid is \(uid)")
    courseId = detailToGet.courseId!
    
//    fetchAudioFiles(withCourseId: courseId)
    fetchSectionTitle(withCourseId: courseId)
    
    
    money()
    usersCourses()
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
  
  var audioItem_Array = [AudioItem]()

  
  var audioDictionary = [Int: [AudioItem]]()
  // [0: [AudioItem1, AudioItem2], 1: [AudioItem1]]
  var sections = [String]()
  var sectionCount = 0
  
  
  var thisSong = 0
  @objc func player_Button_Tapped(sender: UIButton){
    
    if self.thisCourseHasBought == true {
      self.thisSong = sender.tag
      print("sender tag is \(sender.tag)")
      performSegue(withIdentifier: "identifierPlayer", sender: self)
    } else {
      self.alertNotBought()
    }
    
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "identifierPlayerList"{
      let destination = segue.destination as! AudioListViewController
      destination.idToGet = detailToGet.courseId!
      destination.audioItem_Array = audioItem_Array
      destination.audioDictionary = audioDictionary
      destination.sections = sections
    } else if segue.identifier == "identifierTeacher"{
      let destination = segue.destination as! TeacherViewController
      destination.courseToGet = detailToGet
      destination.idToGet = detailToGet.teacherID!
    } else if segue.identifier == "identifierPlayer"{
      let destination = segue.destination as! PlayerViewController
      destination.audioData = audioItem_Array
      destination.thisSong = self.thisSong
    }
  }
  
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension CourseDetailViewController: UITableViewDelegate, UITableViewDataSource{
  func numberOfSections(in tableView: UITableView) -> Int {
    if tableView.tag == 100 {
      return 4
    }
    if tableView.tag == 90 {
      return audioDictionary.count
    }
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView.tag == 100 {
      switch section {
      case DetailViewSection.main.rawValue:
        return 1
      case DetailViewSection.courseInfo.rawValue:
        return 1
      case DetailViewSection.teacherInfo.rawValue:
        return 1
      case DetailViewSection.courses.rawValue:
        return 1
      default: fatalError()
      }
    }
    if tableView.tag == 90{
      //return audioItem_Array.count
      return audioDictionary[section]!.count+1 /// danger!!!
    }
    return 1
    
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView.tag == 100 {
      switch indexPath.section {
      case DetailViewSection.main.rawValue:
        let cell = tableView.dequeueReusableCell(withIdentifier: "main", for: indexPath) as! MainTableViewCell
        cell.courseHour_Label.text = detailToGet.hour
        if let iconUrl = detailToGet.overViewImage{
          let url = URL(string: iconUrl)
          cell.overview_ImageView.kf.setImage(with: url)
        }
        cell.title_Label.text = detailToGet.title
        
        return cell
      case DetailViewSection.courseInfo.rawValue:
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseInfo", for: indexPath) as! CourseInfoTableViewCell
        cell.courseInfo_Label.text = detailToGet.courseDescription
        
        
        return cell
      case DetailViewSection.teacherInfo.rawValue:
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacherInfo", for: indexPath) as! TeacherInfoTableViewCell
        cell.teacherName_Label.text = detailToGet.authorName
        cell.teacherIntro_Label.text = detailToGet.authorDescription
        if let iconUrl = detailToGet.authorImage{
          let url = URL(string: iconUrl)
          cell.teacherPic_ImageView.kf.setImage(with: url)
        }
        
        return cell
      case DetailViewSection.courses.rawValue:
        let cell = tableView.dequeueReusableCell(withIdentifier: "courses", for: indexPath) as! CoursesTableViewCell
        cell.course_TableView.reloadData()
        return cell
      default: fatalError()
      }
    }
    if tableView.tag == 90{
      if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "audioHeader", for: indexPath) as! AudioSectionTableViewCell
        cell.title_Label.text = sections[indexPath.section]
        return cell
        
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AudioListTableViewCell
        let audioArray = audioDictionary[indexPath.section]
       // print("indexpath row is \(indexPath.row)")
        cell.topic_Label.text = audioArray![indexPath.row-1].Title//danger
        cell.time_Label.text = audioArray![indexPath.row-1].Time//danger
        
        
        if let _ = audioArray {
          
          var rowForPlay = 0
          for i in 0...indexPath.section {
            // addition of total row by section from dictionary
            let rowCountDependOnI = audioDictionary[i]?.count
            if let rowCountDependOnI = rowCountDependOnI {
              cell.play_Button.tag = rowForPlay - 1 + indexPath.row
              cell.play_Button.addTarget(self, action: #selector(player_Button_Tapped(sender:)), for: .touchUpInside)
              rowForPlay += rowCountDependOnI
              
            }
          }
          
          
        }
        
        //  cell.topic_Label.text = audioItem_Array[indexPath.row].Title
//        cell.time_Label.text = audioItem_Array[indexPath.row].Time
        return cell
      }
      
      
    }
    return UITableViewCell()
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView.tag == 100 {
      switch indexPath.section {
      case DetailViewSection.main.rawValue: break
        
      case DetailViewSection.courseInfo.rawValue:
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseInfo", for: indexPath) as! CourseInfoTableViewCell
        if selectedRowIndex == indexPath.section {
          selectedRowIndex = -1
          cell.expandIcon_Button.setImage(UIImage(named: "往上"), for: .normal)
        } else {
          selectedRowIndex = indexPath.section
          cell.expandIcon_Button.setImage(UIImage(named: "往上"), for: .normal)
          
        }
        let index = IndexPath(item: 0, section: 1)
        tableView.reloadRows(at: [index], with: .automatic)
      case DetailViewSection.teacherInfo.rawValue:
        performSegue(withIdentifier: "identifierTeacher", sender: self)
      case DetailViewSection.courses.rawValue:
        
        break
        
      default: fatalError()
      }
    } else if tableView.tag == 90 {
      
      print("indexPath section is \(indexPath.section)\nindexPath row is \(indexPath.row)")
    }
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if tableView.tag == 100 {
      switch indexPath.section {
      case DetailViewSection.main.rawValue:
        return UITableViewAutomaticDimension
      case DetailViewSection.courseInfo.rawValue:
        if indexPath.section == selectedRowIndex {
          return UITableViewAutomaticDimension //Expanded
        }
        return 200.0 //Not expanded
      case DetailViewSection.teacherInfo.rawValue:
        return 249.0
      case DetailViewSection.courses.rawValue:
        return 500.0
      //return 591.0
      default:
        fatalError()
      }
    }
    if tableView.tag == 90 {
      return 68.0
    }
    return 68.0
  }
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    if tableView.tag == 100 {
      switch indexPath.section {
      case DetailViewSection.main.rawValue:
        return 367.0
      case DetailViewSection.courseInfo.rawValue:
        if indexPath.section == selectedRowIndex {
          return 400 //Expanded
        }
        return 0 //Not expanded
      case DetailViewSection.teacherInfo.rawValue:
        return 0
      case DetailViewSection.courses.rawValue:
        return 0
      default:
        fatalError()
      }
    }
    if tableView.tag == 90 {
      return 0
    }
    return 0
  }
  
}
// MARK: - Alerts
extension CourseDetailViewController {
  
  func alertSuccess(){
    let alert = UIAlertController(title: "成功購買課程", message: "您現在可以進行課程。", preferredStyle: .alert)
    
    
    let confirmAction = UIAlertAction(
      title: "確定",
      style: .cancel,
      handler: nil)
    alert.addAction(confirmAction)
    
    
    self.present(alert, animated: true)
  }
  func alertNotBought(){
    let alert = UIAlertController(title: "您尚未購買此課程", message: "", preferredStyle: .alert)
    
    
    let confirmAction = UIAlertAction(
      title: "確認",
      style: .cancel,
      handler: nil)
    alert.addAction(confirmAction)
    
    
    
    self.present(alert, animated: true)
  }
}
// MARK: - APIs
extension CourseDetailViewController {
  func fetchAudioFiles(withCourseId: String){
    var databaseRef: DatabaseReference!
    databaseRef = Database.database().reference()
    databaseRef.child("AudioPlayer").child(withCourseId).observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: Any]{
        let audioItem = AudioItem()
        audioItem.Audio = dictionary["Audio"] as? String
        audioItem.Section = dictionary["Section"] as? String
        audioItem.Time = dictionary["Time"] as? String
        audioItem.Title = dictionary["Title"] as? String
        audioItem.Topic = dictionary["Topic"] as? String
        audioItem.SectionPriority = dictionary["SectionPriority"] as? Int
        audioItem.RowPriority = dictionary["RowPriority"] as? Int
        audioItem.TryOutEnable = dictionary["TryOutEnable"] as? Int
        
        self.audioItem_Array.append(audioItem)

        //if audioItem.SectionPriority
        for i in 0...self.sectionCount-1{
          guard let sectionNumber = audioItem.SectionPriority else { return }
          if i == sectionNumber {
            if var previousInfo = self.audioDictionary[i] {
              previousInfo.append(audioItem)
              self.audioDictionary.updateValue(previousInfo, forKey: i)
            } else {
              self.audioDictionary.updateValue([audioItem], forKey: i)
            }
            print("dicccc \(self.audioDictionary)")
            DispatchQueue.main.async {
              
              self.tableView.reloadData()
              
            }
          }
          
        }
        
        
        //self.tableView.reloadData()
        
      }
    }
  }
  
  func fetchSectionTitle(withCourseId: String){
    var databaseRef: DatabaseReference!
    databaseRef = Database.database().reference()
    
    databaseRef.child("AudioPlayerSection").child(withCourseId).observe(.value) { (snapshot) in
      if let array = snapshot.value as? [String]{
        self.sections = array
        self.sectionCount = array.count
        self.fetchAudioFiles(withCourseId: withCourseId)
      }
      
    }
    
  }
}
