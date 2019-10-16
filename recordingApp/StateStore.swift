//
//  StateStore.swift
//  recordingApp
//
//  Created by 조예진 on 26/09/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import Foundation
import UserNotifications
import NotificationCenter


class StateStore {
  
  // TODO : UserDefaults가 나의 custom class를 지원하도록 수정해보자
  // classArray를 NsData로 바꿔보기
  let encoder = JSONEncoder()
  let decoder = JSONDecoder()
  static let shared = StateStore()
  
  var classArray: [Lecture] {
    get{
      let decoded = try! decoder.decode([Lecture].self, from:  UserDefaults.standard.object(forKey: "classArray") as! Data)
      return decoded
    }
    set(newValue){
      let encoded = try! encoder.encode(newValue)
      UserDefaults.standard.setValue(encoded, forKey: "classArray")
    }
  }
  
  init() {
    // 처음 앱이 켜졌을 때, UserDefaults 데이터를 불러와서 담아준다.
    let data = UserDefaults.standard.object(forKey: "classArray")
    var decoded: [Lecture] = []
    if data != nil{
      decoded = try! decoder.decode([Lecture].self, from: data as! Data)
    }
    classArray = decoded
    
  }
  
  static func registerPushAlarm(lecture: Lecture){
    let content = UNMutableNotificationContent()
    content.title = "🎙✨강의 녹음할 시간이에요🎙✨"
    content.subtitle = "지금은 " + lecture.name + "수업을 녹음할 시간입니다! 시험기간을 위해!!😚"
    content.body = lecture.returnTimeString(lecture: lecture)
    content.sound = .default
    var date = DateComponents()
    date.hour = lecture.time.startTime.hour
    date.minute = lecture.time.startTime.min
    let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
    let request = UNNotificationRequest(identifier: lecture.name, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
  }
  
  static func deletePushAlarm(lecture:Lecture){
    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [lecture.name])
  }
}

public extension UINavigationController {
  func pushViewControllerFromTop(viewController vc: UIViewController) {
    vc.view.alpha = 0
    self.present(vc, animated: false) { () -> Void in
      vc.view.frame = CGRect(x: 0, y: -vc.view.frame.height, width: vc.view.frame.width, height: vc.view.frame.height)
      vc.view.alpha = 1
      UIView.animate(withDuration: 1,
                     animations: { () -> Void in
                      vc.view.frame = CGRect(x: 0, y: 0, width: vc.view.frame.width, height: vc.view.frame.height)
      },
                     completion: nil)
    }
  }
  
  func dismissViewControllerToTop() {
    if let vc = self.presentedViewController {
      UIView.animate(withDuration: 1,
                     animations: { () -> Void in
                      vc.view.frame = CGRect(x: 0, y: -vc.view.frame.height, width: vc.view.frame.width, height: vc.view.frame.height)
      },
                     completion: { complete -> Void in
                      if complete {
                        self.dismiss(animated: false, completion: nil)
                      }
      })
    }
  }
}
