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

  func displayContent(lecture: Lecture){
    
    self.backgroundColor = .blue
    self.layer.cornerRadius = self.frame.width / 8
    
    classNameLabel?.text = lecture.name
    classTimeLabel?.text = lecture.returnTimeString(lecture: lecture)
    classProfessorLabel?.text = lecture.professor
    classRoomLabel?.text = lecture.room

    classNameLabel?.textColor = UIColor.white
    classTimeLabel?.textColor = UIColor.white
    classProfessorLabel?.textColor = UIColor.white
    classRoomLabel?.textColor = UIColor.white
  }
}
