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
  
  @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
    print("swipe up")
  }
  
  @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
    print("swipe right")
    self.performSegue(withIdentifier: "swipeRight", sender: self)
  }
  @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
    print("swipe down")
    self.performSegue(withIdentifier: "swipeDown", sender: self)
  }
  
  @IBAction func downButtonPressed(_ sender: Any) {
    self.performSegue(withIdentifier: "swipeDown", sender: self)
  }
  
  @IBAction func addSchedule(_ sender: Any) {
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print(lectureArray.count)
    return lectureArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
    
    cell.displayContent(lecture: lectureArray[indexPath.row])
    return cell
  }
  
  // 셀을 선택해서 수정할 때, 세그에 정보를 담아서 보내기 위해서 만드는 중.
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is AddTimeViewController{
      let vc = segue.destination as? AddTimeViewController
      vc?.modifyingLecture = lectureToSend
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    lectureArray = []
    let data = StateStore.shared.classArray
      data.forEach(){ (oneData) in
        lectureArray.append(oneData)
      }
      
      let cellWidth : CGFloat = monLabel.bounds.width
      let cellheight : CGFloat = timeTable.frame.size.height/5
      let cellSize = CGSize(width: cellWidth , height:cellheight)
      
      let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
      layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
      layout.itemSize = cellSize
      layout.minimumInteritemSpacing = 0
      layout.minimumLineSpacing = 0
      timeTable.collectionViewLayout = layout
      timeTable.setCollectionViewLayout(layout, animated: true)
      timeTable.reloadData()
  }
  
  var lectureToSend: Lecture?
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    lectureToSend = lectureArray[indexPath.row]
    performSegue(withIdentifier: "editTimeTableViewSegue", sender: self)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  @IBOutlet weak var monLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
