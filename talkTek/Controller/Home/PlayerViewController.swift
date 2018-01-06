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

  @IBAction func PlayerToBottom_Button_Tapped(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  var player: AVPlayer!
  var playerItem: AVPlayerItem!
  
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
    
    topic_Label.text = audioData[thisSong].Topic
    title_Label.text = audioData[thisSong].Title
    
    
    guard let url = URL(string: audioData[thisSong].Audio!) else { fatalError("連接錯誤") }
    
    playerItem = AVPlayerItem(url: url)
    playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
    playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
    
    player = AVPlayer(playerItem: playerItem)
    
    //player = AVPlayer(playerItem: playerItem)
//    slider_UISlider.minimumValue = 0
//    if let timeString = audioData[thisSong].Time{
//      self.totalTime_Label.text = timeString
//      let duration : CMTime = playerItem!.asset.duration
//      let seconds : Float64 = CMTimeGetSeconds(duration)
//      let timeFloat = Float64(seconds)
//      slider_UISlider.maximumValue = Float(timeFloat)
//      print("time is \(timeFloat)")
//    }
//    slider_UISlider.isContinuous = true
    
    // Do any additional setup after loading the view.
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    
    
    
    
  }
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard let playerItem = object as? AVPlayerItem else { return }
    if keyPath == "loadedTimeRanges"{
      // 缓冲进度 暂时不处理
      print("loaded time ranges \(keyPath ?? "")")
    }else if keyPath == "status"{
      // 监听状态改变
      if playerItem.status == AVPlayerItemStatus.readyToPlay{
        // 只有在这个状态下才能播放
        self.player.play()
      }else{
        print("加載異常")
      }
    }
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
 
  deinit {
    playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
    playerItem.removeObserver(self, forKeyPath: "status")
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
