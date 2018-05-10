//
//  SignUpViewController.swift
//  talkTek
//
//  Created by Mac on 2017/12/11.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class SignUpViewController: UIViewController {
  
  
  @IBOutlet weak var backButton: UIButton!
  
  @IBOutlet weak var name_TextField: UITextField!
  @IBOutlet weak var email_TextField: UITextField!
  @IBOutlet weak var password_TextField: UITextField!
  

  var databaseRef: DatabaseReference!
  var userIsAnonymous: Bool?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    backToViewcontroller = UserDefaults.standard.string(forKey: "previousVC") ?? "tab"
    userIsAnonymous = Auth.auth().currentUser?.isAnonymous
    databaseRef = Database.database().reference()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func SignUp_Button_Tapped(_ sender: UIButton) {
    if let email = email_TextField.text, let password = password_TextField.text, let name = name_TextField.text{
      if email == "" || password == "" || name == "" { // 欄位為空
        SVProgressHUD.showError(withStatus: "欄位皆須填寫")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
          SVProgressHUD.dismiss()
        })
      } else { // 欄位皆填寫
        if isValid(email){ // 驗證信箱格式
          if let userIsAnonymous = userIsAnonymous {
            if userIsAnonymous {
              let credential = EmailAuthProvider.credential(withEmail: email, password: password)
              anonymousToPermanent(credential: credential)
              return
            }
          }
          // 信箱格式正確
          registerByEmail(name: name, email: email, password: password)
        } else {
          // 信箱格式錯誤
          SVProgressHUD.showError(withStatus: "信箱格式錯誤")
          DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            SVProgressHUD.dismiss()
          })
        }
      }
      
    }
  }
  
  @IBAction func Back_Button_Tapped(_ sender: UIButton) {
    _ = navigationController?.popViewController(animated: true)
  }
  
  
  func registerByEmail(name: String, email: String, password: String){
    
    
    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
      
      if error != nil{
        SVProgressHUD.showError(withStatus: "註冊失敗")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
          SVProgressHUD.dismiss()
        })
        print(error?.localizedDescription as Any)
        return
      }
      
      guard let uid = user?.uid else { return }
      
      let values = ["name": name as AnyObject, "account": email as AnyObject, "profileImageUrl": "" as AnyObject, "birthday": "" as AnyObject, "gender": "" as AnyObject] as [String: AnyObject]
      
      
      self.databaseRef.child("Users").child(uid).setValue(values, withCompletionBlock: { (err, ref) in
        
        if err != nil{
          print(err!)
          return
        }
        
        SVProgressHUD.showSuccess(withStatus: "註冊成功")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
          SVProgressHUD.dismiss()
          self.performSegue(withIdentifier: "identifierLogIn", sender: nil)
        })
        
      })
      
    })
    
  }
  
  func alert(){
    
    let alertController = UIAlertController(title: "恭喜您註冊成功！", message: "請至信箱查收註冊驗證信。", preferredStyle: UIAlertControllerStyle.alert)
    let ok = UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: {(action) -> Void in
      self.dismiss(animated: true, completion: nil)
    })
    
    alertController.addAction(ok)
    self.present(alertController, animated: true, completion: nil)
  }
  
  func anonymousToPermanent(credential: AuthCredential){
    let user = Auth.auth().currentUser
    user?.link(with: credential, completion: { (user, error) in
      if error != nil {
        SVProgressHUD.showError(withStatus: "登入失敗")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
          SVProgressHUD.dismiss()
        })
        return
      }
      
      if self.backToViewcontroller == "CoursePage" {
        
      } else {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainTabViewController")
        self.present(controller, animated: true, completion: nil)
      }

      
    })
  }
  var backToViewcontroller = ""
  func isValid(_ email: String) -> Bool {
    let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
    let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
    return emailTest.evaluate(with: email)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "identifierLogIn" {
      let destination = segue.destination as! LogInViewController
      destination.emailFromSignUp = email_TextField.text
      destination.passwordFromSignUp = password_TextField.text
    }
  }
  
}

