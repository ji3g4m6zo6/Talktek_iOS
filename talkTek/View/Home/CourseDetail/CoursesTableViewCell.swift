//
//  CoursesTableViewCell.swift
//  talkTek
//
//  Created by Mac on 2017/11/23.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CoursesTableViewCell: UITableViewCell {

  @IBOutlet weak var course_TableView: UITableView!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setDatasource(courseId: String){
    video(courseId: courseId)
  }
  var audioItem_Array = [AudioItem]()

  func video(courseId: String){
    var databaseRef: DatabaseReference!
    databaseRef = Database.database().reference()
    databaseRef.child("AudioPlayer").child(courseId).observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: String]{
        let audioItem = AudioItem()
        audioItem.Audio = dictionary["Audio"]
        audioItem.Number = dictionary["Number"]
        audioItem.Section = dictionary["Section"]
        audioItem.Time = dictionary["Time"]
        audioItem.Title = dictionary["Title"]
        audioItem.Topic = dictionary["Topic"]
        
        self.audioItem_Array.append(audioItem)
        
        DispatchQueue.main.async {
          self.course_TableView.reloadData()
        }
      }
    }
  }

}
extension CoursesTableViewCell: UITableViewDataSource, UITableViewDelegate{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return audioItem_Array.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "audioFiles", for: indexPath) as! AudioFilesTableViewCell
    cell.topic_Label.text = audioItem_Array[indexPath.row].Title
    cell.time_Label.text = audioItem_Array[indexPath.row].Time
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 57
  }
  
//  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "audioSection") as! AudioSectionTableViewCell
//    cell.setUpCell(title: categories[section])
//    return cell
//  }
//  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    return 49
//  }
}
