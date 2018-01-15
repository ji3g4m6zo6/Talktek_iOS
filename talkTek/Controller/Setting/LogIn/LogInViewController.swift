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

class LogInViewController: UIViewController {
  
  @IBOutlet weak var email_Textfield: UITextField!
  @IBOutlet weak var password_Textfield: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func LogIn_Button_Tapped(_ sender: UIButton) {
    if let email = email_Textfield.text, let password = password_Textfield.text{
      
        signInFirebaseWithEmail(email: email, password: password)
      
    }
    
  }
  
  @IBAction func Back_Button_Tapped(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func signInFirebaseWithEmail(email: String, password: String){
    
    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
      
      if error != nil {
        
        print(error?.localizedDescription as Any)
        return
      }else{
        self.performSegue(withIdentifier: "identifierHome", sender: self)

        //self.dismiss(animated: true, completion: nil)
      }
      
    })
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

