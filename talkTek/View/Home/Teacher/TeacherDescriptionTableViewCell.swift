//
//  TeacherDescriptionTableViewCell.swift
//  talkTek
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit

class TeacherDescriptionTableViewCell: UITableViewCell {
  
  
  @IBOutlet weak var description_TextView: UITextView!
  
  @IBOutlet weak var expand_Button: UIButton!
  
  override func layoutSubviews() {
    expand_Button.tintColor = UIColor.tealish()
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
