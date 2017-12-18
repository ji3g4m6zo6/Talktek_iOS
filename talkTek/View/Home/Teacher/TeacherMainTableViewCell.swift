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
  
  
  
  
  
  
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
