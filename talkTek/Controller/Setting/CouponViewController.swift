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
  
  var uid: String?
  var databaseRef: DatabaseReference!

  var isUsingCoupon = false
  
  
  // MARK: - CashFlow
  var cashFlow = CashFlow()

  @IBOutlet weak var coupon_TextField: UITextField!
  @IBOutlet weak var confirmButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    coupon_TextField.layer.borderWidth = 1.0
    coupon_TextField.layer.borderColor = UIColor.borderGray().cgColor
    
    if isUsingCoupon {
      self.title = "優惠碼"
      coupon_TextField.placeholder = "輸入優惠碼"
      confirmButton.setTitle("兌換", for: .normal)
    }
    
    uid = UserDefaults.standard.string(forKey: "uid")
    databaseRef = Database.database().reference()

    fetchData()
    
    // Do any additional setup after loading the view.
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  var array_CourseID = [String]()
  @IBAction func Send_Button_Tapped(_ sender: UIButton) {
    guard let coupon = coupon_TextField.text else { return }
    if coupon != ""{
      isUsingCoupon ? sendCoupon(coupon: coupon) : email()
    } else {
      self.alertNotEnoughInfo()
    }
    
  }
  
  
  func fetchData(){
    databaseRef.child("AllCourses").observe(.value, with: { (snapshot) in
      for child in snapshot.children{
        let snap = child as! DataSnapshot
        self.array_CourseID.append(snap.key)
      }
    })
  }
  
  func sendCoupon(coupon: String){
    guard let _ = uid else { return }
    if array_CourseID.contains(coupon){
      ifUserHasCourse(coupon: coupon)
    } else {
      alertError()
    }
    
  }
  
  func alertError(){
    let alertController = UIAlertController(title: "選課錯誤", message: "請確認優惠碼無誤", preferredStyle: UIAlertControllerStyle.alert)

    alertController.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
    
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
  
  func alertHasBought(){
    let alert = UIAlertController(title: "選課失敗", message: "您已購買過此課程", preferredStyle: .alert)
    
    let confirm = UIAlertAction(title: "確認", style: .cancel, handler: nil)
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
      DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
        SVProgressHUD.dismiss()
      })

    } else {
      SVProgressHUD.showError(withStatus: "訂閱失敗")
      DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
        SVProgressHUD.dismiss()
      })

    }
  }
  
  func isValid(_ email: String) -> Bool {
    let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
    let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
    return emailTest.evaluate(with: email)
  }
  
  
  var thisCourseHasBought = false
  {
    didSet {
      if thisCourseHasBought {
        alertHasBought()
      }
    }
  }
  
  
  // check if user has this course
  func ifUserHasCourse(coupon: String){
    guard let uid = self.uid else { return }
    databaseRef.child("BoughtCourses").observeSingleEvent(of: .value) { (snapshot) in
      if snapshot.hasChild(uid){
        self.databaseRef.child("BoughtCourses").child(uid).observeSingleEvent(of: .value) { (snapshot) in
          
          if let array = snapshot.value as? [String]{
            self.titleOfBoughtCourses = array
            for value in array {
              if value == coupon {
                self.thisCourseHasBought = true
                return
              }
            }
            
            self.thisCourseHasBought = false
            self.buy(coupon: coupon)
          }
          

        }
      } else {
        self.thisCourseHasBought = false
        self.buy(coupon: coupon)

      }
    }
  }
  var titleOfBoughtCourses = [String]()

  func buy(coupon: String){
    guard let uid = self.uid else { return }
    databaseRef.child("AllCourses/\(coupon)/studentNumber").runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
      
      if var studentNumber = currentData.value as? Int{
        
        
            // update studentNumber
            studentNumber += 1
            currentData.value = studentNumber
        
            // Add to BoughtCourses of each person
            self.titleOfBoughtCourses.append(coupon)
            self.databaseRef.child("BoughtCourses").child(uid).setValue(self.titleOfBoughtCourses)
            
            
            self.addRewardPoints(addRewardPoints: 0)
            self.addPointsToHistory(coupon: coupon)
            
            // Alert Success
//            SVProgressHUD.showSuccess(withStatus: "購買成功")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//              SVProgressHUD.dismiss()
//            })
            self.alertSuccess()
        
        return TransactionResult.success(withValue: currentData)
        
      }
      
      
      
      return TransactionResult.success(withValue: currentData)
    }) { (error, committed, snapshot) in
      if let error = error {
        print(error.localizedDescription)
        SVProgressHUD.showError(withStatus: "購買失敗")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
          SVProgressHUD.dismiss()
        })
      }
    }
    
    
  }
  
  // update point
  func addRewardPoints(addRewardPoints: Int){
    guard let uid = uid else { return }
    let rewardPoints = cashFlow.RewardPoints
    databaseRef.child("CashFlow/\(uid)/Total").child("RewardPoints").setValue(rewardPoints - addRewardPoints)
  }
  
  // add point to history
  func addPointsToHistory(coupon: String){
    guard let uid = uid else { return }
    let currentTime = getCurrentTime()
    let parameter = ["Time": currentTime, "CashType": "購買課程\(coupon)", "Value": 0, "Unit": "點數"] as [String : Any]
    databaseRef.child("CashFlow/\(uid)/History").childByAutoId().setValue(parameter)
  }
  
  // get current time for history usage
  func getCurrentTime() -> String{
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return formatter.string(from: date)
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
