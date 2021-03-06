//
//  TeacherPageOverviewTableViewCell.swift
//  talkTek
//
//  Created by 李昀 on 2018/4/5.
//  Copyright © 2018年 Talktek Inc. All rights reserved.
//

import UIKit

class TeacherPageOverviewTableViewCell: UITableViewCell {
  
  @IBOutlet weak var teacherImageView: UIImageView!
  
  @IBOutlet weak var teacherNameLabel: UILabel!
  
  @IBOutlet weak var studentNumberLabel: UILabel!
  
  @IBOutlet weak var scoreNumberLabel: UILabel!
  
  @IBOutlet weak var coursesNumberLabel: UILabel!
  
  @IBOutlet weak var peopleIcon_ImageView: UIImageView!
  @IBOutlet weak var starIcon_ImageView: UIImageView!
  @IBOutlet weak var clockIcon_ImageView: UIImageView!
  
  override func layoutSubviews() {
    
    peopleIcon_ImageView.tintColor = UIColor.tealish()
    starIcon_ImageView.tintColor = UIColor.tealish()
    clockIcon_ImageView.tintColor = UIColor.tealish()
    
    teacherImageView.layer.cornerRadius = teacherImageView.bounds.height / 2
    teacherImageView.clipsToBounds = true
    
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
