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

  func displayContent(className: String?, classTime: String?, classProfessor:String?, classRoom:String?){
    
    classNameLabel?.text = className
    classTimeLabel?.text = classTime
    classProfessorLabel?.text = classProfessor
    classRoomLabel?.text = classRoom
    
    classNameLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    classTimeLabel?.font = UIFont.boldSystemFont(ofSize: 10)
    classProfessorLabel?.font = UIFont.systemFont(ofSize: 10)
    classRoomLabel?.font = UIFont.systemFont(ofSize: 10)
    
    classNameLabel?.textColor = UIColor.white
    classTimeLabel?.textColor = UIColor.white
    classProfessorLabel?.textColor = UIColor.white
    classRoomLabel?.textColor = UIColor.white
  }
}
