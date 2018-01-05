//
//  BecomeLecturerViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/28.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class BecomeLecturerViewController: UIViewController, UITextViewDelegate {
  @IBOutlet weak var name_TextField: UITextField!
  @IBOutlet weak var email_TextField: UITextField!
  @IBOutlet weak var topic_TextField: UITextField!
  @IBOutlet weak var description_TextView: UITextView!
  
  var databaseRef: DatabaseReference!
  var userID = ""

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.hideKeyboardWhenTappedAround()
    name_TextField.layer.borderWidth = 1.0
    name_TextField.layer.borderColor = UIColor.borderGray().cgColor
    
    email_TextField.layer.borderWidth = 1.0
    email_TextField.layer.borderColor = UIColor.borderGray().cgColor
    
    topic_TextField.layer.borderWidth = 1.0
    topic_TextField.layer.borderColor = UIColor.borderGray().cgColor
    
    description_TextView.layer.borderWidth = 1.0
    description_TextView.layer.borderColor = UIColor.borderGray().cgColor
    description_TextView.textColor = UIColor.lightGray
    description_TextView.delegate = self
  }
  func textViewDidBeginEditing(_ textView: UITextView) {
    if description_TextView.textColor == UIColor.lightGray {
      description_TextView.text = nil
      description_TextView.textColor = UIColor.black
    }
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    if description_TextView.text.isEmpty {
      description_TextView.text = "輸入課程內容"
      description_TextView.textColor = UIColor.lightGray
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func Send_Button_Tapped(_ sender: UIButton) {
    postData()
  }
  
  func postData(){
    if name_TextField.text != "" && email_TextField.text != "" && topic_TextField.text != "" && description_TextView.text != ""{
      self.databaseRef = Database.database().reference()
      let post: [String: String] = [
        "name": name_TextField.text!,
        "email": email_TextField.text!,
        "topic": topic_TextField.text!,
        "description": description_TextView.text!
      ]
      self.databaseRef.child("BecomeLecturer").childByAutoId().setValue(post, withCompletionBlock: { (error, databaseRef) in
        if error != nil {
          print(error?.localizedDescription ?? "Failed to update value")
        } else {
          print("Success update newValue to database")
          self.alertSuccess()
        }
      })
    } else {
      
      alertError()
    }
  }
  
  func alertSuccess(){
    let alert = UIAlertController(title: "上傳成功", message: "Talktek會儘速與您聯絡", preferredStyle: .alert)
    
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
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}

extension BecomeLecturerViewController {
  
  func hideKeyboardWhenTappedAround(){
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
}
