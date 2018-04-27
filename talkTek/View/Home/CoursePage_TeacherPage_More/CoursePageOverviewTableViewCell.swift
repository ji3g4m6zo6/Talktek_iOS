//
//  CourseOverviewTableViewCell.swift
//  talkTek
//
//  Created by 李昀 on 2018/3/28.
//  Copyright © 2018年 Talktek Inc. All rights reserved.
//

import UIKit

class CoursePageOverviewTableViewCell: UITableViewCell {
  
  
  @IBOutlet weak var heartButton: UIButton!

  @IBOutlet weak var overviewImageView: UIImageView!
  
  @IBOutlet weak var topicLabel: UILabel!
  
  @IBOutlet weak var studentNumberLabel: UILabel!
  
  @IBOutlet weak var scoreNumberLabel: UILabel!
  
  @IBOutlet weak var coursesNumberLabel: UILabel!
  
  @IBOutlet weak var peopleIcon_ImageView: UIImageView!
  @IBOutlet weak var starIcon_ImageView: UIImageView!
  @IBOutlet weak var clockIcon_ImageView: UIImageView!
  
 


  
  override func layoutSubviews() {
    overviewImageView.roundCorners([.topLeft, .topRight], radius: 15)
    
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
