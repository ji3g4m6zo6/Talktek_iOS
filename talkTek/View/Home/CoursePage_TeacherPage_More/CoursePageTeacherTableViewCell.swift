//
//  CoursePageTeacherTableViewCell.swift
//  talkTek
//
//  Created by 李昀 on 2018/3/28.
//  Copyright © 2018年 Talktek Inc. All rights reserved.
//

import UIKit

class CoursePageTeacherTableViewCell: UITableViewCell {

  @IBOutlet weak var teacherImageView: UIImageView!
  
  @IBOutlet weak var teacherNameLabel: UILabel!
  
  @IBOutlet weak var teacherInfoLabel: UILabel!
  
  override func layoutSubviews() {
    teacherImageView.layer.cornerRadius = teacherImageView.bounds.height / 2
    teacherImageView.clipsToBounds = true
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
