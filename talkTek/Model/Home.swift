//
//  Home.swift
//  talkTek
//
//  Created by Mac on 2017/12/3.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import Foundation



class Course: NSObject{
  
  var authorDescription: String?
  var authorImage: String?
  var authorName: String?
  var courseDescription: String?
  var hour: String?
  var overViewImage: String?
  var score: String?
  var studentNumber: String?
  var title: String?
  
  
}

class CoursesOfEachCategory: NSObject {
  
  var Author: String?
  var CourseDetail: String?
  var People: String?
  var Price: String?
  var Topic: String?
  var TopicImage: String?
  let course: [Course] = []
  
  
  
}


class CourseCategory: NSObject {
  
  var keyName: String?
  var presentName: String?
  let coursesOfEachCategory: [CoursesOfEachCategory] = []
  
  
}


