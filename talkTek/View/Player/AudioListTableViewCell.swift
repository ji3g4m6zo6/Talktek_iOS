//
//  AudioListTableViewCell.swift
//  talkTek
//
//  Created by Mac on 2017/12/17.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit

class AudioListTableViewCell: UITableViewCell {
  @IBOutlet weak var topic_Label: UILabel!
  @IBOutlet weak var time_Label: UILabel!
  @IBOutlet weak var play_Button: UIButton!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  
  @IBAction func play_Button_Tapped(_ sender: UIButton) {
  }
  
}
