//
//  MainTableViewCell.swift
//  talkTek
//
//  Created by Mac on 2017/11/23.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
  
  @IBOutlet weak var overview_ImageView: UIImageView!
  
  @IBOutlet weak var title_Label: UILabel!
  
  @IBOutlet weak var studentNumber_Label: UILabel!
  
  @IBOutlet weak var score_Label: UILabel!
  
  @IBOutlet weak var courseHour_Label: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
