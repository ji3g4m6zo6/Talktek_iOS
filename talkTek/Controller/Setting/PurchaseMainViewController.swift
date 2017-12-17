//
//  PurchaseMainViewController.swift
//  talkTek
//
//  Created by Mac on 2017/12/2.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class PurchaseMainViewController: UIViewController {
  var databaseRef: DatabaseReference!
  var userID = ""
  @IBOutlet weak var points_Label: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    IAPService.shared.getProducts()
    userID = Auth.auth().currentUser!.uid

    fetchData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func testBuy(_ sender: UIButton) {
    IAPService.shared.purchase(product: .testPoints)
  }
  func fetchData(){
    self.databaseRef = Database.database().reference()
    self.databaseRef.child("Money/\(self.userID)").observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: AnyObject]{
        print("dictionary is \(dictionary)")
        
        let money = dictionary["money"] as? String ?? ""
        
        self.points_Label.text = ("\(money)點")
        
        
        
      }
      
    }
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
