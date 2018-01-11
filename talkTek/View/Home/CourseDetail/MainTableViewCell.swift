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
  
  
  @IBOutlet weak var peopleIcon_ImageView: UIImageView!
  
  @IBOutlet weak var starIcon_ImageView: UIImageView!
  
  @IBOutlet weak var clockIcon_ImageView: UIImageView!
  override func layoutSubviews() {
    peopleIcon_ImageView.tintColor = UIColor.tealish()
    starIcon_ImageView.tintColor = UIColor.tealish()
    clockIcon_ImageView.tintColor = UIColor.tealish()
    
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
