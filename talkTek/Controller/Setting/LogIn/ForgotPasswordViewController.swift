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
import SVProgressHUD

class ForgotPasswordViewController: UIViewController {
  
  @IBOutlet weak var backButton: UIButton!
  
  @IBOutlet weak var email_TextField: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func backButtonTapped(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
//    if let navigationController = self.navigationController {
//      _ = navigationController.popViewController(animated: true)
//    }
  }
  @IBAction func pass_Button_Tapped(_ sender: UIButton) {
    if let email = email_TextField.text {
      if email == "" {
        SVProgressHUD.showError(withStatus: "欄位皆須填寫")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
          SVProgressHUD.dismiss()
        })
        
      } else {
        forgetPassword(email: email)
      }
    } else {
      SVProgressHUD.showError(withStatus: "欄位皆須填寫")
      DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
        SVProgressHUD.dismiss()
      })
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
    
    let alertController = UIAlertController(title: "成功", message: "請至信箱查收密碼重設信件。", preferredStyle: UIAlertControllerStyle.alert)
    let ok = UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: {(action) -> Void in
      self.performSegue(withIdentifier: "identifierBack", sender: nil)
    })
    
    alertController.addAction(ok)
    self.present(alertController, animated: true, completion: nil)
  }
  func alertError(){
    
    let alertController = UIAlertController(title: "失敗", message: "此信箱尚未註冊", preferredStyle: .alert)
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
