//
//  HotViewController.swift
//  talkTek
//
//  Created by Mac on 2017/12/9.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher
import XLPagerTabStrip

class HotViewController: UIViewController, IndicatorInfoProvider {
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "熱門")
  }
  
  var databaseRef: DatabaseReference!
  @IBOutlet weak var collectionView: UICollectionView!
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.delegate = self
    
    databaseRef = Database.database().reference()
    fetchData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  var homeCourses_Array = [HomeCourses]()
  var homeCouresToPass = HomeCourses()
  func fetchData(){
    // Get the number and root of collectionview
    self.databaseRef.child("Hottest").observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: String]{
        print("dictionary is \(dictionary)")
        
        let homeCourses = HomeCourses()
        
        homeCourses.authorDescription = dictionary["authorDescription"]
        homeCourses.authorImage = dictionary["authorImage"]
        homeCourses.authorName = dictionary["authorName"]
        homeCourses.courseDescription = dictionary["courseDescription"]
        homeCourses.hour = dictionary["hour"]
        homeCourses.overViewImage = dictionary["overViewImage"]
        homeCourses.price = dictionary["price"]
        homeCourses.score = dictionary["score"]
        homeCourses.studentNumber = dictionary["studentNumber"]
        homeCourses.title = dictionary["title"]
        homeCourses.courseId = dictionary["courseId"]
        homeCourses.teacherID = dictionary["teacherID"]
        
        
        
        self.homeCourses_Array.append(homeCourses)
        
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "identifierDetail"{
      let destinationViewController = segue.destination as! CourseDetailViewController
      destinationViewController.detailToGet = self.homeCouresToPass
    }
  }
  
  
}

extension HotViewController: UICollectionViewDelegate, UICollectionViewDataSource{
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return homeCourses_Array.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HotCollectionViewCell
    
    cell.author_Label.text = homeCourses_Array[indexPath.item].authorName
    
    if let priceNum = homeCourses_Array[indexPath.item].price{
      let priceLabel = priceNum + "點"
      cell.price_Label.text = priceLabel
    }
    if let studentNum = homeCourses_Array[indexPath.item].studentNumber{
      let studentLabel = studentNum + "人購買"
      cell.peopleBought_Label.text = studentLabel
    }
    if let overviewUrl = homeCourses_Array[indexPath.item].overViewImage{
      let url = URL(string: overviewUrl)
      cell.overview_ImageView.kf.setImage(with: url)
    }
    if let authorUrl = homeCourses_Array[indexPath.item].authorImage{
      let url = URL(string: authorUrl)
      cell.author_ImageView.kf.setImage(with: url)
    }
    
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    homeCouresToPass = homeCourses_Array[indexPath.item]
    performSegue(withIdentifier: "identifierDetail", sender: self)
  }
}

extension HotViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 20
  }
  /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    let elements_count = 15
    let cellCount = CGFloat(elements_count)
    
    // 如果 Cell 的數量是 0，也沒必要做 Layout
    if cellCount > 0 {
      let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
      let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
      
      // 如果你想要加 extra space 給 cell
      let totalCellWidth = cellWidth*cellCount // + 5.00 * (cellCount-1)
      let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
      
      if (totalCellWidth < contentWidth) {
        //If the number of cells that exists take up less room than the
        //collection view width... then there is an actual point to centering them.
        
        // 在一個 row 放幾個 cells
        let padding = (contentWidth - totalCellWidth) / 2.0
        return UIEdgeInsetsMake(0, padding, 0, padding)
      } else {
        //Pretty much if the number of cells that exist take up
        //more room than the actual collectionView width, there is no
        // point in trying to center them. So we leave the default behavior.
        return UIEdgeInsetsMake(0, 40, 0, 40)
      }
    }
    
    return UIEdgeInsets.zero
  }*/
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 160, height: 190)
  }
}


