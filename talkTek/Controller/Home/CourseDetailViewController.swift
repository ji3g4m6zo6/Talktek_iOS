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
  var audioItem_Array = [AudioItem]()
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
    print(detailToGet.title ?? "")
    
    databaseRef = Database.database().reference()
    let userDefaults = UserDefaults.standard
    uid = userDefaults.string(forKey: "uid") ?? ""
    print("uid is \(uid)")
    courseId = detailToGet.courseId!
    
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "identifierPlayer"{
      let destination = segue.destination as! AudioListViewController
      destination.idToGet = detailToGet.courseId!
    } else if segue.identifier == "identifierTeacher"{
      let destination = segue.destination as! TeacherViewController
      destination.idToGet = detailToGet.teacherID!
    }
  }
  
}

extension CourseDetailViewController: UITableViewDelegate, UITableViewDataSource{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
      cell.setDatasource(courseId: detailToGet.courseId!)
      return cell
    default: fatalError()
    }
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case DetailViewSection.main.rawValue:
      return 357.0
    case DetailViewSection.courseInfo.rawValue:
      return 200.0
    case DetailViewSection.teacherInfo.rawValue:
      return 249.0
    case DetailViewSection.courses.rawValue:
      return 591.0
    default:
      fatalError()
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case DetailViewSection.main.rawValue: break
      
    case DetailViewSection.courseInfo.rawValue: break
      
    case DetailViewSection.teacherInfo.rawValue:
      performSegue(withIdentifier: "identifierTeacher", sender: self)
    case DetailViewSection.courses.rawValue:
      performSegue(withIdentifier: "identifierPlayer", sender: self)

      
    default: fatalError()
    }
  }
}
