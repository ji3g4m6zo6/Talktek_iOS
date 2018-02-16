//
//  AudioListViewController.swift
//  talkTek
//
//  Created by Mac on 2017/12/17.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class AudioListViewController: UIViewController {
  
  var idToGet = ""
  var audioItem = AudioItem()
  var audioItem_Array = [AudioItem]()
  
  var sections = [String]()
  var audioDictionary = [Int: [AudioItem]]()
  
  var thisSong = 0
  
  
  var databaseRef: DatabaseReference!

  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    
    databaseRef = Database.database().reference()
    //fetchData()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  override func viewWillAppear(_ animated: Bool) {
    if let index = self.tableView.indexPathForSelectedRow{
      self.tableView.deselectRow(at: index, animated: true)
    }
  }
  
  @objc func player_Button_Tapped(sender: UIButton){
    self.thisSong = sender.tag
    print("sender tag is \(sender.tag)")
    performSegue(withIdentifier: "identifierPlayer", sender: self)
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "identifierPlayer"{
      let destination = segue.destination as! PlayerViewController
      destination.audioData = audioItem_Array
      destination.thisSong = self.thisSong
    }
    
  }
  
  
}
extension AudioListViewController: UITableViewDataSource, UITableViewDelegate{
  func numberOfSections(in tableView: UITableView) -> Int {
    //return 1
    return audioDictionary.count

  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //return audioItem_Array.count
    return audioDictionary[section]!.count+1 /// danger!!!

  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0{
      let cell = tableView.dequeueReusableCell(withIdentifier: "audioHeader", for: indexPath) as! AudioSectionTableViewCell
      cell.title_Label.text = sections[indexPath.section]
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AudioListTableViewCell
      let audioArray = audioDictionary[indexPath.section]
      
      cell.topic_Label.text = audioArray![indexPath.row-1].Title//danger
      cell.time_Label.text = audioArray![indexPath.row-1].Time//danger
      
      if let _ = audioArray {
        
        var rowForPlay = 0
        for i in 0...indexPath.section {
          // addition of total row by section from dictionary
          let rowCountDependOnI = audioDictionary[i]?.count
          if let rowCountDependOnI = rowCountDependOnI {
            rowForPlay += rowCountDependOnI
            cell.play_Button.tag = rowForPlay - 1
            cell.play_Button.addTarget(self, action: #selector(player_Button_Tapped(sender:)), for: .touchUpInside)

          }
        }
        

      }
      
      return cell
    }
    
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 68
  }
  
//  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    let header = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! AudioHeaderTableViewCell
//    header.title_Label.text = ""
//    return header
//  }
//  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    return 49
//  }
  
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    self.thisSong = indexPath.row
//    performSegue(withIdentifier: "identifierPlayer", sender: self)
//  }
//
}
