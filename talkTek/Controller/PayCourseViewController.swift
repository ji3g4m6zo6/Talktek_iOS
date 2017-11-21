//
//  PayCourseViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/21.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit

class PayCourseViewController: UIViewController {
  
  
  @IBOutlet weak var tableView: UITableView!
  var categories = ["Action", "Drama", "Science Fiction", "Kids", "Horror"]
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}

extension PayCourseViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return categories.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return categories[section]
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PayCategoryCell
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 190
  }
}
