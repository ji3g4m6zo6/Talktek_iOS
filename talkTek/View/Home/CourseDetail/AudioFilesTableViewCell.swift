//
//  AudioFilesTableViewCell.swift
//  talkTek
//
//  Created by Mac on 2017/11/23.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit

class AudioFilesTableViewCell: UITableViewCell {
  
  
  
  @IBOutlet weak var topic_Label: UILabel!
  @IBOutlet weak var time_Label: UILabel!
  
  
  
  @IBOutlet weak var playIcon_Button: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    playIcon_Button.tintColor = UIColor.audioPlayGray()
    // Configure the view for the selected state
  }
  
}
