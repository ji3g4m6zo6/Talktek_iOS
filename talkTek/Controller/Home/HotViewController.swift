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

class HotViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.delegate = self
    
  
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
}

extension HotViewController: UICollectionViewDelegate, UICollectionViewDataSource{
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 7
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HotCollectionViewCell
    
    return cell
  }
  /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    <#code#>
  }*/
}

extension HotViewController: UICollectionViewDelegateFlowLayout{
  /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
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
