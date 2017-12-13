//
//  SettingViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/26.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit


class SettingViewController: UIViewController {
  
  @IBOutlet weak var profile_ImageView: UIImageView!
  
  @IBOutlet weak var name_Label: UILabel!
  
  var databaseRef: DatabaseReference!
  var userID = ""
  var list = ["點數中心", "成為講師","意見反饋", "優惠碼", "關於"]
  @IBOutlet weak var tableView: UITableView!
  
  
  @IBOutlet weak var LogIn_LogOut: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
   
    userID = Auth.auth().currentUser!.uid

    fetchData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func fetchData(){
    self.databaseRef = Database.database().reference()
    self.databaseRef.child("Users/\(self.userID)").observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: AnyObject]{
        print("dictionary is \(dictionary)")
        let user = User()
        user.name = dictionary["name"] as? String ?? ""
        user.account = dictionary["account"] as? String ?? ""
        
        self.name_Label.text = user.name
        
        
        
      }
      
    }

  }

  @IBAction func LogIn_LogOut(_ sender: UIButton) {
    FBSDKLoginManager().logOut()
    do{
      try Auth.auth().signOut()
      self.databaseRef = Database.database().reference()
      self.databaseRef.child("Users").child(self.userID).child("Online-Status").setValue("Off")
      
      let LogInVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainLogInViewController") as! MainLogInViewController
      self.present(LogInVC, animated: true, completion: nil)
    }catch let logOutError {
      
      print(logOutError)
      
    }
    
    

  }
  
  @IBAction func cameraOrImage(_ sender: UIButton) {
    
  }
  
  
  
}
extension SettingViewController: UITableViewDelegate, UITableViewDataSource
{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingMainTableViewCell
    cell.settingTitle_Label.text = list[indexPath.row]
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0{
      performSegue(withIdentifier: "points", sender: self)
    } else if indexPath.row == 1{
      performSegue(withIdentifier: "lecturer", sender: self)
    } else if indexPath.row == 2{
      performSegue(withIdentifier: "suggestion", sender: self)
    } //else if indexPath.row == 3{
      //performSegue(withIdentifier: "personal", sender: self)
    //}
       else if indexPath.row == 3{
      performSegue(withIdentifier: "coupon", sender: self)
    } else if indexPath.row == 4{
      performSegue(withIdentifier: "about", sender: self)
    } else{
      print("WTF happened!!!")
    }
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  
}
