//
//  Class.swift
//  recordingApp
//
//  Created by 조예진 on 19/09/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import Foundation

struct Lecture : Codable {
  var name: String
  var time: LectureTime
  var professor: String?
  var room: String?
  var memo: String?
  func returnTimeString(lecture: Lecture)->String{
    let _timeStringOfStartTime = "\(lecture.time.startTime.hour)"
      + ":"
      + "\(lecture.time.startTime.min)"
    let _timeStringOfEndTime = "\(lecture.time.endTime.hour)"
      + ":"
      + "\(lecture.time.endTime.min)"
    return _timeStringOfStartTime
      + "~"
      + _timeStringOfEndTime
  }
}

class LectureTime: Codable {
  // day는 월요일부터 1일이다.
  var weekDay : Int
  var startTime : OrdinaryTime
  var endTime : OrdinaryTime
  init(weekDay: Int, startTime: OrdinaryTime, endTime: OrdinaryTime){
    self.weekDay = weekDay
    self.startTime = startTime
    self.endTime = endTime
  }
}

struct OrdinaryTime: Codable {
  // 24시간 체계를 따른다.
  var hour: Int
  var min: Int
  init(hour: Int, min: Int){
    self.hour = hour
    self.min = min
  }
  
  // TODO: 9:00 ~ 11:00 를 리턴해주는 함수 만들기
}
