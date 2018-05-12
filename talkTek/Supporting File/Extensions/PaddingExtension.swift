//
//  PaddingExtension.swift
//  talkTek
//
//  Created by 李昀 on 2018/4/27.
//  Copyright © 2018年 Talktek Inc. All rights reserved.
//

import Foundation

class UITextFieldPadding : UITextField {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds,
                                 UIEdgeInsetsMake(0, 10, 0, 10))
  }
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds,
                                 UIEdgeInsetsMake(0, 10, 0, 10))
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds,
                                 UIEdgeInsetsMake(0, 10, 0, 10))
  }
}

class UITextViewPadding : UITextView {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
  }
}

class UILabelPadding : UILabel {
  
  private var padding = UIEdgeInsets.zero
  
  @IBInspectable
  var paddingLeft: CGFloat {
    get { return padding.left }
    set { padding.left = newValue }
  }
  
  @IBInspectable
  var paddingRight: CGFloat {
    get { return padding.right }
    set { padding.right = newValue }
  }
  
  @IBInspectable
  var paddingTop: CGFloat {
    get { return padding.top }
    set { padding.top = newValue }
  }
  
  @IBInspectable
  var paddingBottom: CGFloat {
    get { return padding.bottom }
    set { padding.bottom = newValue }
  }
  
  override func drawText(in rect: CGRect) {
    super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
  }
  
  override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
    let insets = self.padding
    var rect = super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, insets), limitedToNumberOfLines: numberOfLines)
    rect.origin.x    -= insets.left
    rect.origin.y    -= insets.top
    rect.size.width  += (insets.left + insets.right)
    rect.size.height += (insets.top + insets.bottom)
    return rect
  }
  
}
