//
//  Notification.swift
//  recordingApp
//
//  Created by 조예진 on 11/05/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit
import UserNotifications

class Notification: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
 /*
   func goPushAlarm(){
        let content = UNMutableNotificationContent()
        content.title = "🎙✨강의 녹음할 시간이에요🎙✨"
        content.subtitle = "지금은 미적분학 수업을 녹음할 시간입니다! 시험기간을 위해서 미리 녹음해주세요😚"
        content.body = "11:00 AM ~ 1:00 PM 미적분학"
    
    
        var date = DateComponents()
        date.hour = 1
        date.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
 
 */
    
   

}
