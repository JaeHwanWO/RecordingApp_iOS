//
//  ScheduleViewController.swift
//  recordingApp
//
//  Created by 조예진 on 03/05/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  var lectureArray = [Lecture]()
  
  @IBOutlet weak var upButton: UIButton!
  @IBOutlet weak var downButton: UIButton!
  @IBOutlet weak var timeTable: UICollectionView!
  
  @IBAction func upButtonPressed(_ sender: Any) {
    let transition = CATransition()
    transition.duration = 0.5
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromBottom
    view.window!.layer.add(transition, forKey: kCATransition)
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func downButtonPressed(_ sender: Any) {
  }
  
  @IBAction func addSchedule(_ sender: Any) {
    print("add button pressed!")
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print(lectureArray.count)
    return lectureArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
    
    cell.displayContent(className: lectureArray[indexPath.row].name,
                        classTime: lectureArray[indexPath.row].time,
                        classProfessor: lectureArray[indexPath.row].professor,
                        classRoom: lectureArray[indexPath.row].room)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
  
  @IBOutlet weak var monLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //reloadSections같은 함수
    let 미적분학: Lecture = Lecture(name: "미적분학",
                                  time: LectureTime(day: .mon,
                                                    startTime: OrdinaryTime(hour: 9, min: 0),
                                                    endTime: OrdinaryTime(hour: 11, min: 0)),
                                  professor: "박성민",
                                  room: "310관 728호",
                                  memo: nil)
    let 미적분학2: Lecture = Lecture(name: "미적분학", time: nil, professor: "박성민", room: "310관 728호", memo: nil)
    lectureArray.append(미적분학)
    lectureArray.append(미적분학2)
    
    let cellWidth : CGFloat = monLabel.bounds.width
    let cellheight : CGFloat = timeTable.frame.size.height/5 - 5
    let cellSize = CGSize(width: cellWidth , height:cellheight)
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical //.horizontal
    layout.itemSize = cellSize
//    layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 10, right: 3)
//    layout.minimumLineSpacing = 8.0
//    layout.minimumInteritemSpacing = 3.0
    timeTable.setCollectionViewLayout(layout, animated: true)
    timeTable.reloadData()
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
