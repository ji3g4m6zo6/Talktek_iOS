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
import FirebaseAuthUI
import FirebaseFacebookAuthUI
import SnapKit
import SVProgressHUD

class MainLogInViewController: UIViewController, FUIAuthDelegate, FBSDKLoginButtonDelegate {
  
  var uid: String?
  var userIsAnonymous: Bool?
  
  func authUI(_ authUI: FUIAuth, didSignInWith user: FirebaseAuth.User?, error: Error?) {
    if error != nil {
      //Problem signing in
      logIn()
    }else {
      //User is in! Here is where we code after signing in
      
    }
  }

//  func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
//    if error != nil {
//      //Problem signing in
//      logIn()
//    }else {
//      //User is in! Here is where we code after signing in
//
//    }
//  }
  
 //, GIDSignInUIDelegate, GIDSignInDelegate
  let facebook_Button = FacebookButton()
  
  @IBOutlet weak var facebook_View: UIView!
  var databaseRef: DatabaseReference!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // facebook UI
    facebook_View.addSubview(facebook_Button)
    facebook_Button.snp.makeConstraints { (make) in
      make.top.left.right.bottom.equalTo(facebook_View)
    }
    
    
    uid = UserDefaults.standard.string(forKey: "uid")
    
    
    userIsAnonymous = Auth.auth().currentUser?.isAnonymous
    if let userIsAnonymous = userIsAnonymous {//if there's current user
      if userIsAnonymous {
        return
      } else {
        checkLoggedIn()
      }
    } else {//there's no current user
      checkLoggedIn()
      return
    }
    
    //checkLoggedIn()

    // Initialize sign-in
   /* GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    GIDSignIn.sharedInstance().delegate = self
    */
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func checkLoggedIn(){
    Auth.auth().addStateDidChangeListener() { (auth, user) in
      if user != nil{
        // user is logged in
        
        self.facebook_Button.readPermissions = ["public_profile", "email"]
        print("permission \(self.facebook_Button.readPermissions)")
        
        print("Freakin user id is \(user?.uid ?? "") ")
        self.self.databaseRef = Database.database().reference()
        self.self.databaseRef.child("Users").child((user?.uid)!).child("Online-Status").setValue("On")
        self.performSegue(withIdentifier: "identifierTab", sender: self)

      } else {
        // No user is signed in
        //self.logIn()
        
        self.facebook_Button.readPermissions = ["public_profile", "email"]
        print("permission \(self.facebook_Button.readPermissions)")
        self.facebook_Button.delegate = self
        self.facebook_Button.isHidden = false
      }
    }
  }
  
  func logIn(){
    let authUI = FUIAuth.defaultAuthUI()
    let facebookProvider = FUIFacebookAuth()
    authUI?.delegate = self
    authUI?.providers = [facebookProvider]
    
    self.performSegue(withIdentifier: "identifierTab", sender: self)
    
  }
  
  /*
  // Google
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
    // ...
    if let error = error {
      print(error.localizedDescription)
      return
    }
    
    guard let authentication = user.authentication else { return }
    let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
    Auth.auth().signIn(with: credential){(user, error) in
      print("Google Sign In to Firebase")
      self.databaseRef = Database.database().reference()
      self.databaseRef.child("Users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
        let snapshot = snapshot.value as? NSDictionary
        if(snapshot == nil)
        {
          self.databaseRef.child("Users").child(user!.uid).setValue(["name" : user?.displayName, "account": user?.email])
        }
      })
      self.dismiss(animated: true, completion: nil  )

    }
    // ...
  }
  func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    if let error = error {
      print(error.localizedDescription)
      return
    }
    
    try! Auth.auth().signOut()
    
  }
  */
  
  // Facebook
  func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    print("user has log in fb")
    
    self.facebook_Button.isHidden = true
    
    Analytics.logEvent("facebook_login", parameters: nil)
    
    
    if (error != nil)
    {
      print(error.localizedDescription)
      self.facebook_Button.isHidden = false
    }
    else if(result.isCancelled)
    {
      print("facebook cancelled is pressed")
      self.facebook_Button.isHidden = false
    }
    else
    {
      let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
      
      if let userIsAnonymous = userIsAnonymous {
        if userIsAnonymous {
          self.anonymousToPermanent(credential: credential)
          return
        }
      }
      
      Auth.auth().signIn(with: credential) { (user, error) in
        print("Facebook user has log into firebase")
        self.databaseRef = Database.database().reference()
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(user?.uid, forKey: "uid")
        
        self.getFacebookUserInfo()
        
        self.databaseRef.child("Users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
          let snapshot = snapshot.value as? NSDictionary
          if(snapshot == nil)
          {
           
            self.databaseRef.child("Users").child(user!.uid).setValue(["name" : user?.displayName, "account": user?.email, "profileImageUrl": "", "birthday": "", "gender": ""])
            
            
          }
        })
        self.performSegue(withIdentifier: "identifierTab", sender: self)

      }
    }

  }
  
  var dict : [String : AnyObject]?

  func getFacebookUserInfo() {

    if((FBSDKAccessToken.current()) != nil){
      FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(normal), email"]).start(completionHandler: { (connection, result, error) -> Void in
        if (error == nil){
          self.dict = result as? [String : AnyObject]
          print(result!)
          print(self.dict)
        }
      })
    }
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
      
      self.performSegue(withIdentifier: "identifierTab", sender: self)

      
    })
  }
  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    print("user has log out")
  }
  
  @IBAction func LogIn_Button_Tapped(_ sender: UIButton) {
    performSegue(withIdentifier: "identifierLogIn", sender: self)
  }
  @IBAction func SignUp_Button_Tapped(_ sender: UIButton) {
    performSegue(withIdentifier: "identifierSignUp", sender: self)
  }
  
  @IBAction func Later_Button_Tapped(_ sender: UIButton) {
    if let userIsAnonymous = userIsAnonymous {
      if userIsAnonymous {
        checkLoggedIn()
        return
      }
    }
    Auth.auth().signInAnonymously { (user, error) in
      if error != nil {
        print(error!)
        return
      }
      
      UserDefaults.standard.set(user?.uid, forKey: "uid")
      self.performSegue(withIdentifier: "identifierTab", sender: nil)
      
    }

  }
  
}
extension MainLogInViewController{
  @IBAction func backFromCourseDetail(_ segue: UIStoryboardSegue) {
  }
  
}


class FacebookButton: FBSDKLoginButton {
  let standardButtonHeight: CGFloat = 50.0
  override func updateConstraints() {
    // deactivate height constraints added by the facebook sdk (we'll force our own instrinsic height)
    for contraint in constraints {
      if contraint.firstAttribute == .height, contraint.constant < standardButtonHeight {
        // deactivate this constraint
        contraint.isActive = false
      }
    }
    super.updateConstraints()
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIViewNoIntrinsicMetric, height: standardButtonHeight)
  }
  
  override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
    let logoSize: CGFloat = 24.0
    let centerY = contentRect.midY
    let y: CGFloat = centerY - (logoSize / 2.0)
    return CGRect(x: y, y: y, width: logoSize, height: logoSize)
  }
  
  override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
    if isHidden || bounds.isEmpty {
      return .zero
    }
    
    let imageRect = self.imageRect(forContentRect: contentRect)
    let titleX = imageRect.maxX
    let titleRect = CGRect(x: titleX, y: 0, width: contentRect.width - titleX - titleX, height: contentRect.height)
    return titleRect
  }
  
}

