//
//  UIImageViewExtension.swift
//  talkTek
//
//  Created by Mac on 2017/11/19.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
  func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
    contentMode = mode
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data, error == nil,
        let image = UIImage(data: data)
        else { return }
      DispatchQueue.main.async() {
        self.image = image
      }
      }.resume()
  }
  func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
    guard let url = URL(string: link) else { return }
    downloadedFrom(url: url, contentMode: mode)
  }
}


extension UIImageView
{
  func addBlurEffect()
  {
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.bounds
    
    blurEffectView.backgroundColor = UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 0.03)
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
    self.addSubview(blurEffectView)
  }
}
