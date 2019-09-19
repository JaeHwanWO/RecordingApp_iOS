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
  var days = ["월", "화", "수", "목", "금"]
  
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
    
    cell.displayContent(className: lectureArray[indexPath.row].className, classTime: lectureArray[indexPath.row].startTime as! String, classProfessor: lectureArray[indexPath.row].professor, classRoom: lectureArray[indexPath.row].room)
    
    cell.backgroundColor = UIColor.gray
    cell.layer.cornerRadius = 6.0
    return cell
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //reloadSections같은 함수
    upButton.setImage(UIImage(named: "uparrow_black"), for: .normal)
    downButton.setImage(UIImage(named: "downarrow_black"), for: .normal)
    
    //월,화,수,목,금을 collectionView에 할당해주기
    var mon: classRoom = classRoom(name: "월", time: nil, professor: nil, room: nil)
    var tue: classRoom = classRoom(name: "화", time: nil, professor: nil, room: nil)
    var wed: classRoom = classRoom(name: "수", time: nil, professor: nil, room: nil)
    var thu: classRoom = classRoom(name: "목", time: nil, professor: nil, room: nil)
    var fri: classRoom = classRoom(name: "금", time: nil, professor: nil, room: nil)
    
    var 미적분학: classRoom = classRoom(name: "미적분학", time: "11:00~1:00", professor: "박성민", room: "310관 728호")
    
    lectureArray.append(mon)
    lectureArray.append(tue)
    lectureArray.append(wed)
    lectureArray.append(thu)
    lectureArray.append(fri)
    lectureArray.append(미적분학)
    
    let cellWidth : CGFloat = (timeTable.frame.size.width / 5.0) - 5
    let cellheight : CGFloat = timeTable.frame.size.height/5 - 5
    let cellSize = CGSize(width: cellWidth , height:cellheight)
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical //.horizontal
    layout.itemSize = cellSize
    layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 10, right: 3)
    layout.minimumLineSpacing = 8.0
    //셀끼리 세로로
    layout.minimumInteritemSpacing = 3.0
    //셀끼리 가로로
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
