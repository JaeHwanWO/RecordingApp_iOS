//
//  StateStore.swift
//  recordingApp
//
//  Created by 조예진 on 26/09/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import Foundation
import UserNotifications

class StateStore {
  static let shared = StateStore()
  
  // TODO : 시간표 바뀔 때마다 goPushAlarm() 콜해주기
  static func goPushAlarm(lecture: Lecture){
    let content = UNMutableNotificationContent()
    content.title = "🎙✨강의 녹음할 시간이에요🎙✨"
    content.subtitle = "지금은 " + lecture.name + "수업을 녹음할 시간입니다! 시험기간을 위해서 미리 녹음해주세요😚"
    content.body = String(describing: lecture.time!.startTime!.hour ) + ":" + String(describing: lecture.time!.startTime!.min) + "~" + String(describing: lecture.time?.endTime!.hour) + ":" + String(describing: lecture.time!.endTime!.min) + lecture.name
    var date = DateComponents()
    date.hour = 10
    date.minute = 58
    let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
    let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
  }
}
