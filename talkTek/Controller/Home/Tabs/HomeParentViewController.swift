//
//  HomeParentViewController.swift
//  talkTek
//
//  Created by Mac on 2017/12/9.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase
import XLPagerTabStrip
import PopupDialog

class HomeParentViewController: ButtonBarPagerTabStripViewController {
  
  let tealish = UIColor.tealish()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //listenToState()
    userFirstLogIn()
    
    settings.style.buttonBarBackgroundColor = .white
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.selectedBarBackgroundColor = UIColor.tealish()
    settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
    settings.style.selectedBarHeight = CGFloat(1.0)
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.buttonBarItemTitleColor = UIColor.tealish()
    settings.style.buttonBarItemsShouldFillAvailiableWidth = true
    settings.style.buttonBarLeftContentInset = 0
    settings.style.buttonBarRightContentInset = 0
    changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
      guard changeCurrentIndex == true else { return }
      oldCell?.label.textColor = UIColor.lightGray
      newCell?.label.textColor = self?.tealish
    }
    /*
     let LogInVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainLogInViewController") as! MainLogInViewController
     self.present(LogInVC, animated: true, completion: nil)*/
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  var databaseRef: DatabaseReference!
  var getCoupon = ""
  func userFirstLogIn(){
    let userDefaults = UserDefaults.standard
    self.getCoupon = userDefaults.string(forKey: "getCoupon") ?? "0"
    
    if self.getCoupon == "0"{
      self.alert()
      userDefaults.set("1", forKey: "getCoupon")
    }
      
      


  }
  func alert(){
    let title = "恭喜您獲得早鳥票免費體驗優惠券！"
    let message = "您已獲得無限點數，現在購買任何課程皆不用費用。"
    //let image = UIImage(named: "pexels-photo-103290")
    
    // Create the dialog
    let popup = PopupDialog(title: title, message: message)
    //, image: image)
    
    // Create buttons
    let buttonOne = CancelButton(title: "YEAH 太好了！") {
      print("You confirmed.")
    }
    
    // This button will not the dismiss the dialog
    //      let buttonTwo = DefaultButton(title: "ADMIRE CAR", dismissOnTap: false) {
    //        print("What a beauty!")
    //      }
    //
    //      let buttonThree = DefaultButton(title: "BUY CAR", height: 60) {
    //        print("Ah, maybe next time :)")
    //      }
    
    // Add buttons to dialog
    // Alternatively, you can use popup.addButton(buttonOne)
    // to add a single button
    popup.addButtons([buttonOne])
    
    //popup.addButtons([buttonOne, buttonTwo, buttonThree])
    
    // Present dialog
    self.present(popup, animated: true, completion: nil)
  }
  func listenToState(){
    Auth.auth().addStateDidChangeListener() { (auth, user) in
      if user != nil{
        //alert()
        let userDefaults = UserDefaults.standard
        userDefaults.set(user?.uid, forKey: "uid")
        print("Freakin user id is \(user?.uid ?? "") ")
        self.self.databaseRef = Database.database().reference()
        
        self.self.databaseRef.child("Users").child((user?.uid)!).child("Online-Status").setValue("On")
      } else {
        //alert()
//        let LogInVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainLogInViewController") as! MainLogInViewController
//        self.present(LogInVC, animated: true, completion: nil)
//      }
      
    }
  }
  
    
  }
  
  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Hot")
    let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Pro")
    let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Life")
    let child_4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Others")
    return [child_1, child_2, child_3, child_4]
  }
  
  
  
}
extension HomeParentViewController{
  @IBAction func backFromCourseDetail(_ segue: UIStoryboardSegue) {
  }
  
}
