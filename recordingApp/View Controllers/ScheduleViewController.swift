//
//  ScheduleViewController.swift
//  recordingApp
//
//  Created by 조예진 on 03/05/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
  
  var lectureArray = [Lecture]()
  var lectureToSend: Lecture?

  // 계획!
  
  /*
   
  한시간은 collection view 높이 / 10 정도로 하고,
   collection view는 위아래 스크롤 가능하게 한다.
   
   공백은 자기 셀 높이! 안에서 해결한다. inner공백으로! 여백을 따로 주면 안됨.
  
  셀을 요일별로 분류한다.
  월~금 제일 빠른 시간 중, 가장 빠른 시간을 찾는다.
  월요일부터, 방금 찾은 가장 빠른 시간 기준으로 채우기 시작한다.
  공강 길이 만큼 채운다. 없는 시간은 흰색 칸으로 채운다.
  월~금 중 제일 늦은 시간까지 채우면 끝!
  */
  
  @IBOutlet weak var upButton: UIButton!
  @IBOutlet weak var downButton: UIButton!
  @IBOutlet weak var timeTable: UICollectionView!
  @IBOutlet weak var monLabel: UILabel!

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
  
  // 셀을 선택해서 수정할 때, 세그에 정보를 담아서 보내기 위해서 만드는 중.
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is AddTimeViewController{
      let vc = segue.destination as? AddTimeViewController
      vc?.modifyingLecture = lectureToSend
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    lectureArray = []
    let data = StateStore.shared.classArray
      data.forEach(){ (oneData) in
        lectureArray.append(oneData)}
      timeTable.reloadData()
  }
}

// 콜렉션 뷰 관련 처리
extension ScheduleViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return lectureArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    lectureToSend = lectureArray[indexPath.row]
    performSegue(withIdentifier: "editTimeTableViewSegue", sender: self)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
    cell.displayContent(lecture: lectureArray[indexPath.row])
    return cell
  }

  // layout 관련
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellWidth : CGFloat = monLabel.bounds.size.width
    let cellheight : CGFloat = timeTable.frame.size.height / 5
    let cellSize = CGSize(width: cellWidth , height:cellheight)
    return cellSize
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    // 셀들, 헤더, 푸터 사이의 spacing을 Return 해준다.
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    // 레이아웃에서 각 줄에서 한 줄 사이사이의 공백을 관리한다.
    return ((collectionView.frame.width - 5 * monLabel.frame.width)/4)
  }
}
