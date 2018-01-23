//
//  TeacherCoursesTableViewCell.swift
//  talkTek
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseDatabase
import FirebaseAuth


class TeacherCoursesTableViewCell: UITableViewCell {
  
  @IBOutlet weak var tableViewHeight_Constraint: NSLayoutConstraint!
  @IBOutlet weak var tableView: UITableView!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  
  
}

