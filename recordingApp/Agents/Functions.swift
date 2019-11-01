//
//  Functions.swift
//  recordingApp
//
//  Created by 조예진 on 2019/10/28.
//  Copyright © 2019 조예진. All rights reserved.
//

import Foundation
import os

func DebugLog(_ value: Any..., file: String = #file, line: Int = #line, function: String = #function) {
    let kLog = "\(file.components(separatedBy: "/").last ?? "") line: \(line), function: \(function)"
    
    os_log("%@", type: .debug, "\(kLog) \(value)")
}
