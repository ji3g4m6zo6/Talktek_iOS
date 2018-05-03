//
//  LogInViewController.swift
//  talkTek
//
//  Created by Mac on 2017/12/11.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class LogInViewController: UIViewController {
  
  @IBOutlet weak var backgroundImageview: UIImageView!
  @IBOutlet weak var backButton: UIButton!

  @IBOutlet weak var email_Textfield: UITextField!
  @IBOutlet weak var password_Textfield: UITextField!
  
  
  
  @IBOutlet weak var logInButton: UIButton!
  var emailFromSignUp: String?
  var passwordFromSignUp: String?

  override func viewDidLoad() {
    super.viewDidLoad()
    if let emailFromSignUp = emailFromSignUp, let passwordFromSignUp = passwordFromSignUp {
      email_Textfield.text = emailFromSignUp
      password_Textfield.text = passwordFromSignUp
      LogIn_Button_Tapped(logInButton)
    } else { return }
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func LogIn_Button_Tapped(_ sender: UIButton) {
    
    if let email = email_Textfield.text, let password = password_Textfield.text{
      if email == "" || password == "" { // 欄位為空
        SVProgressHUD.showError(withStatus: "欄位皆須填寫")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
          SVProgressHUD.dismiss()
        })
      } else {
        SVProgressHUD.setStatus("登入中...")
        signInWithEmail(email: email, password: password)
      }
    }
    
  }
  
  @IBAction func Back_Button_Tapped(_ sender: UIButton) {
    _ = navigationController?.popViewController(animated: true)
  }
  
  @IBAction func forgetButtonTapped(_ sender: UIButton) {
    performSegue(withIdentifier: "identifierForget", sender: nil)
  }
  func signInWithEmail(email: String, password: String){
    
    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
      
      if error != nil {
        SVProgressHUD.showError(withStatus: "登入失敗")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
          SVProgressHUD.dismiss()
        })
        print(error?.localizedDescription as Any)
        return
      }else{
        SVProgressHUD.showSuccess(withStatus: "登入成功")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
          SVProgressHUD.dismiss()
        })
        self.performSegue(withIdentifier: "identifierHome", sender: self)

        //self.dismiss(animated: true, completion: nil)
      }
      
    })
  }
  
  @IBAction func BackToLogIn( segue: UIStoryboardSegue ) { }

  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}

