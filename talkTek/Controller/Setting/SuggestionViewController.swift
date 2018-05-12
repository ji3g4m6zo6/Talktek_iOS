//
//  SuggestionViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/28.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SuggestionViewController: UIViewController, UITextViewDelegate {
  @IBOutlet weak var name_TextField: UITextField!
  @IBOutlet weak var email_TextField: UITextField!
  
  @IBOutlet weak var description_TextView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    name_TextField.layer.borderWidth = 1.0
    name_TextField.layer.borderColor = UIColor.borderGray().cgColor
    
    email_TextField.layer.borderWidth = 1.0
    email_TextField.layer.borderColor = UIColor.borderGray().cgColor
    
  
    description_TextView.layer.borderWidth = 1.0
    description_TextView.layer.borderColor = UIColor.borderGray().cgColor
    description_TextView.textColor = UIColor.greyPlaceholderColor()
    description_TextView.delegate = self
  }
  func textViewDidBeginEditing(_ textView: UITextView) {
    if description_TextView.textColor == UIColor.greyPlaceholderColor() {
      description_TextView.text = nil
      description_TextView.textColor = UIColor.black
    }
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    if description_TextView.text.isEmpty {
      description_TextView.text = "輸入內容"
      description_TextView.textColor = UIColor.greyPlaceholderColor()
    }
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func Send_Button_Tapped(_ sender: UIButton) {
    postData()
  }
  var databaseRef: DatabaseReference!
  var userID = ""
  func postData(){
    if name_TextField.text != "" && email_TextField.text != ""  && description_TextView.text != ""{
      self.databaseRef = Database.database().reference()
      let post: [String: String] = [
        "name": name_TextField.text!,
        "email": email_TextField.text!,
        "description": description_TextView.text!
      ]
      self.databaseRef.child("Suggestion").childByAutoId().setValue(post, withCompletionBlock: { (error, ref) in
        if error != nil {
          print(error?.localizedDescription ?? "Failed to update value")
        } else {
          print("Success update newValue to database")
          Analytics.logEvent("feedback_submit_done", parameters: nil)
          self.alertSuccess()
        }
      })
    } else {
      alertError()
    }
  }
  
  func alertSuccess() {
    let alert = UIAlertController(title: "上傳成功", message: "非常感謝您的建議，若有需要Talktek會儘速與您聯絡。", preferredStyle: .alert)
    
    let confirm = UIAlertAction(title: "確認", style: .default) { (action) in
      self.performSegue(withIdentifier: "identifierBack", sender: self)
    }
    alert.addAction(confirm)
    
    
    self.present(alert, animated: true)
  }
  func alertError() {
    // 建立一個提示框
    let alertController = UIAlertController(
      title: "資料不足",
      message: "所有空格皆須填寫。",
      preferredStyle: .actionSheet)
    
    // 建立[取消]按鈕
    let cancelAction = UIAlertAction(
      title: "取消",
      style: .cancel,
      handler: nil)
    alertController.addAction(cancelAction)
    
    // 建立[確認]按鈕
    let okAction = UIAlertAction(
      title: "確認",
      style: .default,
      handler: nil)
    alertController.addAction(okAction)
    
    // 顯示提示框
    self.present(
      alertController,
      animated: true,
      completion: nil)
  }
  
  
  
}
