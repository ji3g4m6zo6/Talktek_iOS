//
//  ProfessionalViewController.swift
//  talkTek
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import FirebaseDatabase
import Kingfisher


class ProfessionalViewController: UIViewController, IndicatorInfoProvider {
  @IBOutlet weak var collectionView: UICollectionView!
  var databaseRef: DatabaseReference!
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "職場")
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.delegate = self
    
    databaseRef = Database.database().reference()
    fetchData()
    
    collectionView.es.addPullToRefresh {
      [unowned self] in
      self.homeCourses_Array.removeAll()
      self.fetchData()
    }
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  var homeCourses_Array = [HomeCourses]()
  var homeCouresToPass = HomeCourses()
  func fetchData(){
    // Get the number and root of collectionview
    databaseRef = Database.database().reference()
    
    databaseRef.child("AllCourses").observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: Any]{
        
        let homeCourses = HomeCourses()
        
        homeCourses.authorDescription = dictionary["authorDescription"] as? String
        homeCourses.authorImage = dictionary["authorImage"] as? String
        homeCourses.authorName = dictionary["authorName"] as? String
        homeCourses.courseDescription = dictionary["courseDescription"] as? String
        homeCourses.hour = dictionary["hour"] as? String
        homeCourses.overViewImage = dictionary["overViewImage"] as? String
        homeCourses.price = dictionary["price"] as? String
        homeCourses.score = dictionary["score"] as? String
        homeCourses.studentNumber = dictionary["studentNumber"] as? Int
        homeCourses.title = dictionary["title"] as? String
        homeCourses.courseId = dictionary["courseId"] as? String
        homeCourses.teacherID = dictionary["teacherID"] as? String
        homeCourses.onSalesPrice = dictionary["onSalesPrice"] as? String
        homeCourses.tags = dictionary["tags"] as! [String]
        
        
        //self.homeCourses_Array.append(homeCourses)
        
        self.tagsSplit(tags: homeCourses.tags, homecourse: homeCourses)
        
      }
    }
  }
  
  func tagsSplit(tags: [String?], homecourse: HomeCourses){
    for (_, value) in tags.enumerated() {
      guard let value = value else { return }
      if value.contains("Professional"){
        homeCourses_Array.append(homecourse)
      }
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "identifierDetail"{
      let destinationViewController = segue.destination as! CourseDetailViewController
      destinationViewController.detailToGet = self.homeCouresToPass
      destinationViewController.hidesBottomBarWhenPushed = true

    }
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
extension ProfessionalViewController: UICollectionViewDelegate, UICollectionViewDataSource{
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return homeCourses_Array.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProfessionCollectionViewCell
    
    cell.author_Label.text = homeCourses_Array[indexPath.item].authorName
    
    if let priceNum = homeCourses_Array[indexPath.item].price{
      let priceLabel = priceNum + "點"
      cell.price_Label.text = priceLabel
    }
    if let studentNum = homeCourses_Array[indexPath.item].studentNumber{
      let studentLabel = String(studentNum) + "人購買"
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
    cell.title_Label.text = homeCourses_Array[indexPath.item].title

    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    homeCouresToPass = homeCourses_Array[indexPath.item]
    performSegue(withIdentifier: "identifierDetail", sender: self)
  }
}

extension ProfessionalViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
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
