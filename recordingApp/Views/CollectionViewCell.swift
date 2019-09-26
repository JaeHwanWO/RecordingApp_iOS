//
//  CollectionViewCell.swift
//  recordingApp
//
//  Created by 조예진 on 05/05/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
  @IBOutlet var classNameLabel: UILabel?
  @IBOutlet var classTimeLabel: UILabel?
  @IBOutlet var classProfessorLabel: UILabel?
  @IBOutlet var classRoomLabel: UILabel?

  func displayContent(className: String?, classTime: LectureTime?, classProfessor:String?, classRoom:String?){
    
    self.backgroundColor = .blue
    self.layer.cornerRadius = self.frame.width / 8
    
    classNameLabel?.text = className
//    classTimeLabel?.text = classTime
    classTimeLabel?.text =
      String(describing: classTime?.startTime?.hour ?? 0)
      + ":"
      + String(describing: classTime?.startTime?.min ?? 0)
      + "~"
      + String(describing: classTime?.endTime?.hour ?? 0)
      + ":"
      + String(describing: classTime?.endTime?.min ?? 0)
    
    print(String(describing: classTime?.startTime?.hour ?? 0))
    classProfessorLabel?.text = classProfessor
    classRoomLabel?.text = classRoom

    classNameLabel?.textColor = UIColor.white
    classTimeLabel?.textColor = UIColor.white
    classProfessorLabel?.textColor = UIColor.white
    classRoomLabel?.textColor = UIColor.white
  }
}
