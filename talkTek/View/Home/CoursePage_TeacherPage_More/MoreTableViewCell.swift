//
//  MoreTableViewCell.swift
//  talkTek
//
//  Created by Mac on 2018/1/31.
//  Copyright © 2018年 Talktek Inc. All rights reserved.
//

import UIKit

class MoreTableViewCell: UITableViewCell {
  
  
  @IBOutlet weak var heartButton: UIButton!
  
  @IBOutlet weak var overviewImageView: UIImageView!
  
  @IBOutlet weak var authorImageView: UIImageView!
  
  @IBOutlet weak var authorNameLabel: UILabel!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var iconImageView: UIImageView!

  @IBOutlet weak var money_Label: UILabel!

  @IBOutlet weak var studentNumberLabel: UILabel!
  
  @IBOutlet weak var commentNumberLabel: UILabel!
  
  override func layoutSubviews() {
    authorImageView.layer.cornerRadius = authorImageView.bounds.height / 2
    authorImageView.layer.borderWidth = 2.0
    authorImageView.clipsToBounds = true
    iconImageView.tintColor = UIColor.moneyYellow()
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
