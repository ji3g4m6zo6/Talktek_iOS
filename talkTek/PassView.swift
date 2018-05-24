//
//  PassView.swift
//  talkTek
//
//  Created by 李昀 on 2018/4/24.
//  Copyright © 2018年 Talktek Inc. All rights reserved.
//

import UIKit

class PassView: UIView {
  
  @IBOutlet var contentView: UIView!
  
  @IBOutlet weak var playerView: UIView!
  
  @IBOutlet weak var playButton: UIButton!
  
  @IBOutlet weak var topicLabel: UILabel!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var expandButton: UIButton!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
    
  }
  
  private func commonInit(){
    
    //Bundle.main.loadNibNamed("PassView", owner: self, options: nil)
//    contentView = loadNib()
//    addSubview(contentView)
//    contentView.frame = self.bounds
//    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    UINib(nibName: "MiniPlayerView", bundle: nil).instantiate(withOwner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
  }
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */
  
}
extension UIView {
  /** Loads instance from nib with the same name. */
  func loadNib() -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nibName = type(of: self).description().components(separatedBy: ".").last!
    let nib = UINib(nibName: nibName, bundle: bundle)
    return nib.instantiate(withOwner: self, options: nil).first as! UIView
  }
}

