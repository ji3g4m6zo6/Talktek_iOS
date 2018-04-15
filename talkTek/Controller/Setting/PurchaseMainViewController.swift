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
import SVProgressHUD

class PurchaseMainViewController: UIViewController {
  
  // MARK: - tableview
  @IBOutlet weak var tableView: UITableView!

  // MARK: - Outlets
  @IBOutlet weak var moneyIcon: UIImageView!
  @IBOutlet weak var points_Label: UILabel!

  // MARK: - Firebase
  var databaseRef: DatabaseReference!
  var uid: String?
  
  // MARK: - CashFlow
  var cashFlow = CashFlow()
  
  // MARK: - Product Arrays
  let productIDArray = ["com.talktek.Talk.300NT", "  com.talktek.Talk.990NT", "com.talktek.Talk.1990NT"]
  let imageArray = ["300點","1000點","2100點"]
  let pointArray = [300, 1000, 2100]
  let cashArray = [300, 990, 1990]
  

  // MARK: - viewDidLoad, didReceiveMemoryWarning
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // uid from userdefaults, database init
    databaseRef = Database.database().reference()
    uid = UserDefaults.standard.string(forKey: "uid")

    // Tableview
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
    
    // UI icon
    moneyIcon.tintColor = UIColor.moneyYellow()

    // fetch Product From Itunes Connect
    fetchProductFromItunes()
    
    // fetch money data from firebase
    fetchData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
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

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PurchaseMainViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PurchaseMainTableViewCell
    cell.imagePurchase.image = UIImage(named: imageArray[indexPath.row])
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 127
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    purchaseAction(index: indexPath.row)
  }
}

// MARK: - API call
extension PurchaseMainViewController {
  // MARK: - Firebase
  // fetch data from firebase check if user exist in CashFlow
  func fetchData(){
    guard let uid = uid else { return }
    databaseRef.child("CashFlow").observe(.value) { (value) in
      if value.hasChild(uid) {
        self.fetchCash()
      } else {
        self.cashFlow.CashValue = 0
        self.cashFlow.RewardPoints = 0
      }
    }
  }
  // fetch user's money
  func fetchCash(){
    guard let uid = uid else { return }
    databaseRef.child("CashFlow/\(uid)/Total").observe(.value, with: { (snapshot) in
      if let dictionary = snapshot.value as? [String: Int] {
        if let cashValue = dictionary["CashValue"], let rewardPoints = dictionary["RewardPoints"]{
          self.cashFlow.CashValue = cashValue
          self.cashFlow.RewardPoints = rewardPoints
          self.points_Label.text = "\(rewardPoints)點"
        }
      }
    })
  }
  
  // MARK: - In App Purchase
  // fetch product id
  func fetchProductFromItunes(){
    for i in 0...productIDArray.count - 1 {
      SwiftyStoreKit.retrieveProductsInfo([productIDArray[i]]) { result in
        if let product = result.retrievedProducts.first {
          let priceString = product.localizedPrice!
          print("Product: \(product.localizedDescription), price: \(priceString)")
        }
        else if let invalidProductId = result.invalidProductIDs.first {
          print("Invalid product identifier: \(invalidProductId)")
        }
        else {
          print("Error: \(String(describing: result.error))")
        }
      }
    }
  }
  
  // purchase button action
  func purchaseAction(index: Int){
    SVProgressHUD.show(withStatus: "載入中...")
    SwiftyStoreKit.purchaseProduct(productIDArray[index], quantity: 1, atomically: true) { result in
      switch result {
      case .success(let purchase):
        print("Purchase Success: \(purchase.productId)")
        SVProgressHUD.showSuccess(withStatus: "成功購買")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
          SVProgressHUD.dismiss()
        })
        
        self.addCashToHistory(index: index)
        self.addCashValue(addCashValue: self.cashArray[index])
        self.addPointsToHistory(index: index)
        self.addRewardPoints(addRewardPoints: self.pointArray[index])
        
      case .error(let error):
        SVProgressHUD.showError(withStatus: "購買失敗")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
          SVProgressHUD.dismiss()
        })
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
  
  // MARK: - Add History and Update Value
  // add cash to history
  func addCashToHistory(index: Int){
    guard let uid = uid else { return }
    let currentTime = getCurrentTime()
    
    let parameter = ["Time": currentTime, "CashType": "IAP入帳", "Value": cashArray[index], "Unit": "台幣"] as [String : Any]
    databaseRef.child("CashFlow/\(uid)/History").childByAutoId().setValue(parameter)
  }
  // add point to history
  func addPointsToHistory(index: Int){
    guard let uid = uid else { return }
    let currentTime = getCurrentTime()
    
    let parameter = ["Time": currentTime, "CashType": "點數轉換", "Value": pointArray[index], "Unit": "點數"] as [String : Any]
    databaseRef.child("CashFlow/\(uid)/History").childByAutoId().setValue(parameter)
  }
  // update cash
  func addCashValue(addCashValue: Int){
    guard let uid = uid, let cashValue = cashFlow.CashValue else { return }
    databaseRef.child("CashFlow/\(uid)/Total").child("CashValue").setValue(cashValue + addCashValue)
  }
  // update point
  func addRewardPoints(addRewardPoints: Int){
    guard let uid = uid, let rewardPoints = cashFlow.RewardPoints else { return }
    databaseRef.child("CashFlow/\(uid)/Total").child("RewardPoints").setValue(rewardPoints + addRewardPoints)
  }
  // get current time for history usage
  func getCurrentTime() -> String{
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return formatter.string(from: date)
  }
}
