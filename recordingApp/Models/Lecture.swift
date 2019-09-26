//
//  Class.swift
//  recordingApp
//
//  Created by 조예진 on 19/09/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import Foundation

struct Lecture {
  var name: String?
  var time: LectureTime?
  var professor: String?
  var room: String?
  var memo: String?
}

class LectureTime {
  var day : LectureDay?
  var startTime : OrdinaryTime?
  var endTime : OrdinaryTime?
  init(day: LectureDay?, startTime: OrdinaryTime?, endTime: OrdinaryTime?){
    self.day = day
    self.startTime = startTime
    self.endTime = endTime
  }
  enum LectureDay: String {
    case mon
    case tue
    case wed
    case thu
    case fri
  }
}

struct OrdinaryTime {
  var hour: Int
//  {
//    if hour >= 0 && hour <= 23 {
//      return hour
//    }
//    else { return 0 }
//  }
  
  var min: Int
//  {
//    if min >= 0 && min <= 59 {
//      return min
//    }
//    else { return 0 }
//  }
 
  init(hour: Int, min: Int){
    self.hour = hour
    self.min = min
  }
}
