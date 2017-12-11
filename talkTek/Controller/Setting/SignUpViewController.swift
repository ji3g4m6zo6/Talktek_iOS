//
//  SignUpViewController.swift
//  talkTek
//
//  Created by Mac on 2017/12/11.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
  
  @IBOutlet weak var name_TextField: UITextField!
  @IBOutlet weak var email_TextField: UITextField!
  @IBOutlet weak var password_TextField: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func SignUp_Button_Tapped(_ sender: UIButton) {
    if let email = email_TextField.text, let password = password_TextField.text, let name = name_TextField.text{
      
      registerFirebaseByEmail(name: name, email: email, password: password)
    }
  }
  
  @IBAction func Back_Button_Tapped(_ sender: UIButton) {
  }
  
  
  func registerFirebaseByEmail(name: String, email: String, password: String){
    
    
    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
      
      if error != nil{
        print(error?.localizedDescription as Any)
        return
      }
      
      guard let uid = user?.uid else {
        return
      }
      
      let values = ["name": name as AnyObject, "email": email as AnyObject, "profileImageUrl": "" as AnyObject] as [String: AnyObject]
      
      let ref = Database.database().reference()
      
      
      ref.child("Users").child(uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
        if err != nil{
          print(err!)
          return
        }
        
        user?.sendEmailVerification() { error in
          if let error = error {
            print(error)
          } else {
            //
            self.alert()
          }
        }
        
      })
      
    })
    
  }
  
  func alert(){
    
    let alertController = UIAlertController(title: "恭喜您註冊成功！", message: "請至信箱查收註冊驗證信。", preferredStyle: UIAlertControllerStyle.alert)
    let ok = UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: {(action) -> Void in
      //The (withIdentifier: "VC2") is the Storyboard Segue identifier.
      self.performSegue(withIdentifier: "identifierMain", sender: self)
    })
    
    alertController.addAction(ok)
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
