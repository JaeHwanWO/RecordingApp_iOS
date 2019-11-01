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
  
  let colorBlue = [UIColor(named: "Blue_1"), UIColor(named:"Blue_2")]
  let colorGreen = [UIColor(named:"Green_1"), UIColor(named:"Green_2")]
  let colorOrange = [UIColor(named:"Orange_1"), UIColor(named:"Orange_2")]
  
  func displayContent(lecture: Lecture){
    
    // 배경색 그라디언트 지정해주기
    let gradient: CAGradientLayer = CAGradientLayer()
    gradient.colors = [colorBlue[0]!, colorBlue[1]!]
    gradient.locations = [0.0 , 1.0]
    gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
    gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
    gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
    self.contentView.layer.insertSublayer(gradient, at: 0)
    
    // 그림자 삽입
    // Shadow : #000000 16% X: 0 Y: 3 B: 6
    self.contentView.dropShadow(offsetX: 0, offsetY: 3, color: UIColor.black, opacity: 0.16, radius: 6)
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

extension UIView {
  func dropShadow(offsetX: CGFloat, offsetY: CGFloat, color: UIColor, opacity: Float, radius: CGFloat, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowRadius = radius
    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}
