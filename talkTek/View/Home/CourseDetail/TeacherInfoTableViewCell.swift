//
//  TeacherInfoTableViewCell.swift
//  talkTek
//
//  Created by Mac on 2017/11/23.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit

class TeacherInfoTableViewCell: UITableViewCell {

  @IBOutlet weak var teacherPic_ImageView: UIImageView!
  
  @IBOutlet weak var teacherName_Label: UILabel!
  
  @IBOutlet weak var teacherIntro_Label: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  override func layoutSubviews() {
    teacherPic_ImageView.layer.cornerRadius = teacherPic_ImageView.bounds.height / 2
    teacherPic_ImageView.layer.borderWidth = 2.0
    teacherPic_ImageView.layer.borderColor = UIColor.white.cgColor
    teacherPic_ImageView.clipsToBounds = true
  }
}
