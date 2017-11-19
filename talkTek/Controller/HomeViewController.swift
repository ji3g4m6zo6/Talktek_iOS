//
//  HomeViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/18.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  @IBOutlet weak var PayContainerView: UIView!
  @IBOutlet weak var FreeContainerView: UIView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
    searchImplement()
    segmentedControl.addUnderlineForSelectedSegment()

    PayContainerView.isHidden = false
    FreeContainerView.isHidden = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func searchImplement(){
    let search = UISearchController(searchResultsController: nil)
    search.searchResultsUpdater = self as? UISearchResultsUpdating
    self.navigationItem.searchController = search
  }
  
  
  @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
    segmentedControl.changeUnderlinePosition()
    switch segmentedControl.selectedSegmentIndex{
    case 0:
      PayContainerView.isHidden = false
      FreeContainerView.isHidden = true
    case 1:
      PayContainerView.isHidden = true
      FreeContainerView.isHidden = false
    default: fatalError()
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
