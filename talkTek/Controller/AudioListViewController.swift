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
  // https://drive.google.com/open?id=0B6OE35YKfCt3dFZRNzMxdVdHRzA
  
  var data = [""]
  var idToGet = ""
  var audioItem = AudioItem()
  var audioItem_Array = [AudioItem]()
  
  
  var databaseRef: DatabaseReference!

  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    
    
    databaseRef = Database.database().reference()
    fetchData()

    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func fetchData(){
    // Get the number and root of collectionview
    
    self.databaseRef.child(idToGet).observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: String]{
        let audioItem = AudioItem()
        
        audioItem.Audio = dictionary["Audio"]
        audioItem.Number = dictionary["Number"]
        audioItem.Time = dictionary["Time"]
        audioItem.Title = dictionary["Title"]
        audioItem.Section = dictionary["Section"]
        
        self.audioItem_Array.append(audioItem)
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
        
      }
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
extension AudioListViewController: UITableViewDataSource, UITableViewDelegate{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return audioItem_Array.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AudioListTableViewCell
    
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 57
  }
//  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    let header = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! AudioHeaderTableViewCell
//    header.title_Label.text = ""
//    return header
//  }
//  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    return 49
//  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "identifierPlayer", sender: self)
  }
  
}
