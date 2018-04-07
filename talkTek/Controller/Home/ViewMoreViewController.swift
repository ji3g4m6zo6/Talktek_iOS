//
//  ViewMoreViewController.swift
//  talkTek
//
//  Created by Mac on 2018/1/29.
//  Copyright © 2018年 Talktek Inc. All rights reserved.
//

import UIKit

class ViewMoreViewController: UIViewController {
  
  // MARK: - tableview
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - API outlets
  var homeCourses_Array = [HomeCourses]()
  var homeCouresToPass = HomeCourses()

  // MARK: - viewDidLoad, didReceiveMemoryWarning
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Tableview
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "identifierDetail"{
      let destinationViewController = segue.destination as! CoursePageViewController
      destinationViewController.detailToGet = self.homeCouresToPass
    }
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewMoreViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return homeCourses_Array.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoreTableViewCell
    
    cell.authorImageView.layer.borderColor = UIColor.white.cgColor
    if let iconUrl = homeCourses_Array[indexPath.row].overViewImage{
      let url = URL(string: iconUrl)
      cell.overviewImageView.kf.setImage(with: url)
    }
    if let iconUrl = homeCourses_Array[indexPath.row].authorImage{
      let url = URL(string: iconUrl)
      cell.authorImageView.kf.setImage(with: url)
    }
    cell.authorNameLabel.text = homeCourses_Array[indexPath.row].authorName
    cell.titleLabel.text = homeCourses_Array[indexPath.row].courseTitle
    
    ////////// waiting for price on sale UI
    if let priceOrigin = homeCourses_Array[indexPath.row].priceOrigin{
      cell.money_Label.text = "\(priceOrigin)"
    }
    
    
    if let studentNumber = homeCourses_Array[indexPath.row].studentNumber {
      cell.studentNumberLabel.text = "\(studentNumber)"
    }
    
    if let scorePeople = homeCourses_Array[indexPath.row].scorePeople {
      cell.commentNumberLabel.text = "\(scorePeople)"
    }
    
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    homeCouresToPass = homeCourses_Array[indexPath.row]
    performSegue(withIdentifier: "identifierDetail", sender: self)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 129
  }
}
