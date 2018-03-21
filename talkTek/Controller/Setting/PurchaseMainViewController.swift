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
import StoreKit
import SwiftyStoreKit


class PurchaseMainViewController: UIViewController {
  var databaseRef: DatabaseReference!
  var userID = ""
  var moneyNumber = 0
  
  @IBOutlet weak var moneyIcon: UIImageView!
  @IBOutlet weak var points_Label: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    moneyIcon.tintColor = UIColor.moneyYellow()
    //,"versionA02","versionA03"
    SwiftyStoreKit.retrieveProductsInfo(["versionA01"]) { result in
      if let product = result.retrievedProducts.first {
        let priceString = product.localizedPrice!
        print("Product: \(product.localizedDescription), price: \(priceString)")
      }
      else if let invalidProductId = result.invalidProductIDs.first {
        print("Invalid product identifier: \(invalidProductId)")
      }
      else {
        print("Error: \(result.error ?? "" as! Error)")
      }
    }
    SwiftyStoreKit.retrieveProductsInfo(["versionA02"]) { result in
      if let product = result.retrievedProducts.first {
        let priceString = product.localizedPrice!
        print("Product: \(product.localizedDescription), price: \(priceString)")
      }
      else if let invalidProductId = result.invalidProductIDs.first {
        print("Invalid product identifier: \(invalidProductId)")
      }
      else {
        print("Error: \(result.error ?? "" as! Error)")
      }
    }
    SwiftyStoreKit.retrieveProductsInfo(["versionA03"]) { result in
      if let product = result.retrievedProducts.first {
        let priceString = product.localizedPrice!
        print("Product: \(product.localizedDescription), price: \(priceString)")
      }
      else if let invalidProductId = result.invalidProductIDs.first {
        print("Invalid product identifier: \(invalidProductId)")
      }
      else {
        print("Error: \(result.error ?? "" as! Error)")
      }
    }
    let userDefaults = UserDefaults.standard
    userID = userDefaults.string(forKey: "uid") ?? ""

    
    fetchData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func twofiftyButtonTapped(_ sender: UIButton) {
    SwiftyStoreKit.purchaseProduct("versionA01", quantity: 1, atomically: true) { result in
      switch result {
      case .success(let purchase):
        print("Purchase Success: \(purchase.productId)")
        self.addPoints(points: 300)
      case .error(let error):
        switch error.code {
        case .unknown: print("Unknown error. Please contact support")
        case .clientInvalid: print("Not allowed to make the payment")
        case .paymentCancelled: break
        case .paymentInvalid: print("The purchase identifier was invalid")
        case .paymentNotAllowed: print("The device is not allowed to make the payment")
        case .storeProductNotAvailable: print("The product is not available in the current storefront")
        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
        }
      }
    }
  }
  
  @IBAction func fivehundredButtonTapped(_ sender: UIButton) {
    SwiftyStoreKit.purchaseProduct("versionA02", quantity: 1, atomically: true) { result in
      switch result {
      case .success(let purchase):
        print("Purchase Success: \(purchase.productId)")
        self.addPoints(points: 1000)

      case .error(let error):
        switch error.code {
        case .unknown: print("Unknown error. Please contact support")
        case .clientInvalid: print("Not allowed to make the payment")
        case .paymentCancelled: break
        case .paymentInvalid: print("The purchase identifier was invalid")
        case .paymentNotAllowed: print("The device is not allowed to make the payment")
        case .storeProductNotAvailable: print("The product is not available in the current storefront")
        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
        }
      }
    }
    
  }
  
  @IBAction func thousandButtonTapped(_ sender: UIButton) {
    SwiftyStoreKit.purchaseProduct("versionA03", quantity: 1, atomically: true) { result in
      switch result {
      case .success(let purchase):
        print("Purchase Success: \(purchase.productId)")
        self.addPoints(points: 2100)

      case .error(let error):
        switch error.code {
        case .unknown: print("Unknown error. Please contact support")
        case .clientInvalid: print("Not allowed to make the payment")
        case .paymentCancelled: break
        case .paymentInvalid: print("The purchase identifier was invalid")
        case .paymentNotAllowed: print("The device is not allowed to make the payment")
        case .storeProductNotAvailable: print("The product is not available in the current storefront")
        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
        }
      }
    }
    
  }
  
  func fetchData(){
    self.databaseRef = Database.database().reference()
    self.databaseRef.child("Money/\(self.userID)").observe(.value) { (snapshot) in
      if let dictionary = snapshot.value as? [String: String]{
        print("dictionary is \(dictionary)")
        
        let money = dictionary["money"] ?? ""
        
        self.points_Label.text = ("\(money)點")
        
        self.moneyNumber = Int(money)! //danger
        
      }
      
    }
  }
  func addPoints(points: Int){
    self.databaseRef = Database.database().reference()
    let addition = points + moneyNumber
    let additionString = String(addition) // int to string
    self.databaseRef.child("Money/\(self.userID)/money").setValue(additionString)
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
