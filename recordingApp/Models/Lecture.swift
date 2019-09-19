//
//  Class.swift
//  recordingApp
//
//  Created by 조예진 on 19/09/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import Foundation

struct Lecture {
  var name: String
  var time: [Times]
  var professor: String?
  var room: String?
  var memo: String?
}

struct Times{
  var startTime: Date
  var endTime: Date
}
