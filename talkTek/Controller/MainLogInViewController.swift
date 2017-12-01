//
//  LogInViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/30.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase

class MainLogInViewController: UIViewController, GIDSignInDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    // Initialize sign-in
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    GIDSignIn.sharedInstance().delegate = self
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func listenToState(){
    Auth.auth().addStateDidChangeListener() { (auth, user) in
      if user != nil{
        self.performSegue(withIdentifier: "HomeTabSegue", sender: self)
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
      }
      else
      {
        self.fbLogin.readPermissions = ["public_profile", "email"]
        self.fbLogin.delegate = self
        self.fbLogin.isHidden = false
      }
    }
  }
  
  @IBAction func googleLogin(sender: UIButton){
    
  }
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
    // ...
    if let error = error {
      // ...
      print(error.localizedDescription)
      return
    }
    
    guard let authentication = user.authentication else { return }
    let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
    Auth.auth().signIn(with: credential){(user, error) in
      print("Sign In to Firebase")
      
    }
    // ...
  }
  
  @IBAction func facebookLogin(sender: UIButton) {
    let fbLoginManager = FBSDKLoginManager()
    fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
      if let error = error {
        print("Failed to login: \(error.localizedDescription)")
        return
      }
      
      guard let accessToken = FBSDKAccessToken.current() else {
        print("Failed to get access token")
        return
      }
      
      let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
      
      // Perform login by calling Firebase APIs
      Auth.auth().signIn(with: credential, completion: { (user, error) in
        if let error = error {
          print("Login error: \(error.localizedDescription)")
          let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
          let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
          alertController.addAction(okayAction)
          self.present(alertController, animated: true, completion: nil)
          
          return
        }
        
        // Present the main view
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
          UIApplication.shared.keyWindow?.rootViewController = viewController
          self.dismiss(animated: true, completion: nil)
        }
        
      })
      
    }
  }
  
  
  
}
