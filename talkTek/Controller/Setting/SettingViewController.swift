//
//  SettingViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/26.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
  
  var list = ["點數中心","成為講師","意見反饋","個人化設定","優惠碼","關於"]
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    navigationController?.navigationBar.prefersLargeTitles = true

    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
    } else if indexPath.row == 3{
      performSegue(withIdentifier: "personal", sender: self)
    } else if indexPath.row == 4{
      performSegue(withIdentifier: "coupon", sender: self)
    } else if indexPath.row == 5{
      performSegue(withIdentifier: "about", sender: self)
    } else{
      print("WTF happened!!!")
    }
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  
}
