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
    
    self.hideKeyboardWhenTappedAround()
    
    name_TextField.layer.borderWidth = 1.0
    name_TextField.layer.borderColor = UIColor.borderGray().cgColor
    
    email_TextField.layer.borderWidth = 1.0
    email_TextField.layer.borderColor = UIColor.borderGray().cgColor
    
  
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
          self.successfulAlert()
        }
      })
    } else {
      bottomAlert()
    }
  }
  
  func successfulAlert() {
    // 建立一個提示框
    let alertController = UIAlertController(
      title: "成功上傳",
      message: "TalkTek會儘速與您聯絡。",
      preferredStyle: .alert)
    
    // 建立[確認]按鈕
    let okAction = UIAlertAction(
      title: "確認",
      style: .default,
      handler: {
        (action: UIAlertAction!) -> Void in
        print("按下確認後，閉包裡的動作")
        self.navigationController?.popViewController(animated: true)

    })
    alertController.addAction(okAction)
    
    // 顯示提示框
    self.present(
      alertController,
      animated: true,
      completion: nil)
  }
  func bottomAlert() {
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
extension SuggestionViewController {
  
  func hideKeyboardWhenTappedAround(){
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
}
