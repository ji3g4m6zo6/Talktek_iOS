//
//  CoursePageListTableViewCell.swift
//  talkTek
//
//  Created by 李昀 on 2018/3/28.
//  Copyright © 2018年 Talktek Inc. All rights reserved.
//

import UIKit

class CoursePageListTableViewCell: UITableViewCell {

  @IBOutlet weak var playerButton: UIButton!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var timeLabel: UILabel!
  
  @IBOutlet weak var uitryoutButton: UIButton!
  
  @IBOutlet weak var tryoutButton: UIButton!
  
  override func layoutSubviews() {
    playerButton.tintColor = UIColor.audioPlayGray()
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
