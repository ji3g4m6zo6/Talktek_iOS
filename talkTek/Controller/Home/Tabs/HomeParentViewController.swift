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
import SnapKit
import ARNTransitionAnimator

class HomeParentViewController: ButtonBarPagerTabStripViewController {

  
    private var animator : ARNTransitionAnimator?
    fileprivate var playerViewController : PlayerViewController!
    var miniPlayerView: UIView!
  let tealish = UIColor.tealish()
  override func viewDidLoad() {
    
    settings.style.buttonBarBackgroundColor = .white
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.selectedBarBackgroundColor = UIColor.tealish()
    settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
    settings.style.selectedBarHeight = 1.0
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
    
    
    super.viewDidLoad()
    
//    listenToState()
    
//    passView.snp.makeConstraints { (make) in
//      make.width.equalTo(self.view)
//      make.height.equalTo(54)
//      make.bottom.equalTo(self.view).inset(15)
//    }
    
    print(UserDefaults.standard.string(forKey: "uid") ?? "wtfffff???")
    prepareMiniPlayer()
    
  }
    
    func prepareMiniPlayer() {
        let window = UIApplication.shared.keyWindow!
        miniPlayerView = PassView(frame: CGRect(x: 0, y: window.frame.height - 100, width: window.frame.width, height: 50))
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.miniPlayerTapAction))
        miniPlayerView.addGestureRecognizer(gesture)
        miniPlayerView.tag = 5566
        self.miniPlayerView.isHidden = true
        window.addSubview(miniPlayerView)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController
        self.playerViewController.modalPresentationStyle = .overCurrentContext
        self.setupAnimator()
        NotificationCenter.default.addObserver(forName:Notification.Name(rawValue:"PlayMusicNotification"),
                                               object:nil, queue:nil) {
                                                [weak self] notification in
                                                self?.miniPlayerTapAction(sender: nil)
        }
    }
    
    func setupAnimator() {
        let animation = MusicPlayerTransitionAnimation(modalVC: playerViewController, rootNavigationViewController: self.navigationController!)
        animation.completion = { [weak self] isPresenting in
            if isPresenting {
                guard let _self = self else { return }
                let modalGestureHandler = TransitionGestureHandler(targetView: _self.playerViewController.view, direction: .bottom)
                modalGestureHandler.panCompletionThreshold = 15.0
                _self.animator?.registerInteractiveTransitioning(.dismiss, gestureHandler: modalGestureHandler)
            } else {
                self?.setupAnimator()
            }
        }
        
        let gestureHandler = TransitionGestureHandler(targetView: miniPlayerView, direction: .top)
        gestureHandler.panCompletionThreshold = 15.0
        self.animator = ARNTransitionAnimator(duration: 0.5, animation: animation)
        self.animator?.registerInteractiveTransitioning(.present, gestureHandler: gestureHandler)
        self.playerViewController.transitioningDelegate = self.animator
    }
    
    @objc func miniPlayerTapAction(sender : UITapGestureRecognizer?) {
        self.present(self.playerViewController, animated: true, completion: nil)
        self.miniPlayerView.isHidden = false
    }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
  var databaseRef: DatabaseReference!
  
  
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
