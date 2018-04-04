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
import SVProgressHUD


class CouponViewController: UIViewController {
  
  @IBOutlet weak var coupon_TextField: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    coupon_TextField.layer.borderWidth = 1.0
    coupon_TextField.layer.borderColor = UIColor.borderGray().cgColor
    
    
    let userDefaults = UserDefaults.standard
    uid = userDefaults.string(forKey: "uid") ?? ""
    
    fetchData()
    
    // Do any additional setup after loading the view.
  }
  var uid = ""
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  var array_CourseID = [String]()
  @IBAction func Send_Button_Tapped(_ sender: UIButton) {
    if coupon_TextField.text != ""{
      email()
      //self.sendCoupon(coupon: coupon_TextField.text!)
    } else {
      self.alertNotEnoughInfo()
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
    
    
    databaseRef.child("AllCourses").observe(.value, with: { (snapshot) in
      for child in snapshot.children{
        let snap = child as! DataSnapshot
        self.array_CourseID.append(snap.key)
        print("key is \(snap.key)")
      }
    })
  }
  
  func sendCoupon(coupon: String){
    var databaseRef: DatabaseReference!
    databaseRef = Database.database().reference()
    
    if array_CourseID.contains(coupon_TextField.text!){
      databaseRef.child("AllCourses").child(coupon_TextField.text!).observe(.value, with: { (snapshot) in
        if let dictionary = snapshot.value as? [String: Any]{
          let homeCourses = HomeCourses()
          
          homeCourses.authorDescription = dictionary["authorDescription"] as? String
          homeCourses.authorId = dictionary["authorId"] as? String
          homeCourses.authorImage = dictionary["authorImage"] as? String
          homeCourses.authorName = dictionary["authorName"] as? String
          homeCourses.courseDescription = dictionary["courseDescription"] as? String
          homeCourses.courseId = dictionary["courseId"] as? String
          homeCourses.courseTitle = dictionary["courseTitle"] as? String
          homeCourses.overViewImage = dictionary["overViewImage"] as? String
          homeCourses.priceOnSales = dictionary["priceOnSales"] as? Int
          homeCourses.priceOrigin = dictionary["priceOrigin"] as? Int
          homeCourses.scorePeople = dictionary["scorePeople"] as? Int
          homeCourses.scoreTotal = dictionary["scoreTotal"] as? Int
          homeCourses.studentNumber = dictionary["studentNumber"] as? Int
          homeCourses.tags = dictionary["tags"] as! [String]
          
          let jsonEncoder = JSONEncoder()
          let jsonData = try? jsonEncoder.encode(homeCourses)
          let json = String(data: jsonData!, encoding: String.Encoding.utf8)
          
          let result = self.convertToDictionary(text: json!)
          databaseRef.child("BoughtCourses").child(self.uid).child(self.coupon_TextField.text!).setValue(result, withCompletionBlock: { (error, ref) in
            if error != nil {
              // Alert network error or sth
            } else {
              self.alertSuccess()
            }
          })
          
        }
      })
    } else {
      alertError()
    }
    
  }
  
  func alertError(){
    //let alertController = UIAlertController(title: "選課錯誤", message: "請確認優惠碼無誤", preferredStyle: UIAlertControllerStyle.alert)
    let alertController = UIAlertController(title: "訂閱失敗", message: "請確認信箱無誤", preferredStyle: UIAlertControllerStyle.alert)

    alertController.addAction(UIAlertAction(title: "確認", style: UIAlertActionStyle.default,handler: nil))
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  func alertSuccess(){
    let alert = UIAlertController(title: "選課成功", message: "請至課程清單查看", preferredStyle: .alert)
    
    let confirm = UIAlertAction(title: "確認", style: .default) { (action) in
      self.performSegue(withIdentifier: "identifierBack", sender: self)
    }
    alert.addAction(confirm)
    
    
    self.present(alert, animated: true)
  }
  
  func alertNotEnoughInfo(){
    let alertController = UIAlertController(title: "所有欄位均須填寫", message: "", preferredStyle: UIAlertControllerStyle.alert)
    
    alertController.addAction(UIAlertAction(title: "確認", style: UIAlertActionStyle.default,handler: nil))
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  func email(){
    guard let couponText = coupon_TextField.text else { return }
    if isValid(couponText) {
      SVProgressHUD.showSuccess(withStatus: "訂閱成功")
    } else {
      SVProgressHUD.showError(withStatus: "訂閱失敗")
    }
  }
  
  func isValid(_ email: String) -> Bool {
    let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
    let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
    return emailTest.evaluate(with: email)
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
