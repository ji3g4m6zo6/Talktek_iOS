//
//  Home.swift
//  talkTek
//
//  Created by Mac on 2017/12/3.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class HomeCourses: NSObject, Encodable {
  
  var authorDescription: String?
  var authorId: String?
  var authorImage: String?
  var authorName: String?
  var courseDescription: String?
  var courseId: String?
  var courseTitle: String?
  var overViewImage: String?
  var priceOnSales: Int?
  var priceOrigin: Int?
  var scorePeople: Int?
  var scoreTotal: Double?
  var studentNumber: Int?
  var tags: [String?] = []
  
  var heart: Bool = false
  
}


class AudioItem: NSObject {
  
  var Audio: String?
  var SectionPriority: Int?
  var RowPriority: Int?
  var Time: String?
  var Title: String?
  var Topic: String?
  var TryOutEnable: Int?
  
}


