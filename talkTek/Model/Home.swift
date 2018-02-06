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
  var authorImage: String?
  var authorName: String?
  var courseDescription: String?
  var hour: String?
  var overViewImage: String?
  var price: String?
  var score: String?
  var studentNumber: String?
  var title: String?
  var courseId: String?
  var teacherID: String?
  
  
  
}


class AudioItem: NSObject{
  
  var Audio: String?
  var Time: String?
  var Topic: String?
  var Title: String?
  var Section: String?
  
  var SectionPriority: Int?
  var RowPriority: Int?
}

/*
class HomeCourses: NSObject, Mappable {
  
  var authorDescription: String?
  var authorImage: String?
  var authorName: String?
  var courseDescription: String?
  var hour: String?
  var overViewImage: String?
  var price: String?
  var score: String?
  var studentNumber: String?
  var title: String?
  var courseId: String?
  var teacherID: String?
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    
    authorDescription   <- map["authorDescription"]
    authorImage         <- map["authorImage"]
    authorName          <- map["authorName"]
    courseDescription   <- map["courseDescription"]
    hour                <- map["hour"]
    overViewImage       <- map["overViewImage"]
    price               <- map["price"]
    score               <- map["score"]
    studentNumber       <- map["studentNumber"]
    title               <- map["title"]
    courseId            <- map["courseId"]
    teacherID           <- map["teacherID"]
    
  }
 
}
*/
