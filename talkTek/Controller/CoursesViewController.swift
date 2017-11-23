//
//  CoursesViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/23.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit

class CoursesViewController: UIViewController {
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  lazy var payViewController: CoursesBoughtViewController = {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    var viewController = storyboard.instantiateViewController(withIdentifier: "CoursesBoughtViewController") as! CoursesBoughtViewController
    self.addViewControllerAsChildViewController(childViewController: viewController)
    return viewController
  }()
  lazy var freeViewController: CoursesHeartViewController = {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    var viewController = storyboard.instantiateViewController(withIdentifier: "CoursesHeartViewController") as! CoursesHeartViewController
    self.addViewControllerAsChildViewController(childViewController: viewController)
    return viewController
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.prefersLargeTitles = true
    searchImplement()
    
    setUpView()
    segmentedControl.addUnderlineForSelectedSegment()
    
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
  
  
  
  private func setUpView() {
    setUpSegmentedControl()
    
    updateView()
  }
  
  private func updateView() {
    payViewController.view.isHidden = !(segmentedControl.selectedSegmentIndex == 0)
    freeViewController.view.isHidden = (segmentedControl.selectedSegmentIndex == 0)
  }
  
  private func setUpSegmentedControl() {
    
    
    segmentedControl.removeAllSegments()
    segmentedControl.insertSegment(withTitle: "課程小講", at: 0, animated: false)
    segmentedControl.insertSegment(withTitle: "免費膠囊", at: 1, animated: false)
    segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
    
    segmentedControl.selectedSegmentIndex = 0
    
  }
  
  @objc func selectionDidChange(sender: UISegmentedControl) {
    segmentedControl.changeUnderlinePosition()
    
    updateView()
  }
  
  private func addViewControllerAsChildViewController(childViewController: UIViewController) {
    addChildViewController(childViewController)
    
    view.insertSubview(childViewController.view, at: 0)
    
    childViewController.view.frame = view.bounds
    childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    childViewController.didMove(toParentViewController: self)
    
  }
  
  private func removeViewControllerAsChildViewController(childViewController: UIViewController) {
    childViewController.willMove(toParentViewController: nil)
    
    childViewController.view.removeFromSuperview()
    
    childViewController.removeFromParentViewController()
  }
  
  
  
  
}
