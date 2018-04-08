//
//  PlayerViewController.swift
//  talkTek
//
//  Created by Mac on 2017/12/10.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseStorage
import FirebaseDatabase
import Firebase

class PlayerViewController: UIViewController {
  
  var audioData = [AudioItem?]()
  var thisSong = 0

  @IBOutlet weak var photoToTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var playerToTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var sliderToTopConstraint: NSLayoutConstraint!
  
  
  
  @IBOutlet weak var playerToBottom_Button: UIButton!
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
  @IBOutlet weak var previous_Button: UIButton!
  @IBOutlet weak var next_Button: UIButton!
  @IBOutlet weak var slow_Button: UIButton!
  @IBOutlet weak var speed_Button: UIButton!

  @IBOutlet weak var totalTime_Label: UILabel!
  @IBOutlet weak var currenttime_Label: UILabel!
  
  @IBOutlet weak var progress_UIProguress: UIProgressView!
  @IBOutlet weak var slider_UISlider: UISlider!
  @IBAction func playpause_Button_Tapped(_ sender: UIButton) {
    if selected == -1 {
      player.pause()
      playpause_Button.setImage(UIImage(named: "播放(大)"), for: .normal)
      selected += 1
    } else {
      if self.player.status == .readyToPlay{
        player.play()
        playpause_Button.setImage(UIImage(named: "暫停(大)"), for: .normal)
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
    if thisSong < audioData.count-1 {
      thisSong += 1
      if let audioOfThisSongExisted = audioData[thisSong] {
        letsPlay(songAudio: audioOfThisSongExisted)
      } else {
        next_Button_Tapped(next_Button)
      }
    } else {
      thisSong = 0
      if let audioOfThisSongExisted = audioData[thisSong] {
        letsPlay(songAudio: audioOfThisSongExisted)
      } else {
        next_Button_Tapped(next_Button)
      }
    }
  }

  @IBAction func previous_Button_Tapped(_ sender: UIButton) {
    if thisSong != 0 {
      thisSong -= 1
      if let audioOfThisSongExisted = audioData[thisSong] {
        letsPlay(songAudio: audioOfThisSongExisted)
      } else {
        previous_Button_Tapped(previous_Button)
      }
    } else {
      thisSong = audioData.count-1
      if let audioOfThisSongExisted = audioData[thisSong] {
        letsPlay(songAudio: audioOfThisSongExisted)
      } else {
        previous_Button_Tapped(previous_Button)
      }
    }
  }
  func letsPlay(songAudio: AudioItem){
    
    title_Label.text = songAudio.Topic
    topic_Label.text = songAudio.Title
    
    playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
    playerItem.removeObserver(self, forKeyPath: "status")
    
    guard let url = URL(string: songAudio.Audio!) else { fatalError("連接錯誤") }
    
    playerItem = AVPlayerItem(url: url)
    playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
    playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
    
    player = AVPlayer(playerItem: playerItem)
    
    slider_UISlider.minimumValue = 0
    slider_UISlider.maximumValue = 1
    
    slider_UISlider.value = 0
    
    
    
  }
  @IBAction func speedup_Button_Tapped(_ sender: UIButton) {
    /*
    if self.player.status == .readyToPlay{
      let duration = Float(CMTimeGetSeconds(self.player.currentItem!.duration)) + 15.0
      let seekTime = CMTimeMake(Int64(duration), 1)
      self.player.seek(to: seekTime)
    }*/
  }
  
  @IBAction func speeddown_Button_Tapped(_ sender: UIButton) {
    /*
    if self.player.status == .readyToPlay{
      let duration = Float(CMTimeGetSeconds(self.player.currentItem!.duration)) - 15.0
      let seekTime = CMTimeMake(Int64(duration), 1)
      self.player.seek(to: seekTime)
    }*/
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
    
    
    playerToTopConstraint.constant = view.frame.height * 0.7
    sliderToTopConstraint.constant = view.frame.height * 0.83
    
    
    slow_Button.tintColor = UIColor.white
    previous_Button.tintColor = UIColor.white
    playpause_Button.tintColor = UIColor.white
    next_Button.tintColor = UIColor.white
    speed_Button.tintColor = UIColor.white
    playerToBottom_Button.tintColor = UIColor.white
    
    
    guard let audioDataOfThisSong = audioData[thisSong] else {
      return
    }
    if let SectionPriority = audioDataOfThisSong.SectionPriority, let RowPriority = audioDataOfThisSong.RowPriority {
      Analytics.logEvent("seaweedbear1_radio\(SectionPriority)_\(RowPriority)_play", parameters: nil)
    }

    title_Label.text = audioDataOfThisSong.Topic
    topic_Label.text = audioDataOfThisSong.Title
    
    
    guard let url = URL(string: audioDataOfThisSong.Audio!) else { fatalError("連接錯誤") }
    
    playerItem = AVPlayerItem(url: url)
    playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
    playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
    
    player = AVPlayer(playerItem: playerItem)
    
    slider_UISlider.minimumValue = 0
    slider_UISlider.maximumValue = 1
    slider_UISlider.value = 0
    slider_UISlider.setThumbImage(UIImage(named: "播放條"), for: .normal)
    
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
        playpause_Button.setImage(UIImage(named: "暫停(大)"), for: .normal)
        
        do {
          try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
          print("Playback OK")
          try AVAudioSession.sharedInstance().setActive(true)
          print("Session is Active")
        } catch {
          print(error)
        }
        
      }else{
        print("加載異常")
      }
    }
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  override func viewWillDisappear(_ animated: Bool) {
    player.pause()
    
    playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
    playerItem.removeObserver(self, forKeyPath: "status")
    
  }
 
  
  
//  deinit {
//    playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
//    playerItem.removeObserver(self, forKeyPath: "status")
//  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
