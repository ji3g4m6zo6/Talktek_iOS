//
//  Setting.swift
//  talkTek
//
//  Created by Mac on 2017/12/3.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import Foundation

class User: NSObject{
  
  var name: String?
  var account: String?
  var birthday: String?
  var gender: String?
  var profileImageUrl: String?
  
  
}

class CashFlow: NSObject {
  var CashValue: Int?
  var RewardPoints: Int?
}

class CashFlowHistory: NSObject {
  var Time: Date?
  var CashType: String?
  var Value: Int?
  var Unit: String?
}

