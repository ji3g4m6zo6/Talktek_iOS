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
    
    listenToState()
    userFirstLogIn()
    fetchData()
    
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
    
    
    
    
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  var databaseRef: DatabaseReference!
  var homeCourses_Array = [HomeCourses]()
  var hottest = [HomeCourses]()
  var professional = [HomeCourses]()
  var life = [HomeCourses]()
  var others = [HomeCourses]()
  
  func fetchData(){
    // Get the number and root of collectionview
    self.databaseRef.child("AllCourses").observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: Any]{
        
        let homeCourses = HomeCourses()
        
        homeCourses.authorDescription = dictionary["authorDescription"] as? String
        homeCourses.authorImage = dictionary["authorImage"] as? String
        homeCourses.authorName = dictionary["authorName"] as? String
        homeCourses.courseDescription = dictionary["courseDescription"] as? String
        homeCourses.hour = dictionary["hour"] as? String
        homeCourses.overViewImage = dictionary["overViewImage"] as? String
        homeCourses.price = dictionary["price"] as? String
        homeCourses.score = dictionary["score"] as? String
        homeCourses.studentNumber = dictionary["studentNumber"] as? Int
        homeCourses.title = dictionary["title"] as? String
        homeCourses.courseId = dictionary["courseId"] as? String
        homeCourses.teacherID = dictionary["teacherID"] as? String
        homeCourses.onSalesPrice = dictionary["onSalesPrice"] as? String
        homeCourses.tags = dictionary["tags"] as! [String]
        
        
        self.homeCourses_Array.append(homeCourses)
        
        self.tagsSplit(tags: homeCourses.tags, homecourse: homeCourses)
        
      }
    }
  }
  
  func tagsSplit(tags: [String?], homecourse: HomeCourses){
    for (_, value) in tags.enumerated() {
      guard let value = value else { return }
      if value.contains("Hottest"){
        hottest.append(homecourse)
      } else if value.contains("Professional") {
        professional.append(homecourse)
      } else if value.contains("Life") {
        life.append(homecourse)
      } else if value.contains("Others") {
        others.append(homecourse)
      } else {
        return
      }
      
    }
  }
  
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
    let message = "現在購買任何課程皆不用費用。"
    //let image = UIImage(named: "pexels-photo-103290")
    
    // Create the dialog
    let popup = PopupDialog(title: title, message: message)
    //, image: image)
    
    // Create buttons
    let buttonOne = CancelButton(title: "YEAH 太好了！") {
      let userDefaults = UserDefaults.standard
      guard let uid = userDefaults.value(forKey: "uid") else { return }
//      let uidString = String(describing: uid)
 //self.databaseRef.child("Money").child(uidString).child("money").setValue("100000000")

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
        
        //self.databaseRef.child("Money").child((user?.uid)!).child("money").setValue("100000000")
        
        //self.databaseRef.child("BoughtCourses").child((user?.uid)!)
        self.databaseRef.child("Users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
          if let dictionary = snapshot.value as? [String: AnyObject]{
            let username = dictionary["name"] as? String ?? ""
            let userDefaults = UserDefaults.standard
            userDefaults.set(username, forKey: "username")
          }
          
        })
        
        
      } else {
        
        
      }
    }
  }
  
  override func viewControllers (for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Hot") as! HotViewController
    
    let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Pro") as! ProfessionalViewController
    
    let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Life") as! LifeViewController
    
    let child_4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Others") as! OthersViewController
    
    return [child_1, child_2, child_3, child_4]
  }
  
  
  
}
extension HomeParentViewController{
  @IBAction func backFromCourseDetail(_ segue: UIStoryboardSegue) {
  }
  
}
