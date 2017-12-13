//
//  ForgotPasswordViewController.swift
//  talkTek
//
//  Created by Mac on 2017/12/11.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ForgotPasswordViewController: UIViewController {
  
  @IBOutlet weak var email_TextField: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func pass_Button_Tapped(_ sender: UIButton) {
    if let email = email_TextField.text {
      forgetPassword(email: email)
    }
  }
  func forgetPassword(email: String){
    Auth.auth().sendPasswordReset(withEmail: email) { (error) in
      if error != nil
      {
        self.alertError()
        // Error - Unidentified Email
      }
      else
      {
        self.alert()
        // Success - Sent recovery email
      }

    }
  }
  func alert(){
    
    let alertController = UIAlertController(title: "", message: "請至信箱查收註冊驗證信。", preferredStyle: UIAlertControllerStyle.alert)
    let ok = UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: {(action) -> Void in
      //The (withIdentifier: "VC2") is the Storyboard Segue identifier.
      self.dismiss(animated: true, completion: nil)
      //self.performSegue(withIdentifier: "identifierMain", sender: self)
    })
    
    alertController.addAction(ok)
    self.present(alertController, animated: true, completion: nil)
  }
  func alertError(){
    
    let alertController = UIAlertController(title: "", message: "請至信箱查收註冊驗證信。", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: nil))

    self.present(alertController, animated: true, completion: nil)
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
extension ForgotPasswordViewController {
  
  func hideKeyboardWhenTappedAround(){
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
}
