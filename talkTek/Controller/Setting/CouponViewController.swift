//
//  CouponViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/28.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CouponViewController: UIViewController {
  
  @IBOutlet weak var coupon_TextField: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    coupon_TextField.layer.borderWidth = 1.0
    coupon_TextField.layer.borderColor = UIColor.borderGray().cgColor
    
    
    let userDefaults = UserDefaults.standard
    uid = userDefaults.string(forKey: "uid") ?? ""
    
    fetchData()
    
    self.hideKeyboardWhenTappedAround()
    // Do any additional setup after loading the view.
  }
  var uid = ""
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  var array_CourseID = [String]()
  @IBAction func Send_Button_Tapped(_ sender: UIButton) {
    var databaseRef: DatabaseReference!
    databaseRef = Database.database().reference()
    for i in array_CourseID{
      if i == coupon_TextField.text!{
        databaseRef.child("AllCourses").child(i).observe(.value, with: { (snapshot) in
          if let dictionary = snapshot.value as? [String: String]{
            let homeCourses = HomeCourses()
            
            homeCourses.authorDescription = dictionary["authorDescription"]
            homeCourses.authorImage = dictionary["authorImage"]
            homeCourses.authorName = dictionary["authorName"]
            homeCourses.courseDescription = dictionary["courseDescription"]
            homeCourses.hour = dictionary["hour"]
            homeCourses.overViewImage = dictionary["overViewImage"]
            homeCourses.price = dictionary["price"]
            homeCourses.score = dictionary["score"]
            homeCourses.studentNumber = dictionary["studentNumber"]
            homeCourses.title = dictionary["title"]
            homeCourses.courseId = dictionary["courseId"]
            homeCourses.teacherID = dictionary["teacherID"]
            
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(homeCourses)
            let json = String(data: jsonData!, encoding: String.Encoding.utf8)
            
            let result = self.convertToDictionary(text: json!)
            databaseRef.child("BoughtCourses").child(self.uid).child(i).setValue(result)
          }
        })
        
        
      }
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
  func fetchData(){
    var databaseRef: DatabaseReference!
    databaseRef = Database.database().reference()
    if coupon_TextField.text != ""{
      databaseRef.child("AllCourses").observe(.value, with: { (snapshot) in
        for child in snapshot.children{
          let snap = child as! DataSnapshot
          self.array_CourseID.append(snap.key)
        }
      })
    }
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
extension CouponViewController {
  
  func hideKeyboardWhenTappedAround(){
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
}
