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
  
  var link:CADisplayLink!

  
  @IBOutlet weak var overview_ImageView: UIImageView!
  @IBOutlet weak var topic_Label: UILabel!
  @IBOutlet weak var title_Label: UILabel!
  @IBOutlet weak var playpause_Button: UIButton!
  
  @IBOutlet weak var totalTime_Label: UILabel!
  @IBOutlet weak var currenttime_Label: UILabel!
  
  @IBOutlet weak var progress_UIProguress: UIProgressView!
  @IBOutlet weak var slider_UISlider: UISlider!
  @IBAction func playpause_Button_Tapped(_ sender: UIButton) {
    if selected == -1 {
      player.pause()
      selected += 1
    } else {
      if self.player.status == .readyToPlay{
        player.play()
        selected = -1
      }
    }
    
  }
  var selected = -1
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
    if self.player.status == .readyToPlay{
      let duration = slider_UISlider.value * Float(CMTimeGetSeconds(self.player.currentItem!.duration))
      let seekTime = CMTimeMake(Int64(duration), 1)
      self.player.seek(to: seekTime)
    }
  }
  
  func availableDurationWithplayerItem()->TimeInterval{
    guard let loadedTimeRanges = player?.currentItem?.loadedTimeRanges, let first = loadedTimeRanges.first else { fatalError() }
    let timeRange = first.timeRangeValue
    let startSeconds = CMTimeGetSeconds(timeRange.start)
    let durationSecound = CMTimeGetSeconds(timeRange.duration)
    let result = startSeconds + durationSecound
    return result
  }
  @objc func update(){
//    //暂停的时候
//    if !self.playerView.playing{
//      return
//    }
    
    let currentTime = CMTimeGetSeconds(self.player.currentTime())
    let totalTime   = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
    
    let currentTimeStr = formatPlayTime(secounds: currentTime)
    let totalTimeStr   = formatPlayTime(secounds: totalTime)
    
    self.currenttime_Label.text = currentTimeStr
    self.totalTime_Label.text = totalTimeStr
    
    
    self.slider_UISlider.value = Float(currentTime/totalTime)
//    // 滑动不在滑动的时候
//    if !self.playerView.sliding{
//      // 播放进度
//      self.playerView.slider.value = Float(currentTime/totalTime)
//    }
    
    
  }
  func formatPlayTime(secounds:TimeInterval)->String{
    if secounds.isNaN{
      return "00:00"
    }
    let Min = Int(secounds / 60)
    let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
    return String(format: "%02d:%02d", Min, Sec)
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
    
    slider_UISlider.minimumValue = 0
    slider_UISlider.maximumValue = 1
    slider_UISlider.value = 0

    
    self.link = CADisplayLink(target: self, selector: #selector(update))
    self.link.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)

    // Do any additional setup after loading the view.
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    
  }
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard let playerItem = object as? AVPlayerItem else { return }
    if keyPath == "loadedTimeRanges"{
      // 緩衝進度
      let loadedTime = availableDurationWithplayerItem()
      let totalTime = CMTimeGetSeconds(playerItem.duration)
      let percent = loadedTime/totalTime
      self.progress_UIProguress.progress = Float(percent)
      
    } else if keyPath == "status"{
      // 監聽狀態改變
      if playerItem.status == AVPlayerItemStatus.readyToPlay{
        // 只有readyToPlay狀態，才能播放
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
