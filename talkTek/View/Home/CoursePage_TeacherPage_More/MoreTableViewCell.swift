//
//  MoreTableViewCell.swift
//  talkTek
//
//  Created by Mac on 2018/1/31.
//  Copyright © 2018年 Talktek Inc. All rights reserved.
//

import UIKit

class MoreTableViewCell: UITableViewCell {
  
  @IBOutlet weak var overviewImageView: UIImageView!
  
  @IBOutlet weak var authorImageView: UIImageView!
  
  @IBOutlet weak var authorNameLabel: UILabel!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var iconImageView: UIImageView!

  @IBOutlet weak var money_Label: UILabel!

  
  @IBOutlet weak var studentNumberLabel: UILabel!
  
  @IBOutlet weak var commentNumberLabel: UILabel!
  
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func layoutSubviews() {
    author_ImageView.layer.cornerRadius = author_ImageView.bounds.height / 2
    author_ImageView.layer.borderWidth = 2.0
    author_ImageView.layer.borderColor = UIColor.white.cgColor
    author_ImageView.clipsToBounds = true
  }
  
}
