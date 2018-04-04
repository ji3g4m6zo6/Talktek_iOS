//
//  CoursePageExpandTableViewCell.swift
//  talkTek
//
//  Created by 李昀 on 2018/3/28.
//  Copyright © 2018年 Talktek Inc. All rights reserved.
//

import UIKit

class CoursePageExpandTableViewCell: UITableViewCell {
  
  @IBOutlet weak var expandButton: UIButton!
  
  
  override func layoutSubviews() {
    expandButton.tintColor = UIColor.tealish()
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
