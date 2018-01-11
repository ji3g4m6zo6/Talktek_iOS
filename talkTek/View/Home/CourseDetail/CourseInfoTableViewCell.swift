//
//  CourseInfoTableViewCell.swift
//  talkTek
//
//  Created by Mac on 2017/11/23.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit

class CourseInfoTableViewCell: UITableViewCell {

  @IBOutlet weak var courseInfo_Label: UILabel!
  
  
  @IBOutlet weak var expandIcon_Button: UIButton!
  
  override func layoutSubviews() {
    expandIcon_Button.tintColor = UIColor.tealish()
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
