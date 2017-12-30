//
//  PlayerViewController.swift
//  talkTek
//
//  Created by Mac on 2017/12/10.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
  
  var audioData = [AudioItem]()
  var thisSong = 0
  var audioStuffed = false

  
  var player:AVPlayer?
  var playerItem:AVPlayerItem?
  
  @IBOutlet weak var overview_ImageView: UIImageView!
  @IBOutlet weak var topic_Label: UILabel!
  @IBOutlet weak var title_Label: UILabel!
  @IBOutlet weak var playpause_Button: UIButton!
  
  @IBOutlet weak var totalTime_Label: UILabel!
  @IBOutlet weak var currenttime_Label: UILabel!
  
  @IBOutlet weak var slider_UISlider: UISlider!
  @IBAction func playpause_Button_Tapped(_ sender: UIButton) {
    
    
    if audioStuffed == true && player?.rate == 0
    {
      player!.play()
      playpause_Button.setImage(UIImage(named: "暫停"), for: .normal)
    } else if audioStuffed == true && player?.rate == 1{
      player!.pause()
      playpause_Button.setImage(UIImage(named: "播放"), for: .normal)
    }
    
  }
  
  func playThis(thisOne: String)
  {
    
    player!.play()
    
  }
  
  @IBAction func next_Button_Tapped(_ sender: UIButton) {
    
  }

  @IBAction func previous_Button_Tapped(_ sender: UIButton) {
    
  }

  @IBAction func speedup_Button_Tapped(_ sender: UIButton) {
    
  }
  
  @IBAction func speeddown_Button_Tapped(_ sender: UIButton) {
  }

  @IBAction func slider_Tapped(_ sender: UISlider) {
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    // Do any additional setup after loading the view.
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    topic_Label.text = audioData[thisSong].Topic
    title_Label.text = audioData[thisSong].Title
    
    
    if let urlString = audioData[thisSong].Audio{
      let url = URL(string: urlString)
      let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
      player = AVPlayer(playerItem: playerItem)
      slider_UISlider.minimumValue = 0
      if let timeString = audioData[thisSong].Time{
        self.totalTime_Label.text = timeString
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        let timeFloat = Float64(seconds)
        slider_UISlider.maximumValue = Float(timeFloat)
      }
      slider_UISlider.isContinuous = true
      player?.play()
    }
    
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
