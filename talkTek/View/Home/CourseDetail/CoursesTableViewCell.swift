//
//  CoursesTableViewCell.swift
//  talkTek
//
//  Created by Mac on 2017/11/23.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit

class CoursesTableViewCell: UITableViewCell {
  
  @IBOutlet weak var course_TableView: UITableView!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}
extension CoursesTableViewCell: UITableViewDataSource, UITableViewDelegate{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "audioFiles", for: indexPath) as! AudioFilesTableViewCell
    cell.topic_Label.text = ""
    cell.title_Label.text = ""
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 57
  }
  
//  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "audioSection") as! AudioSectionTableViewCell
//    cell.setUpCell(title: categories[section])
//    return cell
//  }
//  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    return 49
//  }
}
