//
//  TeacherMainTableViewCell.swift
//  talkTek
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit

class TeacherMainTableViewCell: UITableViewCell {
  
  @IBOutlet weak var teacher_ImageView: UIImageView!
  
  @IBOutlet weak var teacher_Label: UILabel!
  
  @IBOutlet weak var follow_Button: UIButton!
  
  @IBOutlet weak var time_Label: UILabel!
  
  @IBOutlet weak var peopleIcon_ImageView: UIImageView!
  
  @IBOutlet weak var starIcon_ImageView: UIImageView!
  
  @IBOutlet weak var clockIcon_ImageView: UIImageView!
  
  
  
  
  
  override func layoutSubviews() {
   
    peopleIcon_ImageView.tintColor = UIColor.tealish()
    starIcon_ImageView.tintColor = UIColor.tealish()
    clockIcon_ImageView.tintColor = UIColor.tealish()
    
    teacher_ImageView.layer.cornerRadius = teacher_ImageView.bounds.height / 2
    teacher_ImageView.layer.borderWidth = 2.0
    teacher_ImageView.layer.borderColor = UIColor.white.cgColor
    teacher_ImageView.clipsToBounds = true
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
