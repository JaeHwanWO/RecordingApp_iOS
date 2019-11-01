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
  init() {
    name = ""
    time = LectureTime()
  }
  init (time: LectureTime){
    name = ""
    time = time
  }
  init(name: String, time: LectureTime, professor: String?, room: String?, memo: String?){
    self.name = name
    self.time = time
    self.professor = professor
    self.room = room
    self.memo = memo
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
  init() {
    weekDay = -1
    startTime = OrdinaryTime()
    endTime = OrdinaryTime()
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
  init(){
    hour = -1
    min = -1
  }
  func returnTimeString()->String{
    return "\(hour)" + ":" + "\(min)"
  }
}
