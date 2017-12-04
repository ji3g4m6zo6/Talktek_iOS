//
//  Home.swift
//  talkTek
//
//  Created by Mac on 2017/12/3.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import Foundation
import ObjectMapper


class Course: Mappable{
  
  
  
  var authorDescription: String?
  var authorImage: String?
  var authorName: String?
  var courseDescription: String?
  var hour: String?
  var overViewImage: String?
  var score: String?
  var studentNumber: String?
  var title: String?
  
  convenience required init?(map: Map) {
    self.init()
  }
  
  func mapping(map: Map) {
    authorDescription   <- map["authorDescription"]
    authorImage         <- map["authorImage"]
    authorName          <- map["authorName"]
    courseDescription   <- map["courseDescription"]
    hour                <- map["hour"]
    overViewImage       <- map["overViewImage"]
    score               <- map["score"]
    studentNumber       <- map["studentNumber"]
    title               <- map["title"]
  }
  
}

struct CourseCategory {
  
  var keyName: String?
  var presentName: String?
  
}

/*
class CoursesOfEachCategory: NSObject {
  
  var Author: String?
  var CourseDetail: String?
  var People: String?
  var Price: String?
  var Topic: String?
  var TopicImage: String?
  let course: [Course] = []
  
  
  
}



*/

