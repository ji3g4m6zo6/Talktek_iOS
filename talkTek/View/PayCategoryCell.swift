//
//  PayCategoryCell.swift
//  talkTek
//
//  Created by Mac on 2017/11/21.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit

class PayCategoryCell: UITableViewCell {

  @IBOutlet weak var collectionView: UICollectionView!
  var coursesOfEachCategory: CoursesOfEachCategory? = nil{
    didSet{
      collectionView.reloadData()
    }
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

extension PayCategoryCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 12 //coursesOfEachCategory!.course.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseCell", for: indexPath) as! PayCollectionViewCell
//    if let coursesOfEachCategory = coursesOfEachCategory{
//      cell.Topic_Label.text = coursesOfEachCategory.course[indexPath.row].title
//    }
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 160, height: 190)
  }
  
}
