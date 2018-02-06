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
  
  @IBOutlet weak var buy_View: UIView!
  @IBOutlet weak var buy_Button: UIButton!
  
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
  
  
  @IBOutlet weak var cost_Label: UILabel!
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
          print("array_CourseID is \(self.array_CourseID)")
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
    print(detailToGet.title ?? "")
    
    databaseRef = Database.database().reference()
    let userDefaults = UserDefaults.standard
    uid = userDefaults.string(forKey: "uid") ?? ""
    print("uid is \(uid)")
    courseId = detailToGet.courseId!
    
    fetchAudioFiles(withCourseId: courseId)
    
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

  func fetchAudioFiles(withCourseId: String){
    var databaseRef: DatabaseReference!
    databaseRef = Database.database().reference()
    databaseRef.child("AudioPlayer").child(courseId).observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: Any]{
        let audioItem = AudioItem()
        audioItem.Audio = dictionary["Audio"] as? String
        audioItem.Section = dictionary["Section"] as? String
        audioItem.Time = dictionary["Time"] as? String
        audioItem.Title = dictionary["Title"] as? String
        audioItem.Topic = dictionary["Topic"] as? String
        audioItem.SectionPriority = dictionary["SectionPriority"] as? Int
        audioItem.RowPriority = dictionary["RowPriority"] as? Int
        
        self.audioItem_Array.append(audioItem)
        print("audio topic \(audioItem.Title ?? "")")
        
        self.tableView.reloadData()
        
      }
    }
  }
  
  func parseJson(){
    
  }
  var audioDictionary = [String: [String: String]]()
  
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
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "identifierPlayer"{
      let destination = segue.destination as! AudioListViewController
      destination.idToGet = detailToGet.courseId!
      destination.audioItem_Array = audioItem_Array
    } else if segue.identifier == "identifierTeacher"{
      let destination = segue.destination as! TeacherViewController
      destination.courseToGet = detailToGet
      destination.idToGet = detailToGet.teacherID!
    }
  }
  
}

extension CourseDetailViewController: UITableViewDelegate, UITableViewDataSource{
  func numberOfSections(in tableView: UITableView) -> Int {
    if tableView.tag == 100 {
      return 4
    }
    if tableView.tag == 90 {
      return 1
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
      print("count is \(audioItem_Array.count)")
      return audioItem_Array.count
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
        //cell.setDatasource(courseId: detailToGet.courseId!)
        cell.course_TableView.reloadData()
        return cell
      default: fatalError()
      }
    }
    if tableView.tag == 90{
      let cell = tableView.dequeueReusableCell(withIdentifier: "audioFiles", for: indexPath) as! AudioFilesTableViewCell
      cell.topic_Label.text = audioItem_Array[indexPath.row].Title
      cell.time_Label.text = audioItem_Array[indexPath.row].Time
      return cell
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
        if self.thisCourseHasBought == true {
          performSegue(withIdentifier: "identifierPlayer", sender: self)
        } else {
          self.alertNotBought()
        }
        
        
      default: fatalError()
      }
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
        return 591.0
      default:
        fatalError()
      }
    }
    if tableView.tag == 90 {
      return 57.0
    }
    return 57.0
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
